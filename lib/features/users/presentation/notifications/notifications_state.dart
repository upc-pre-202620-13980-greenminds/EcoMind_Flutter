import 'package:ecomind_parents/features/users/domain/app_notification.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';

class NotificationsState {
  const new({
    this.notifications = const [],
    this.isLoading = false,
    this.isMarkingAll = false,
    this.errorMessage,
    this.actionError,
  });

  // Already filtered by the preferences of the role
  final List<AppNotification> notifications;
  final bool isLoading;
  final bool isMarkingAll;
  // The inbox could not be loaded (frame 67)
  final UsersError? errorMessage;
  // Marking as read failed; the list stays on screen
  final UsersError? actionError;

  // Used by the badge of the bell and by the header of the inbox
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  // The errors are not kept by copyWith: a new change clears them.
  // To clear the list, the ViewModel starts again from a new NotificationsState
  NotificationsState copyWith({
    List<AppNotification>? notifications,
    bool? isLoading,
    bool? isMarkingAll,
    UsersError? errorMessage,
    UsersError? actionError,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      isMarkingAll: isMarkingAll ?? this.isMarkingAll,
      errorMessage: errorMessage,
      actionError: actionError,
    );
  }
}
