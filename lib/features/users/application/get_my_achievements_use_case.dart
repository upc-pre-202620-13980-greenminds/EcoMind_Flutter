import 'package:ecomind_parents/features/users/domain/achievement_repository.dart';
import 'package:ecomind_parents/features/users/domain/my_achievement.dart';

class GetMyAchievementsUseCase {
  final AchievementRepository repository;

  const new({required this.repository});

  Future<List<MyAchievement>> execute() {
    return repository.getMyAchievements();
  }
}
