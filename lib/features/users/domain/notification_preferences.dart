import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/users/domain/notification_category.dart';

// Categories of frame 70 (student) and frame 83 (parent); all of them are on by default
class NotificationPreferences {
  final bool newQuests;
  final bool learningReminders;
  final bool achievements;
  final bool weeklySummary;
  final bool communityEvents;
  final bool communityActivity;

  const new({
    this.newQuests = true,
    this.learningReminders = true,
    this.achievements = true,
    this.weeklySummary = true,
    this.communityEvents = true,
    this.communityActivity = true,
  });

  // Category of the backend -> preference of the user.
  // Quests and learning reminders are for students, so a parent never sees them (frame 83).
  bool allows(NotificationCategory category, SocialRole role) {
    final isStudent = role == SocialRole.student;
    return switch (category) {
      NotificationCategory.newAndDailyQuests => isStudent && newQuests,
      NotificationCategory.learningReminders => isStudent && learningReminders,
      NotificationCategory.achievementsAndBadges => achievements,
      NotificationCategory.weeklyProgressSummary => weeklySummary,
      NotificationCategory.communityEvents => communityEvents,
      NotificationCategory.communityActivity => communityActivity,
      NotificationCategory.unknown => false,
    };
  }

  NotificationPreferences copyWith({
    bool? newQuests,
    bool? learningReminders,
    bool? achievements,
    bool? weeklySummary,
    bool? communityEvents,
    bool? communityActivity,
  }) {
    return NotificationPreferences(
      newQuests: newQuests ?? this.newQuests,
      learningReminders: learningReminders ?? this.learningReminders,
      achievements: achievements ?? this.achievements,
      weeklySummary: weeklySummary ?? this.weeklySummary,
      communityEvents: communityEvents ?? this.communityEvents,
      communityActivity: communityActivity ?? this.communityActivity,
    );
  }
}
