import 'package:ecomind_parents/features/users/application/get_visible_notifications_use_case.dart';
import 'package:ecomind_parents/features/users/application/mark_all_notifications_read_use_case.dart';
import 'package:ecomind_parents/features/users/application/mark_notification_read_use_case.dart';
import 'package:ecomind_parents/features/users/domain/app_notification.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';
import 'package:ecomind_parents/features/users/presentation/notifications/notification_tab.dart';
import 'package:ecomind_parents/features/users/presentation/notifications/notifications_state.dart';
import 'package:flutter/material.dart';

// Shared by the inbox and the bell of the top bar, which shows the unread count
class NotificationsViewModel extends ChangeNotifier {
  final GetVisibleNotificationsUseCase getVisibleNotifications;
  final MarkNotificationReadUseCase markNotificationRead;
  final MarkAllNotificationsReadUseCase markAllNotificationsRead;

  new({
    required this.getVisibleNotifications,
    required this.markNotificationRead,
    required this.markAllNotificationsRead,
  });

  NotificationsState _state = NotificationsState();
  NotificationsState get state => _state;

  // Language of the application, sent so the backend writes the texts in it
  String _languageTag = 'en';

  // Tab the main screen opens after a tap; it is read only once
  NotificationTab? _requestedTab;

  NotificationTab? takeRequestedTab() {
    final tab = _requestedTab;
    _requestedTab = null;
    return tab;
  }

  // A tap marks the notification as read and, if it has one, asks for its tab
  Future<void> open(AppNotification notification) async {
    _requestedTab = tabFor(notification.type);
    if (_requestedTab != null) {
      notifyListeners();
    }
    await markAsRead(notification);
  }

  Future<void> loadNotifications(String languageTag) async {
    _languageTag = languageTag;
    // A new initial state, so the inbox of a previous parent is never shown
    _state = NotificationsState().copyWith(isLoading: true);
    notifyListeners();
    await _fetch();
  }

  // Used by "Try again" and after the preferences change
  Future<void> reload() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();
    await _fetch();
  }

  Future<void> _fetch() async {
    try {
      final notifications = await getVisibleNotifications.execute(_languageTag);
      _state = _state.copyWith(notifications: notifications, isLoading: false);
    } on UsersException catch (e) {
      _state = _state.copyWith(isLoading: false, errorMessage: e.error);
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: UsersError.unknown,
      );
    }
    notifyListeners();
  }

  Future<void> markAsRead(AppNotification notification) async {
    if (notification.isRead) {
      return;
    }
    final previous = _state.notifications;

    // The row changes at once; if the backend fails it goes back
    _state = _state.copyWith(
      notifications: [
        for (final n in previous)
          n.id == notification.id ? n.markedAsRead() : n,
      ],
    );
    notifyListeners();

    try {
      await markNotificationRead.execute(notification.id, _languageTag);
    } on UsersException catch (e) {
      _state = _state.copyWith(notifications: previous, actionError: e.error);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        notifications: previous,
        actionError: UsersError.unknown,
      );
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    if (_state.isMarkingAll || _state.unreadCount == 0) {
      return;
    }

    _state = _state.copyWith(isMarkingAll: true);
    notifyListeners();

    try {
      await markAllNotificationsRead.execute();
      _state = _state.copyWith(
        notifications: [for (final n in _state.notifications) n.markedAsRead()],
        isMarkingAll: false,
      );
    } on UsersException catch (e) {
      _state = _state.copyWith(isMarkingAll: false, actionError: e.error);
    } catch (e) {
      _state = _state.copyWith(
        isMarkingAll: false,
        actionError: UsersError.unknown,
      );
    }
    notifyListeners();
  }
}
