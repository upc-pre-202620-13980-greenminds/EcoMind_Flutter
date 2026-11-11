import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/coming_soon_page.dart';
import 'package:ecomind_parents/core/widgets/eco_top_bar.dart';
import 'package:ecomind_parents/features/users/presentation/profile/profile_view_model.dart';
import 'package:flutter/material.dart';

// EcoTopBar with the balances of the parent; used by the tabs and the secondary screens
class MainTopBar extends StatelessWidget {
  const new({super.key});

  void openComingSoon(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComingSoonPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = getIt<ProfileViewModel>();

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final profile = viewModel.state.profile;
        return EcoTopBar(
          gemBalance: profile?.gemBalance,
          ecopoints: profile?.ecopoints,
          // Notifications arrive with HU-018; Settings belongs to another member
          onNotificationsTap: () => openComingSoon(context),
          onSettingsTap: () => openComingSoon(context),
        );
      },
    );
  }
}
