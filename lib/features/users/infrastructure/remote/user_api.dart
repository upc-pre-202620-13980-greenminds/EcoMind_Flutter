import 'dart:convert';
import 'dart:io';

import 'package:ecomind_parents/core/api_config.dart';
import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/user_profile_dto.dart';
import 'package:http/http.dart' as http;

class UserApi {
  // Every profile; the family screens use it to show the names of the members
  Future<List<UserProfileDto>> getUsers(String accessToken) async {
    final http.Response response = await http
        .get(
          ApiConfig.uri('/api/v1/user'),
          headers: {'Authorization': 'Bearer $accessToken'},
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == HttpStatus.ok) {
      final List jsons = jsonDecode(utf8.decode(response.bodyBytes));
      return jsons.map((e) => UserProfileDto.fromJson(e)).toList();
    }
    throw ApiException.fromResponse(response);
  }

  Future<UserProfileDto> getUser(String accessToken, int id) async {
    final http.Response response = await http
        .get(
          ApiConfig.uri('/api/v1/user/$id'),
          headers: {'Authorization': 'Bearer $accessToken'},
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == HttpStatus.ok) {
      // Read as UTF-8 so names with accents are not broken
      return UserProfileDto.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
      );
    }
    throw ApiException.fromResponse(response);
  }

  Future<UserProfileDto> updateUser(
    String accessToken,
    UserProfileDto profile,
  ) async {
    final http.Response response = await http
        .put(
          ApiConfig.uri('/api/v1/user/${profile.id}'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(profile.toUpdateJson()),
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == HttpStatus.ok) {
      return UserProfileDto.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)),
      );
    }
    throw ApiException.fromResponse(response);
  }
}
