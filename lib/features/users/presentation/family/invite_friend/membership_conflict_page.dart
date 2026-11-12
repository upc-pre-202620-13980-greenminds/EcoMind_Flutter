import 'package:ecomind_parents/core/widgets/empty_state_message.dart';
import 'package:ecomind_parents/core/widgets/person_row.dart';
import 'package:ecomind_parents/core/widgets/pill_button.dart';
import 'package:ecomind_parents/features/iam/domain/social_role.dart';
import 'package:ecomind_parents/features/main/secondary_scaffold.dart';
import 'package:ecomind_parents/features/users/domain/family_candidate.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Frame 44: the friend joined another family while the list was open
class MembershipConflictPage extends StatelessWidget {
  final FamilyCandidate candidate;
  const new({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SecondaryScaffold(
      title: l10n.conflictTitle,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            PersonRow(
              name: candidate.name,
              subtitle: candidate.socialRole == SocialRole.parent
                  ? l10n.roleParent
                  : l10n.roleStudent,
            ),
            const SizedBox(height: 32),
            Semantics(
              liveRegion: true,
              child: EmptyStateMessage(
                title: l10n.conflictHeading,
                message: l10n.conflictMessage,
              ),
            ),
            const SizedBox(height: 64),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // True tells Invite a friend to close too and go back to the members
              child: PillButton(
                text: l10n.conflictBack,
                onPressed: () => Navigator.pop(context, true),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
