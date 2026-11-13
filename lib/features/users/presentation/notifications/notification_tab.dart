import 'package:ecomind_parents/features/users/domain/notification_type.dart';

// Tabs of the main screen that already show what a notification talks about.
// The backend does not send the id of the community or the event, so a tap opens the tab.
enum NotificationTab {
  // Position of the tab in the bottom bar of MainPage
  progress(3),
  community(4),
  profile(5);

  const NotificationTab(this.mainTabIndex);
  final int mainTabIndex;
}

// Null means there is no screen for it in this application, so a tap only marks it as read
NotificationTab? tabFor(NotificationType type) {
  return switch (type) {
    NotificationType.achievementUnlocked => NotificationTab.profile,
    NotificationType.achievementShared ||
    NotificationType.communityGoalReached ||
    NotificationType.communityEventCreated ||
    NotificationType.communityEventUpdated => NotificationTab.community,
    NotificationType.weeklySummary => NotificationTab.progress,
    // Quests has no invitations, Learning is not in this application and Friends is not ready
    NotificationType.questInvitation ||
    NotificationType.learningReminder ||
    NotificationType.friendRequestAccepted ||
    NotificationType.general ||
    NotificationType.unknown => null,
  };
}
