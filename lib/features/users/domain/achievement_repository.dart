import 'package:ecomind_parents/features/users/domain/my_achievement.dart';

// Medals of the profile; they belong to Gamification, so they are only read
abstract class AchievementRepository {
  Future<List<MyAchievement>> getMyAchievements();
}
