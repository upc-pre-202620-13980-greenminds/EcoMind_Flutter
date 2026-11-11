import 'package:ecomind_parents/core/widgets/initials_avatar.dart';
import 'package:ecomind_parents/core/widgets/labeled_text_field.dart';
import 'package:ecomind_parents/core/widgets/pill_button.dart';
import 'package:ecomind_parents/core/widgets/screen_header.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/main/main_top_bar.dart';
import 'package:ecomind_parents/features/users/domain/user_profile.dart';
import 'package:ecomind_parents/features/users/presentation/edit_profile/edit_profile_state.dart';
import 'package:ecomind_parents/features/users/presentation/edit_profile/edit_profile_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final EditProfileViewModel viewModel;
  final UserProfile profile;
  const new({super.key, required this.viewModel, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.start(widget.profile.name);
    widget.viewModel.addListener(onStateChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(onStateChanged);
    super.dispose();
  }

  // Closes with the saved profile, so Profile shows the new name
  void onStateChanged() {
    final saved = widget.viewModel.state.savedProfile;
    if (saved != null && mounted) {
      Navigator.pop(context, saved);
    }
  }

  String? nameErrorText(AppLocalizations l10n, NameError? error) {
    return switch (error) {
      NameError.required => l10n.editProfileNameRequired,
      NameError.length => l10n.editProfileNameLength,
      null => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = widget.viewModel;
    final profile = widget.profile;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const MainTopBar(),
            ScreenHeader(title: l10n.editProfileTitle),
            Expanded(
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, child) {
                  final state = viewModel.state;
                  final colorScheme = Theme.of(context).colorScheme;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        InitialsAvatar(name: state.name, size: 76),
                        const SizedBox(height: 24),
                        LabeledTextField(
                          label: l10n.editProfileNameLabel,
                          initialValue: profile.name,
                          hintText: l10n.editProfileNamePlaceholder,
                          bordered: true,
                          onChanged: viewModel.onNameChange,
                          errorText: nameErrorText(l10n, state.nameError),
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.done,
                          enabled: !state.isSaving,
                          onSubmitted: (_) => viewModel.save(profile),
                        ),
                        const SizedBox(height: 24),
                        // The role is shown but cannot be changed from the application
                        _RoleRow(
                          label: l10n.editProfileRoleLabel,
                          value: profile.socialRole == SocialRole.parent
                              ? l10n.roleParent
                              : l10n.roleStudent,
                        ),
                        if (state.saveFailed)
                          Semantics(
                            liveRegion: true,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 8,
                                  children: [
                                    Text(
                                      l10n.editProfileSaveFailed,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: colorScheme.error,
                                      ),
                                    ),
                                    Text(
                                      l10n.editProfileSaveFailedHint,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        color: colorScheme.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 48),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          // After a failure the same button retries with the same text
                          child: PillButton(
                            text: state.saveFailed
                                ? l10n.profileTryAgain
                                : l10n.editProfileSave,
                            onPressed: () => viewModel.save(profile),
                            isLoading: state.isSaving,
                          ),
                        ),
                        TextButton(
                          onPressed: state.isSaving
                              ? null
                              : () => Navigator.pop(context),
                          child: Text(
                            l10n.editProfileCancel,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleRow extends StatelessWidget {
  const new({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
