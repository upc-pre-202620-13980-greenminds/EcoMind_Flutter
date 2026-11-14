import 'package:ecomind_parents/core/widgets/labeled_text_field.dart';
import 'package:ecomind_parents/core/widgets/person_row.dart';
import 'package:ecomind_parents/core/widgets/text_link.dart';
import 'package:ecomind_parents/features/main/secondary_scaffold.dart';
import 'package:ecomind_parents/features/users/domain/family_candidate.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_messages.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/family/invite_friend/invite_friend_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/family/invite_friend/membership_conflict_page.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Frame 20. The friend is added right away: the backend has no invitations
class InviteFriendPage extends StatefulWidget {
  final InviteFriendViewModel viewModel;
  final FamilyViewModel familyViewModel;
  const new({
    super.key,
    required this.viewModel,
    required this.familyViewModel,
  });

  @override
  State<InviteFriendPage> createState() => _InviteFriendPageState();
}

class _InviteFriendPageState extends State<InviteFriendPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadCandidates();
  }

  Future<void> invite(FamilyCandidate candidate) async {
    final family = widget.familyViewModel.state.family;
    if (family == null) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final updated = await widget.viewModel.add(family, candidate);
    if (!mounted) {
      return;
    }

    if (updated != null) {
      widget.familyViewModel.onFamilyChanged(updated);
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.inviteAdded(candidate.name))),
      );
      return;
    }

    final error = widget.viewModel.state.errorMessage;
    if (error == UsersError.membershipConflict) {
      final bool? backToMembers = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MembershipConflictPage(candidate: candidate),
        ),
      );
      if (backToMembers == true && mounted) {
        Navigator.pop(context);
      }
    } else if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(error.text(l10n))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewModel = widget.viewModel;

    return SecondaryScaffold(
      title: l10n.inviteTitle,
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          final state = viewModel.state;
          final colorScheme = Theme.of(context).colorScheme;
          final candidates = state.visibleCandidates;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                LabeledTextField(
                  label: l10n.inviteChooseFriend,
                  hintText: l10n.inviteSearchHint,
                  bordered: true,
                  onChanged: viewModel.onQueryChange,
                  textInputAction: TextInputAction.search,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            semanticsLabel: l10n.loading,
                          ),
                        );
                      }
                      if (state.candidates.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Text(
                            state.errorMessage != null
                                ? l10n.tabError
                                : l10n.inviteEmpty,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: candidates.length,
                        itemBuilder: (context, index) {
                          final candidate = candidates[index];
                          final isAdding =
                              state.addingUserId == candidate.userId;
                          return PersonRow(
                            name: candidate.name,
                            subtitle: l10n.inviteFriendSubtitle,
                            trailing: isAdding
                                ? Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        semanticsLabel: l10n.loading,
                                      ),
                                    ),
                                  )
                                : TextLink(
                                    text: l10n.inviteButton,
                                    semanticLabel: l10n.inviteButtonDescription(
                                      candidate.name,
                                    ),
                                    onPressed: state.addingUserId == null
                                        ? () => invite(candidate)
                                        : null,
                                  ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
