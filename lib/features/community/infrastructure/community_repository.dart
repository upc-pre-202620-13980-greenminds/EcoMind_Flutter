import 'dart:convert';

import 'package:ecomind_parents/core/api_config.dart';
import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:http/http.dart' as http;

import '../domain/community.dart';

class CommunityRepository {
  CommunityRepository({required SessionRepository sessionRepository})
    : _sessions = sessionRepository;

  final SessionRepository _sessions;

  Future<CommunityDirectory> getDirectory(String locality) async {
    final (communities, memberships) = await (
      _request('/Communities', query: {'type': 'local', 'locality': locality}),
      _request('/Memberships'),
    ).wait;

    return (
      communities: (communities as List).map((item) {
        final json = item as Map<String, dynamic>;
        return Community(
          id: (json['id'] as num).toInt(),
          name: json['name'] as String,
          description: json['description'] as String? ?? '',
          locality: json['locality'] as String? ?? '',
          iconUrl: json['icon_url'] as String?,
        );
      }).toList(),
      membershipIds: (memberships as List)
          .map((item) => (item['community_id'] as num).toInt())
          .toSet(),
    );
  }

  Future<void> join(int communityId) async {
    await _request('/Communities/$communityId/Memberships', post: true);
  }

  Future<List<CommunityEvent>> getEvents(int communityId) async {
    final data = await _request(
      '/Events',
      query: {'community_id': '$communityId'},
    );

    return (data as List).map((item) {
      final json = item as Map<String, dynamic>;
      return CommunityEvent(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        location: json['location'] as String? ?? '',
        availablePlaces: (json['capacity'] as num?)?.toInt() ?? 0,
        imageUrl: json['image_url'] as String?,
      );
    }).toList();
  }

  Future<CommunityGoal?> getGoal(int communityId) async {
    final data = await _request(
      '/Community-goals/Panel',
      query: {'community_id': '$communityId'},
    ) as Map<String, dynamic>;

    final json = data['goal'] as Map<String, dynamic>?;
    if (json == null) return null;

    return CommunityGoal(
      title: json['title'] as String,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      target: (json['target'] as num?)?.toInt() ?? 0,
    );
  }

  Future<dynamic> _request(
    String path, {
    Map<String, String>? query,
    bool post = false,
  }) async {
    final session = await _sessions.getSession();

    if (session == null || session.isExpired(DateTime.now())) {
      throw const ApiException(
        statusCode: 401,
        code: 'UNAUTHORIZED',
        message: '',
      );
    }

    final uri = ApiConfig.uri('/api/v1/Community$path', query);
    final headers = {
      'Authorization': 'Bearer ${session.accessToken}',
      'Accept': 'application/json',
    };

    final response =
        await (post
                ? http.post(uri, headers: headers)
                : http.get(uri, headers: headers))
            .timeout(ApiConfig.timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException.fromResponse(response);
    }

    final body = utf8.decode(response.bodyBytes);
    return body.trim().isEmpty ? null : jsonDecode(body);
  }
}
