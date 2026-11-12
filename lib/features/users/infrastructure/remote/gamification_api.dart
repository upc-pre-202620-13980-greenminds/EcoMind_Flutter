import 'dart:convert';
import 'dart:io';

import 'package:ecomind_parents/core/api_config.dart';
import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/achievement_award_dto.dart';
import 'package:http/http.dart' as http;

// Endpoint of the Gamification context that the weekly report reads
class GamificationApi {
  // The newest awards come first; 100 is the largest page the backend allows
  Future<List<AchievementAwardDto>> getFamilyAchievements(
    String accessToken,
    int familyId,
  ) async {
    final http.Response response = await http
        .get(
          ApiConfig.uri(
            '/api/v1/gamification/families/$familyId/achievements',
            {'page': '0', 'size': '100'},
          ),
          headers: {'Authorization': 'Bearer $accessToken'},
        )
        .timeout(ApiConfig.timeout);

    if (response.statusCode == HttpStatus.ok) {
      final List jsons = jsonDecode(utf8.decode(response.bodyBytes));
      return jsons.map((e) => AchievementAwardDto.fromJson(e)).toList();
    }
    throw ApiException.fromResponse(response);
  }
}
