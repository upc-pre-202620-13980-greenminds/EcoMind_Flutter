import 'dart:convert';
import 'dart:io';

import 'package:ecomind_parents/core/api_config.dart';
import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/quests/domain/quest.dart';
import 'package:http/http.dart' as http;

class QuestRepository {
  const new({required SessionRepository sessionRepository})
    : _sessions = sessionRepository;

  final SessionRepository _sessions;

  Future<List<Quest>> getCatalog() async {
    final data = await _request('/quests') as List<dynamic>;
    return data.cast<Map<String, dynamic>>().map(_quest).toList();
  }

  Future<List<Quest>> search(String title) async {
    final data = await _request(
      '/quests/search',
      query: {'title': title},
    ) as List<dynamic>;
    return data.cast<Map<String, dynamic>>().map(_quest).toList();
  }

  Future<PendingQuest?> getPending() async {
    // Reading IN_PROGRESS also lets the backend update the daily quest.
    final inProgress = await _byStatus('IN_PROGRESS');
    final ready = await _byStatus('READY_TO_COMPLETE');
    final assignments = [...inProgress, ...ready]
      ..sort((a, b) => b.id.compareTo(a.id));

    for (final assignment in assignments) {
      final data = await _request(
        '/quests/${assignment.questId}',
        allowNotFound: true,
      );
      if (data != null) {
        return (quest: _quest(data), assignment: assignment);
      }
    }
    return null;
  }

  Future<QuestDetails> getDetails(Quest quest, {int? assignmentId}) async {
    final (assignment, activityData) = await (
      _findAssignment(quest.id, assignmentId),
      _request('/activities/quest/${quest.id}'),
    ).wait;
    final rows = (activityData as List).cast<Map<String, dynamic>>().toList()
      ..sort((a, b) => (a['order'] as int).compareTo(b['order'] as int));
    final saved = <int, Map<String, dynamic>>{};
    if (assignment != null) {
      final items =
          await _request('/activity-users/quest-user/${assignment.id}') as List;
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

  Future<int> start(int questId) async {
    final data = await _request('/quest-users', body: {'questId': questId});
    return _assignment(data).id;
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
  );
}
