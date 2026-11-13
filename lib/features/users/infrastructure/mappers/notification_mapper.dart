import 'package:ecomind_parents/features/users/domain/app_notification.dart';
import 'package:ecomind_parents/features/users/domain/notification_category.dart';
import 'package:ecomind_parents/features/users/domain/notification_type.dart';
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
      type: _typeFor(type),
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

  NotificationType _typeFor(String? value) {
    return switch (value) {
      'GENERAL' => NotificationType.general,
      'FRIEND_REQUEST_ACCEPTED' => NotificationType.friendRequestAccepted,
      'QUEST_INVITATION' => NotificationType.questInvitation,
      'ACHIEVEMENT_UNLOCKED' => NotificationType.achievementUnlocked,
      'ACHIEVEMENT_SHARED' => NotificationType.achievementShared,
      'COMMUNITY_GOAL_REACHED' => NotificationType.communityGoalReached,
      'COMMUNITY_EVENT_CREATED' => NotificationType.communityEventCreated,
      'COMMUNITY_EVENT_UPDATED' => NotificationType.communityEventUpdated,
      'LEARNING_REMINDER' => NotificationType.learningReminder,
      'WEEKLY_SUMMARY' => NotificationType.weeklySummary,
      _ => NotificationType.unknown,
    };
  }
}

// Each row is read on its own: one that cannot be read, such as one with a wrong date,
// is left out and the rest of the inbox is still shown
List<AppNotification> notificationsFromJson(List jsons) {
  final notifications = <AppNotification>[];
  for (final json in jsons) {
    try {
      notifications.add(NotificationDto.fromJson(json).toDomain());
    } catch (e) {
      continue;
    }
  }
  return notifications;
}
