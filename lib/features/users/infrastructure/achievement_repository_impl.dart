import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/users/domain/achievement_repository.dart';
import 'package:ecomind_parents/features/users/domain/my_achievement.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/gamification_api.dart';
import 'package:ecomind_parents/features/users/infrastructure/users_request_guard.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  final GamificationApi gamificationApi;
  final SessionRepository sessionRepository;

  const new({required this.gamificationApi, required this.sessionRepository});

  @override
  Future<List<MyAchievement>> getMyAchievements() {
    return guardUsersRequest(sessionRepository, (session) async {
      final awards = await gamificationApi.getMyAchievements(
        session.accessToken,
      );
      final catalog = await gamificationApi.getAchievementCatalog(
        session.accessToken,
      );
      final names = {
        for (final achievement in catalog) achievement.id: achievement.name,
      };

      // Only the individual medals of the user, as in the student app
      return awards
          .where(
            (award) =>
                award.scope == 'INDIVIDUAL' &&
                award.beneficiaryId == session.accountId &&
                names.containsKey(award.achievementId),
          )
          .map(
            (award) => MyAchievement(
              awardId: award.id,
              name: names[award.achievementId]!,
            ),
          )
          .toList();
    });
  }
}
