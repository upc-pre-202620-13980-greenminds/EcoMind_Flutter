import 'package:ecomind_parents/features/users/domain/notification_category.dart';

// The four categories of frame 83; all of them are on by default
class NotificationPreferences {
  final bool achievements;
  final bool weeklySummary;
  final bool communityEvents;
  final bool communityActivity;

  const new({
    this.achievements = true,
    this.weeklySummary = true,
    this.communityEvents = true,
    this.communityActivity = true,
  });

  // Category of the backend -> preference of the parent.
  // Quests and learning reminders are for students, so the parent never sees them.
  bool allows(NotificationCategory category) {
    return switch (category) {
      NotificationCategory.achievementsAndBadges => achievements,
      NotificationCategory.weeklyProgressSummary => weeklySummary,
      NotificationCategory.communityEvents => communityEvents,
      NotificationCategory.communityActivity => communityActivity,
      NotificationCategory.newAndDailyQuests => false,
      NotificationCategory.learningReminders => false,
      NotificationCategory.unknown => false,
    };
  }

  NotificationPreferences copyWith({
    bool? achievements,
    bool? weeklySummary,
    bool? communityEvents,
    bool? communityActivity,
  }) {
    return NotificationPreferences(
      achievements: achievements ?? this.achievements,
      weeklySummary: weeklySummary ?? this.weeklySummary,
      communityEvents: communityEvents ?? this.communityEvents,
      communityActivity: communityActivity ?? this.communityActivity,
    );
  }
}
