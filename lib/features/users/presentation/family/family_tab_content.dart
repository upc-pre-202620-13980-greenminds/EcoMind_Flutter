import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/empty_state_message.dart';
import 'package:ecomind_parents/core/widgets/person_row.dart';
import 'package:ecomind_parents/core/widgets/text_link.dart';
import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/presentation/family/create_family/create_family_page.dart';
import 'package:ecomind_parents/features/users/presentation/family/create_family/create_family_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_messages.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/family/manage_family/manage_family_page.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Family tab of the profile: "No family yet" (frame 23) or the family (frame 17)
class FamilyTabContent extends StatelessWidget {
  final FamilyViewModel viewModel;
  const new({super.key, required this.viewModel});

  Future<void> openCreateFamily(BuildContext context) async {
    final Family? created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateFamilyPage(viewModel: getIt<CreateFamilyViewModel>()),
      ),
    );
    if (created != null) {
      viewModel.onFamilyChanged(created);
    }
  }

  void openManageFamily(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageFamilyPage(familyViewModel: viewModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        final state = viewModel.state;
        final family = state.family;

        if (state.isLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: CircularProgressIndicator(semanticsLabel: l10n.loading),
          );
        }
        if (state.errorMessage != null) {
          return _TabError(onRetry: viewModel.loadFamily);
        }
        if (family == null) {
          return Column(
            children: [
              EmptyStateMessage(
                title: l10n.familyEmptyTitle,
                message: l10n.familyEmptyMessage,
                titleSize: 20,
              ),
              const SizedBox(height: 8),
              TextLink(
                text: l10n.familyCreate,
                fontSize: 14,
                onPressed: () => openCreateFamily(context),
              ),
            ],
          );
        }
        return _FamilyContent(
          family: family,
          onManage: () => openManageFamily(context),
        );
      },
    );
  }
}

class _FamilyContent extends StatelessWidget {
  const new({required this.family, required this.onManage});
  final Family family;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  family.name,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            TextLink(text: l10n.familyManage, onPressed: onManage),
          ],
        ),
        Text(
          family.commitment,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        // "Weekly report" is added next to this title with HU-021
        Semantics(
          header: true,
          child: Text(
            l10n.familyMembersCount(family.members.length),
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        for (final member in family.members)
          PersonRow(
            name: member.name,
            subtitle: member.subtitle(l10n),
            trailing: member.isCurrentUser
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      l10n.familyYou,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: colorScheme.primary,
                      ),
                    ),
                  )
                : null,
          ),
      ],
    );
  }
}

// The design has no error state for a single tab, so this one is kept minimal
class _TabError extends StatelessWidget {
  const new({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: [
          Semantics(
            liveRegion: true,
            child: Text(
              l10n.tabError,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextLink(text: l10n.profileTryAgain, onPressed: onRetry),
        ],
      ),
    );
  }
}
