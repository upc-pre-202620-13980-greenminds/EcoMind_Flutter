import 'dart:convert';
import 'dart:io';

import 'package:ecomind_parents/core/api_config.dart';
import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/family_dto.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/friend_dto.dart';
import 'package:http/http.dart' as http;

class FamilyApi {
  Map<String, String> _headers(String accessToken) => {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  // Read as UTF-8 so names with accents are not broken
  dynamic _decode(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  // The backend has no GET /family/{id}, so the family is looked for in this list
  Future<List<FamilyDto>> getFamilies(String accessToken) async {
    final http.Response response = await http
        .get(ApiConfig.uri('/api/v1/family'), headers: _headers(accessToken))
        .timeout(ApiConfig.timeout);

    if (response.statusCode == HttpStatus.ok) {
      final List jsons = _decode(response);
      return jsons.map((e) => FamilyDto.fromJson(e)).toList();
    }
    throw ApiException.fromResponse(response);
  }

  // Without userId it returns the members of every family
  Future<List<FamilyMemberDto>> getMemberships(
    String accessToken, {
    int? userId,
  }) async {
    final http.Response response = await http
        .get(
          ApiConfig.uri(
            '/api/v1/family_user',
            userId == null ? null : {'user_id': '$userId'},
          ),
          headers: _headers(accessToken),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == HttpStatus.ok) {
      final List jsons = _decode(response);
      return jsons.map((e) => FamilyMemberDto.fromJson(e)).toList();
    }
    throw ApiException.fromResponse(response);
  }

  Future<FamilyDto> createFamily(
    String accessToken,
    String name,
    String commitment,
  ) async {
    final http.Response response = await http
        .post(
          ApiConfig.uri('/api/v1/family'),
          headers: _headers(accessToken),
          body: jsonEncode({'name': name, 'commitment': commitment}),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == HttpStatus.created) {
      return FamilyDto.fromJson(_decode(response));
    }
    throw ApiException.fromResponse(response);
  }

  Future<FamilyDto> addMember(
    String accessToken,
    int familyId,
    int userId,
    String familyRole,
  ) async {
    final http.Response response = await http
        .post(
          ApiConfig.uri('/api/v1/family_user'),
          headers: _headers(accessToken),
          body: jsonEncode({
            'familyId': familyId,
            'userId': userId,
            'familyRole': familyRole,
          }),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == HttpStatus.created) {
      return FamilyDto.fromJson(_decode(response));
    }
    throw ApiException.fromResponse(response);
  }

  Future<void> removeMember(String accessToken, int membershipId) async {
    final http.Response response = await http
        .delete(
          ApiConfig.uri('/api/v1/family_user/$membershipId'),
          headers: _headers(accessToken),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != HttpStatus.noContent) {
      throw ApiException.fromResponse(response);
    }
  }

  // Friend requests that the user sent or received, in any state
  Future<List<FriendDto>> getFriends(String accessToken, int userId) async {
    final http.Response response = await http
        .get(
          ApiConfig.uri('/api/v1/friend', {'user_id': '$userId'}),
          headers: _headers(accessToken),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == HttpStatus.ok) {
      final List jsons = _decode(response);
      return jsons.map((e) => FriendDto.fromJson(e)).toList();
    }
    throw ApiException.fromResponse(response);
  }
}
