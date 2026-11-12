import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/labeled_text_field.dart';
import 'package:ecomind_parents/core/widgets/person_row.dart';
import 'package:ecomind_parents/core/widgets/text_link.dart';
import 'package:ecomind_parents/features/main/secondary_scaffold.dart';
import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_member.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_messages.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/family/invite_friend/invite_friend_page.dart';
import 'package:ecomind_parents/features/users/presentation/family/invite_friend/invite_friend_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/family/member_detail/member_detail_page.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Frame 19. The name and the commitment are read only: the backend cannot change them
class ManageFamilyPage extends StatelessWidget {
  final FamilyViewModel familyViewModel;
  const new({super.key, required this.familyViewModel});

  void openInvite(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InviteFriendPage(
          viewModel: getIt<InviteFriendViewModel>(),
          familyViewModel: familyViewModel,
        ),
      ),
    );
  }

  void openMember(BuildContext context, Family family, FamilyMember member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberDetailPage(
          family: family,
          member: member,
          familyViewModel: familyViewModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SecondaryScaffold(
      title: l10n.manageFamilyTitle,
      body: ListenableBuilder(
        listenable: familyViewModel,
        builder: (context, child) {
          final family = familyViewModel.state.family;
          if (family == null) {
            return Center(
              child: CircularProgressIndicator(semanticsLabel: l10n.loading),
            );
          }
          final colorScheme = Theme.of(context).colorScheme;
          final members = family.otherMembers;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledTextField(
                  // The key makes the field show the new value if the family changes
                  key: ValueKey('name-${family.name}'),
                  label: l10n.familyNameLabel,
                  initialValue: family.name,
                  bordered: true,
                  readOnly: true,
                  onChanged: (_) {},
                ),
                const SizedBox(height: 24),
                LabeledTextField(
                  key: ValueKey('commitment-${family.commitment}'),
                  label: l10n.familyCommitmentLabel,
                  initialValue: family.commitment,
                  bordered: true,
                  readOnly: true,
                  maxLines: 3,
                  onChanged: (_) {},
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(
                          l10n.manageMembersTitle,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    TextLink(
                      text: l10n.manageAddMember,
                      onPressed: () => openInvite(context),
                    ),
                  ],
                ),
                if (members.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      l10n.manageNoMembers,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                // The parent is not listed: a parent cannot remove themselves
                for (final member in members)
                  PersonRow(
                    name: member.name,
                    subtitle: member.role.text(l10n),
                    trailing: TextLink(
                      text: l10n.manageEditMember,
                      semanticLabel: l10n.manageEditMemberDescription(
                        member.name,
                      ),
                      onPressed: () => openMember(context, family, member),
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
