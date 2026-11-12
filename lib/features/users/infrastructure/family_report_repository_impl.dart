import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_report_repository.dart';
import 'package:ecomind_parents/features/users/domain/family_weekly_report.dart';
import 'package:ecomind_parents/features/users/infrastructure/local/weekly_quests_local_data_source.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/gamification_api.dart';
import 'package:ecomind_parents/features/users/infrastructure/users_request_guard.dart';

class FamilyReportRepositoryImpl implements FamilyReportRepository {
  final WeeklyQuestsLocalDataSource questsDataSource;
  final GamificationApi gamificationApi;
  final SessionRepository sessionRepository;

  const new({
    required this.questsDataSource,
    required this.gamificationApi,
    required this.sessionRepository,
  });

  @override
  Future<FamilyWeeklyReport> getWeeklyReport(Family family) async {
    final quests = questsDataSource.getForFamily(family);

    // HU-021: without quests the report is not generated, so nothing else is read
    if (quests.completed == 0) {
      return FamilyWeeklyReport(
        familyName: family.name,
        completedQuests: 0,
        totalQuests: 0,
        achievementsEarned: 0,
      );
    }

    return FamilyWeeklyReport(
      familyName: family.name,
      completedQuests: quests.completed,
      totalQuests: quests.total,
      achievementsEarned: await _achievementsThisWeek(family),
    );
  }

  Future<int> _achievementsThisWeek(Family family) async {
    try {
      final awards = await guardUsersRequest(
        sessionRepository,
        (session) => gamificationApi.getFamilyAchievements(
          session.accessToken,
          family.id,
        ),
      );
      final weekStart = _startOfWeek(DateTime.now());
      final weekEnd = weekStart.add(const Duration(days: 7));
      return awards.where((award) {
        final awardedAt = DateTime.parse(award.awardedAt).toLocal();
        return !awardedAt.isBefore(weekStart) && awardedAt.isBefore(weekEnd);
      }).length;
    } catch (e) {
      // Gamification is another context: if it does not answer, the sample is used
      return questsDataSource.sampleAchievements(family);
    }
  }

  // Monday at 00:00, in the time of the device
  DateTime _startOfWeek(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return today.subtract(Duration(days: today.weekday - DateTime.monday));
  }
}
