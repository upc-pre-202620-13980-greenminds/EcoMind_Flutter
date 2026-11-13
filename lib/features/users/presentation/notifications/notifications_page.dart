import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/empty_state_message.dart';
import 'package:ecomind_parents/core/widgets/pill_button.dart';
import 'package:ecomind_parents/core/widgets/text_link.dart';
import 'package:ecomind_parents/features/main/secondary_scaffold.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';
import 'package:ecomind_parents/features/users/presentation/notification_preferences/notification_preferences_page.dart';
import 'package:ecomind_parents/features/users/presentation/notification_preferences/notification_preferences_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/notifications/notification_tab.dart';
import 'package:ecomind_parents/features/users/presentation/notifications/notification_tile.dart';
import 'package:ecomind_parents/features/users/presentation/notifications/notifications_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Frame 65; the empty and error states take the look of frames 66 and 67
class NotificationsPage extends StatelessWidget {
  final NotificationsViewModel viewModel;
  const new({super.key, required this.viewModel});

  Future<void> openPreferences(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationPreferencesPage(
          viewModel: getIt<NotificationPreferencesViewModel>(),
        ),
      ),
    );
    // The categories may have changed, so the inbox is filtered again
    viewModel.reload();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SecondaryScaffold(
      title: l10n.notificationsTitle,
      isInsideInbox: true,
      headerAction: IconButton(
        onPressed: () => openPreferences(context),
        tooltip: l10n.preferencesTitle,
        icon: Icon(Icons.tune, color: Theme.of(context).colorScheme.primary),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          final state = viewModel.state;
          final notifications = state.notifications;

          if (state.isLoading && notifications.isEmpty) {
            return Center(
              child: CircularProgressIndicator(semanticsLabel: l10n.loading),
            );
          }
          if (state.errorMessage != null) {
            return _LoadFailure(onRetry: viewModel.reload);
          }
          if (notifications.isEmpty) {
            return Semantics(
              liveRegion: true,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 64),
                  child: EmptyStateMessage(
                    title: l10n.notificationsEmptyTitle,
                    message: l10n.notificationsEmptyMessage,
                  ),
                ),
              ),
            );
          }

          final now = DateTime.now();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _InboxHeader(
                  unreadCount: state.unreadCount,
                  canMarkAll: state.unreadCount > 0 && !state.isMarkingAll,
                  onMarkAll: viewModel.markAllAsRead,
                ),
                if (state.actionError != null)
                  Semantics(
                    liveRegion: true,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        state.actionError == UsersError.connection
                            ? l10n.errorConnection
                            : l10n.notificationsActionFailed,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: viewModel.reload,
                    child: ListView.separated(
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return NotificationTile(
                          notification: notification,
                          now: now,
                          onTap: () {
                            viewModel.open(notification);
                            // The main screen changes to the tab; the inbox closes over it
                            if (tabFor(notification.type) != null) {
                              Navigator.popUntil(
                                context,
                                (route) => route.isFirst,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// "2 unread" and "Mark all as read", or "All caught up" with the action off
class _InboxHeader extends StatelessWidget {
  const new({
    required this.unreadCount,
    required this.canMarkAll,
    required this.onMarkAll,
  });
  final int unreadCount;
  final bool canMarkAll;
  final VoidCallback onMarkAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            liveRegion: true,
            child: Text(
              unreadCount > 0
                  ? l10n.notificationsUnread(unreadCount)
                  : l10n.notificationsAllRead,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        TextLink(
          text: l10n.notificationsMarkAll,
          onPressed: canMarkAll ? onMarkAll : null,
        ),
      ],
    );
  }
}

// Frame 67: the inbox could not be loaded
class _LoadFailure extends StatelessWidget {
  const new({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Expanded(
            child: Semantics(
              liveRegion: true,
              child: Center(
                child: SingleChildScrollView(
                  child: EmptyStateMessage(
                    title: l10n.notificationsErrorTitle,
                    message: l10n.notificationsErrorMessage,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 40),
            child: PillButton(text: l10n.profileTryAgain, onPressed: onRetry),
          ),
        ],
      ),
    );
  }
}
