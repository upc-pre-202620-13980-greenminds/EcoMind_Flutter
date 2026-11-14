import 'package:ecomind_parents/features/users/domain/my_achievement.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// The profile only shows a few earned medals
const int _medalsInProfile = 3;

// "Medals and achievements" of the Profile tab, read from Gamification.
// This application has no screen of achievements, so there is no "View all"
// and the rows do not open anything.
class MedalsSection extends StatelessWidget {
  const new({
    super.key,
    required this.achievements,
    required this.isLoading,
    required this.failed,
  });
  final List<MyAchievement> achievements;
  final bool isLoading;
  // If the medals fail to load, only the title stays on screen
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              l10n.medalsTitle,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        if (isLoading)
          Center(child: CircularProgressIndicator(semanticsLabel: l10n.loading))
        else if (failed)
          const SizedBox.shrink()
        else if (achievements.isEmpty)
          Text(
            l10n.medalsEmpty,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final medal in achievements.take(_medalsInProfile))
            _MedalRow(name: medal.name),
      ],
    );
  }
}

// Same row of the student app: icon, name and a divider
class _MedalRow extends StatelessWidget {
  const new({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Row(
            spacing: 12,
            children: [
              // Decorative: the name of the medal is written next to it
              Icon(
                Icons.emoji_events_outlined,
                size: 32,
                color: colorScheme.primary,
              ),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: colorScheme.outlineVariant),
      ],
    );
  }
}
