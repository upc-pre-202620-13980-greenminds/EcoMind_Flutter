import 'package:ecomind_parents/features/users/domain/app_notification.dart';
import 'package:ecomind_parents/features/users/presentation/notifications/notification_messages.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// An unread notification is a light green card with a dot; a read one is a row with a divider
class NotificationTile extends StatelessWidget {
  const new({
    super.key,
    required this.notification,
    required this.now,
    required this.onTap,
  });
  final AppNotification notification;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final category = notification.category.label(l10n);
    final time = relativeTime(l10n, notification.createdAt.toLocal(), now);
    final isRead = notification.isRead;

    // The whole row is read as one sentence: state, category, title, text and time
    final description = isRead
        ? l10n.notificationsRowRead(
            category,
            notification.title,
            notification.message,
            time,
          )
        : l10n.notificationsRowUnread(
            category,
            notification.title,
            notification.message,
            time,
          );

    return Semantics(
      label: description,
      button: true,
      // The children are excluded, so the tap is given again to the screen reader
      onTap: onTap,
      excludeSemantics: true,
      child: Column(
        children: [
          Material(
            color: isRead
                ? Colors.transparent
                : colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 3,
                          children: [
                            Text(
                              category,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                color: colorScheme.primary,
                              ),
                            ),
                            Text(
                              notification.title,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              notification.message,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (!isRead)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isRead)
            Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),
        ],
      ),
    );
  }
}
