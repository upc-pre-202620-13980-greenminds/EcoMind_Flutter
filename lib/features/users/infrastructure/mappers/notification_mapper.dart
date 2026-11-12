import 'package:ecomind_parents/features/users/domain/app_notification.dart';
import 'package:ecomind_parents/features/users/domain/notification_category.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/notification_dto.dart';

extension NotificationDtoMapper on NotificationDto {
  AppNotification toDomain() {
    return AppNotification(
      id: id,
      category: _categoryFor(category),
      title: title,
      message: message,
      isRead: read,
      createdAt: DateTime.parse(createdAt),
    );
  }

  NotificationCategory _categoryFor(String value) {
    return switch (value) {
      'NEW_AND_DAILY_QUESTS' => NotificationCategory.newAndDailyQuests,
      'LEARNING_REMINDERS' => NotificationCategory.learningReminders,
      'ACHIEVEMENTS_AND_BADGES' => NotificationCategory.achievementsAndBadges,
      'WEEKLY_PROGRESS_SUMMARY' => NotificationCategory.weeklyProgressSummary,
      'COMMUNITY_EVENTS' => NotificationCategory.communityEvents,
      'COMMUNITY_ACTIVITY' => NotificationCategory.communityActivity,
      _ => NotificationCategory.unknown,
    };
  }
}
