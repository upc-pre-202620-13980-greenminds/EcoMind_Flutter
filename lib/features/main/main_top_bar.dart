import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/coming_soon_page.dart';
import 'package:ecomind_parents/core/widgets/eco_top_bar.dart';
import 'package:ecomind_parents/features/users/presentation/notifications/notifications_page.dart';
import 'package:ecomind_parents/features/users/presentation/notifications/notifications_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/profile/profile_view_model.dart';
import 'package:flutter/material.dart';

// EcoTopBar with the balances and the unread notifications of the parent;
// used by the tabs and the secondary screens
class MainTopBar extends StatelessWidget {
  const new({super.key, this.isInsideInbox = false});
  // True in the inbox and its preferences: the bell must not open another inbox
  final bool isInsideInbox;

  void openNotifications(
    BuildContext context,
    NotificationsViewModel viewModel,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationsPage(viewModel: viewModel),
      ),
    );
  }

  void openComingSoon(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComingSoonPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModel = getIt<ProfileViewModel>();
    final notificationsViewModel = getIt<NotificationsViewModel>();

    return ListenableBuilder(
      listenable: Listenable.merge([profileViewModel, notificationsViewModel]),
      builder: (context, child) {
        final profile = profileViewModel.state.profile;
        return EcoTopBar(
          gemBalance: profile?.gemBalance,
          ecopoints: profile?.ecopoints,
          // Only the unread notifications that pass the preferences of the parent
          unreadNotifications: notificationsViewModel.state.unreadCount,
          onNotificationsTap: isInsideInbox
              ? null
              : () => openNotifications(context, notificationsViewModel),
          // Settings belongs to another member
          onSettingsTap: () => openComingSoon(context),
        );
      },
    );
  }
}
