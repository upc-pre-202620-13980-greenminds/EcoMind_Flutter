import 'dart:convert';
import 'dart:io';

import 'package:ecomind_parents/core/api_config.dart';
import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/quests/domain/quest.dart';
import 'package:ecomind_parents/features/quests/domain/quest_filters.dart';
import 'package:http/http.dart' as http;

class QuestRepository {
  new({required SessionRepository sessionRepository})
    : _sessions = sessionRepository;

  final SessionRepository _sessions;
  static const _searchCacheDuration = Duration(minutes: 2);
  ({String title, DateTime expires, Future<List<Quest>> data})? _titleSearch;

  Future<List<Quest>> getCatalog() async {
    final data = await _request('/quests') as List<dynamic>;
    return data.cast<Map<String, dynamic>>().map(_quest).toList();
  }

  Future<List<Quest>> search(
    String title, {
    QuestFilters filters = const QuestFilters(),
  }) async {
    return (await _searchByTitle(title))
        .where((quest) => quest.type != 'FAMILY' && filters.matches(quest))
        .toList();
  }

  Future<List<Quest>> _searchByTitle(String title) async {
    final now = DateTime.now();
    final cached = _titleSearch;
    if (cached != null &&
        cached.title == title &&
        now.isBefore(cached.expires)) {
      return cached.data;
    }
    final data = _request('/quests/search', query: {'title': title}).then(
      (json) =>
          (json as List).cast<Map<String, dynamic>>().map(_quest).toList(),
    );
    _titleSearch = (
      title: title,
      expires: now.add(_searchCacheDuration),
      data: data,
    );
    try {
      return await data;
    } catch (_) {
      if (identical(_titleSearch?.data, data)) _titleSearch = null;
      rethrow;
    }
  }

  Future<List<PendingQuest>> getPending() async {
    // Reading IN_PROGRESS also lets the backend update the daily quest.
    final inProgress = await _byStatus('IN_PROGRESS');
    final ready = await _byStatus('READY_TO_COMPLETE');
    final assignments = [...inProgress, ...ready]
      ..sort((a, b) => b.id.compareTo(a.id));

    PendingQuest? daily;
    PendingQuest? regular;
    const batchSize = 4;
    for (var index = 0; index < assignments.length; index += batchSize) {
      final batch = await Future.wait(
        assignments.skip(index).take(batchSize).map((assignment) async {
          final data = await _request(
            '/quests/${assignment.questId}',
            allowNotFound: true,
          );
          return data == null
              ? null
              : (quest: _quest(data), assignment: assignment);
        }),
      );
      for (final pending in batch.nonNulls) {
        if (pending.quest.isDaily) {
          daily ??= pending;
        } else {
          regular ??= pending;
        }
      }
      if (daily != null && regular != null) break;
    }
    return [?regular, ?daily];
  }

  Future<List<QuestProgressEntry>> getProgress() async {
    // The active lookup initializes today's daily quest before reading history.
    final (assignmentsByStatus, catalog) = await (
      _progressAssignments(),
      getCatalog(),
    ).wait;
    final assignments = {
      for (final assignment in assignmentsByStatus) assignment.id: assignment,
    }.values;
    final quests = {for (final quest in catalog) quest.id: quest};
    final questIds = assignments
        .map((assignment) => assignment.questId)
        .toSet()
        .where((id) => !quests.containsKey(id))
        .toList();
    const batchSize = 4;
    for (var index = 0; index < questIds.length; index += batchSize) {
      final batch = await Future.wait(
        questIds.skip(index).take(batchSize).map((id) async {
          final data = await _request('/quests/$id', allowNotFound: true);
          return data == null ? null : _quest(data);
        }),
      );
      for (final quest in batch.nonNulls) {
        quests[quest.id] = quest;
      }
    }

    return [
      for (final assignment in assignments)
        (quest: quests[assignment.questId], assignment: assignment),
    ];
  }

  Future<List<QuestAssignment>> _progressAssignments() async {
    final active = await _byStatus('IN_PROGRESS');
    final (ready, completed) = await (
      _byStatus('READY_TO_COMPLETE'),
      _byStatus('COMPLETED'),
    ).wait;
    return [...active, ...ready, ...completed];
  }

  Future<QuestDetails> getDetails(
    Quest quest, {
    int? assignmentId,
    QuestAssignment? knownAssignment,
  }) async {
    final (assignment, activityData, savedActivities) = await (
      knownAssignment == null
          ? _findAssignment(quest.id, assignmentId)
          : Future.value(knownAssignment),
      _request('/activities/quest/${quest.id}'),
      _savedActivities(knownAssignment?.id ?? assignmentId),
    ).wait;
    final rows = (activityData as List).cast<Map<String, dynamic>>().toList()
      ..sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));
    final saved = <int, Map<String, dynamic>>{};
    if (assignment != null) {
      final items = savedActivities ?? (await _savedActivities(assignment.id))!;
      for (final item in items.cast<Map<String, dynamic>>()) {
        saved[item['activityId'] as int] = item;
      }
    }
    return (
      assignment: assignment,
      activities: rows.map((row) {
        final item = saved[row['id']];
        final config = item?['activityConfiguration'] as Map<String, dynamic>?;
        final prompt = item?['activityDescription'] as String?;
        return QuestActivity(
          description: prompt == null || prompt.trim().isEmpty
              ? row['description'] as String
              : prompt,
          type: row['type'] as String,
          assignmentId: item?['id'] as int?,
          isComplete: ((item?['progress'] as num?) ?? 0) >= 100,
          minCharacters: (config?['minCharacters'] as int?) ?? 1,
          response: item?['responseText'] as String?,
        );
      }).toList(),
    );
  }

  Future<List<dynamic>?> _savedActivities(int? assignmentId) async {
    if (assignmentId == null) return null;
    return await _request('/activity-users/quest-user/$assignmentId') as List;
  }

  Future<QuestAssignment?> _findAssignment(
    int questId,
    int? assignmentId,
  ) async {
    final data = await _request(
      assignmentId == null
          ? '/quest-users/me/quest/$questId'
          : '/quest-users/$assignmentId',
      allowNotFound: assignmentId == null,
    );
    return data == null ? null : _assignment(data);
  }

  Future<QuestAssignment> start(int questId) async {
    final data = await _request('/quest-users', body: {'questId': questId});
    return _assignment(data);
  }

  Future<({QuestAssignment assignment, bool isComplete, String? response})>
  submit(int activityId, Map<String, Object> value) async {
    final data = await _request(
      '/activity-users/$activityId/submit',
      body: {'data': value},
    ) as Map<String, dynamic>;
    final assignment = _assignment(
      await _request('/quest-users/${data['questUserId']}'),
    );
    return (
      assignment: assignment,
      isComplete: (data['progress'] as num) >= 100,
      response: data['responseText'] as String?,
    );
  }

  Future<void> finish(int assignmentId) async {
    await _request('/quest-users/$assignmentId/complete', body: const {});
  }

  Future<List<QuestAssignment>> _byStatus(String status) async {
    final data = await _request('/quest-users/me/status/$status') as List;
    return data.cast<Map<String, dynamic>>().map(_assignment).toList();
  }

  Future<dynamic> _request(
    String path, {
    Map<String, String>? query,
    Map<String, Object>? body,
    bool allowNotFound = false,
  }) async {
    final session = await _sessions.getSession();
    if (session == null || session.isExpired(DateTime.now())) {
      throw const ApiException(
        statusCode: 401,
        code: 'UNAUTHORIZED',
        message: '',
      );
    }
    final uri = ApiConfig.uri('/api/v1$path', query);
    final headers = {'Authorization': 'Bearer ${session.accessToken}'};
    final request = body == null
        ? http.get(uri, headers: headers)
        : http.post(
            uri,
            headers: {...headers, 'Content-Type': 'application/json'},
            body: jsonEncode(body),
          );
    final response = await request.timeout(ApiConfig.timeout);
    if (allowNotFound && response.statusCode == HttpStatus.notFound) {
      return null;
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException.fromResponse(response);
    }
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  Quest _quest(Map<String, dynamic> json) => Quest(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    theme: json['theme'] as String? ?? '',
    type: json['type'] as String,
    age: json['age'] as int?,
    minutes: json['time'] as int?,
    category: json['category'] as String?,
    imageUrl: json['image'] as String?,
    ecopoints: json['ecopoints'] as int? ?? 0,
    gems: json['gemReward'] as int? ?? 0,
  );

  QuestAssignment _assignment(Map<String, dynamic> json) => QuestAssignment(
    id: json['id'] as int,
    questId: json['questId'] as int,
    status: json['status'] as String,
    progress: (json['progress'] as num?)?.toDouble() ?? 0,
    collaborativeSessionId: json['collaborativeSessionId'] as int?,
    endDate: DateTime.tryParse(json['endDate'] as String? ?? ''),
  );
}
