import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/user_avatar.dart';
import 'package:ecomind_parents/core/widgets/labeled_text_field.dart';
import 'package:ecomind_parents/core/widgets/text_link.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/main/secondary_scaffold.dart';
import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_member.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_messages.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/family/remove_member/remove_member_page.dart';
import 'package:ecomind_parents/features/users/presentation/family/remove_member/remove_member_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Frame 21, read only: the backend cannot change the role of a member
class MemberDetailPage extends StatelessWidget {
  final Family family;
  final FamilyMember member;
  final FamilyViewModel familyViewModel;
  const new({
    super.key,
    required this.family,
    required this.member,
    required this.familyViewModel,
  });

  Future<void> openRemove(BuildContext context) async {
    final bool? removed = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RemoveMemberPage(
          viewModel: getIt<RemoveMemberViewModel>(),
          family: family,
          member: member,
          familyViewModel: familyViewModel,
        ),
      ),
    );
    // The member no longer exists, so this screen closes too
    if (removed == true && context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SecondaryScaffold(
      title: l10n.memberTitle,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 12,
              children: [
                UserAvatar(
                  name: member.name,
                  imageReference: member.avatarImageReference,
                  size: 56,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        member.socialRole == SocialRole.parent
                            ? l10n.roleParent
                            : l10n.roleStudent,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            LabeledTextField(
              label: l10n.memberRoleLabel,
              initialValue: member.role.text(l10n),
              bordered: true,
              readOnly: true,
              onChanged: (_) {},
            ),
            const SizedBox(height: 12),
            Text(
              l10n.memberRoleHelp,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 48),
            // The parent who is signed in never reaches this screen for themselves
            if (!member.isCurrentUser)
              Center(
                child: TextLink(
                  text: l10n.removeMemberAction,
                  color: colorScheme.error,
                  fontSize: 14,
                  onPressed: () => openRemove(context),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
