import 'dart:convert';
import 'dart:io';

import 'package:ecomind_parents/core/api_config.dart';
import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/notification_dto.dart';
import 'package:http/http.dart' as http;

// Inbox of the authenticated user; the user always comes from the token
class NotificationApi {
  Future<List<NotificationDto>> getNotifications(
    String accessToken,
    String languageTag,
  ) async {
    final http.Response response = await http
        .get(
          ApiConfig.uri('/api/v1/notification'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            // The backend writes the texts in this language
            'Accept-Language': languageTag,
          },
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == HttpStatus.ok) {
      final List jsons = jsonDecode(utf8.decode(response.bodyBytes));
      return jsons.map((e) => NotificationDto.fromJson(e)).toList();
    }
    throw ApiException.fromResponse(response);
  }

  Future<void> markAsRead(String accessToken, int notificationId) async {
    final http.Response response = await http
        .patch(
          ApiConfig.uri('/api/v1/notification/$notificationId/read'),
          headers: {'Authorization': 'Bearer $accessToken'},
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != HttpStatus.ok) {
      throw ApiException.fromResponse(response);
    }
  }

  Future<void> markAllAsRead(String accessToken) async {
    final http.Response response = await http
        .patch(
          ApiConfig.uri('/api/v1/notification/read-all'),
          headers: {'Authorization': 'Bearer $accessToken'},
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode != HttpStatus.noContent) {
      throw ApiException.fromResponse(response);
    }
  }
}
