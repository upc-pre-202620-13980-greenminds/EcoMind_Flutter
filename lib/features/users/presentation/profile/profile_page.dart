import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/coming_soon_page.dart';
import 'package:ecomind_parents/core/widgets/coming_soon_view.dart';
import 'package:ecomind_parents/core/widgets/initials_avatar.dart';
import 'package:ecomind_parents/core/widgets/pill_button.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_page.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_view_model.dart';
import 'package:ecomind_parents/features/users/domain/user_profile.dart';
import 'package:ecomind_parents/features/users/presentation/edit_profile/edit_profile_page.dart';
import 'package:ecomind_parents/features/users/presentation/edit_profile/edit_profile_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/profile/profile_state.dart';
import 'package:ecomind_parents/features/users/presentation/profile/profile_stat.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_tab_content.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/profile/profile_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final ProfileViewModel viewModel;
  final FamilyViewModel familyViewModel;
  const new({
    super.key,
    required this.viewModel,
    required this.familyViewModel,
  });

  void openComingSoon(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComingSoonPage()),
    );
  }

  Future<void> openEditProfile(
    BuildContext context,
    UserProfile profile,
  ) async {
    final UserProfile? updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          viewModel: getIt<EditProfileViewModel>(),
          profile: profile,
        ),
      ),
    );
    if (updated != null) {
      viewModel.onProfileUpdated(updated);
    }
  }

  Future<void> signOut(BuildContext context) async {
    await viewModel.signOut();
    if (!context.mounted) {
      return;
    }
    // Nothing of the session stays behind Sign in
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPage(viewModel: getIt<SignInViewModel>()),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final state = viewModel.state;
        final profile = state.profile;

        if (profile == null) {
          if (state.errorMessage != null) {
            return _ProfileError(onRetry: viewModel.loadProfile);
          }
          return Center(
            child: CircularProgressIndicator(
              semanticsLabel: AppLocalizations.of(context).loading,
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _ProfileHeader(
                profile: profile,
                onEdit: () => openEditProfile(context, profile),
                onShare: () => openComingSoon(context),
                onFavorites: () => openComingSoon(context),
              ),
              const SizedBox(height: 12),
              _ProfileTabs(
                selected: state.selectedTab,
                onSelected: viewModel.selectTab,
              ),
              const SizedBox(height: 16),
              switch (state.selectedTab) {
                // The weekly report card is added with HU-021
                ProfileTab.profile => _SignOutButton(
                  onPressed: () => signOut(context),
                ),
                // Friends belongs to another member
                ProfileTab.friends => const ComingSoonView(),
                ProfileTab.family => FamilyTabContent(
                  viewModel: familyViewModel,
                ),
              },
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

// Part shared by the three tabs: title, avatar, name, role, statistics and actions
class _ProfileHeader extends StatelessWidget {
  const new({
    required this.profile,
    required this.onEdit,
    required this.onShare,
    required this.onFavorites,
  });
  final UserProfile profile;
  final VoidCallback onEdit;
  final VoidCallback onShare;
  final VoidCallback onFavorites;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.profileTitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: colorScheme.primary,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: onEdit,
                child: Text(
                  l10n.profileEdit,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        InitialsAvatar(name: profile.name, size: 76),
        const SizedBox(height: 8),
        Text(
          profile.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          profile.socialRole == SocialRole.parent
              ? l10n.roleParent
              : l10n.roleStudent,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ProfileStat(
                value: profile.streak,
                label: l10n.profileStatStreak,
              ),
            ),
            Expanded(
              child: ProfileStat(
                value: profile.ecopoints,
                label: l10n.profileStatEcopoints,
              ),
            ),
            Expanded(
              child: ProfileStat(
                value: profile.gemBalance,
                label: l10n.profileStatGems,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            spacing: 8,
            children: [
              Expanded(
                child: PillButton(text: l10n.profileShare, onPressed: onShare),
              ),
              Expanded(
                child: PillButton(
                  text: l10n.profileFavorites,
                  onPressed: onFavorites,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Profile / Friends / Family, drawn with the Material segmented button
class _ProfileTabs extends StatelessWidget {
  const new({required this.selected, required this.onSelected});
  final ProfileTab selected;
  final ValueChanged<ProfileTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<ProfileTab>(
        segments: [
          ButtonSegment(
            value: ProfileTab.profile,
            label: Text(l10n.profileTabProfile, maxLines: 1),
          ),
          ButtonSegment(
            value: ProfileTab.friends,
            label: Text(l10n.profileTabFriends, maxLines: 1),
          ),
          ButtonSegment(
            value: ProfileTab.family,
            label: Text(l10n.profileTabFamily, maxLines: 1),
          ),
        ],
        selected: {selected},
        onSelectionChanged: (selection) => onSelected(selection.first),
        showSelectedIcon: false,
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
          side: WidgetStatePropertyAll(
            BorderSide(color: colorScheme.outlineVariant),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontFamily: 'Inter', fontSize: 12),
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? colorScheme.primary
                : colorScheme.surfaceContainerLow,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// Red text action, the same component as "Remove member" in the family frames
class _SignOutButton extends StatelessWidget {
  const new({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          AppLocalizations.of(context).signOut,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}

// Shown when the profile could not be loaded; the button requests it again
class _ProfileError extends StatelessWidget {
  const new({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Semantics(
        liveRegion: true,
        child: Column(
          children: [
            const SizedBox(height: 64),
            Text(
              l10n.profileErrorTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 19,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.profileErrorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            PillButton(text: l10n.profileTryAgain, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
