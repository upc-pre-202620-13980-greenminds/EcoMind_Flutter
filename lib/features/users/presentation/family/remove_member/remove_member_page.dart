import 'package:ecomind_parents/core/widgets/form_error_text.dart';
import 'package:ecomind_parents/core/widgets/initials_avatar.dart';
import 'package:ecomind_parents/core/widgets/pill_button.dart';
import 'package:ecomind_parents/features/main/secondary_scaffold.dart';
import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_member.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_messages.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/family/remove_member/remove_member_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Frame 43: confirmation before DELETE /family_user/{id}
class RemoveMemberPage extends StatefulWidget {
  final RemoveMemberViewModel viewModel;
  final Family family;
  final FamilyMember member;
  final FamilyViewModel familyViewModel;
  const new({
    super.key,
    required this.viewModel,
    required this.family,
    required this.member,
    required this.familyViewModel,
  });

  @override
  State<RemoveMemberPage> createState() => _RemoveMemberPageState();
}

class _RemoveMemberPageState extends State<RemoveMemberPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(onStateChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(onStateChanged);
    super.dispose();
  }

  // True tells the member screen to close too
  void onStateChanged() {
    final state = widget.viewModel.state;
    if (state.isRemoved && mounted) {
      widget.familyViewModel.onFamilyChanged(state.updatedFamily);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = widget.viewModel;
    final member = widget.member;

    return SecondaryScaffold(
      title: l10n.removeMemberTitle,
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          final state = viewModel.state;
          final colorScheme = Theme.of(context).colorScheme;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 24),
                InitialsAvatar(name: member.name, size: 76),
                const SizedBox(height: 16),
                Text(
                  member.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.removeMemberMessage(member.name, widget.family.name),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (state.errorMessage != null)
                  FormErrorText(message: state.errorMessage!.text(l10n)),
                const SizedBox(height: 64),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: PillButton(
                    text: l10n.removeMemberAction,
                    onPressed: () => viewModel.remove(member),
                    isLoading: state.isRemoving,
                  ),
                ),
                TextButton(
                  onPressed: state.isRemoving
                      ? null
                      : () => Navigator.pop(context),
                  child: Text(
                    l10n.cancel,
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
    );
  }
}
