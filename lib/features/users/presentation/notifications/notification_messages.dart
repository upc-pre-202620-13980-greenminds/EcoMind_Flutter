import 'package:ecomind_parents/features/users/domain/notification_category.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';

extension NotificationCategoryLabel on NotificationCategory {
  // Green label above the title; the hidden categories never reach the inbox
  String label(AppLocalizations l10n) {
    return switch (this) {
      NotificationCategory.achievementsAndBadges =>
        l10n.notificationsLabelAchievements,
      NotificationCategory.weeklyProgressSummary =>
        l10n.notificationsLabelProgress,
      NotificationCategory.communityEvents => l10n.notificationsLabelEvents,
      _ => l10n.notificationsLabelCommunity,
    };
  }
}

// "5 min", "1 h", "Yesterday" or "2 days", as in frame 65
String relativeTime(AppLocalizations l10n, DateTime createdAt, DateTime now) {
  final minutes = now.difference(createdAt).inMinutes;
  if (minutes < 60) {
    return l10n.notificationsTimeMinutes(minutes < 1 ? 1 : minutes);
  }
  if (minutes < 24 * 60) {
    return l10n.notificationsTimeHours(minutes ~/ 60);
  }
  if (minutes < 2 * 24 * 60) {
    return l10n.notificationsTimeYesterday;
  }
  return l10n.notificationsTimeDays(minutes ~/ (24 * 60));
}
