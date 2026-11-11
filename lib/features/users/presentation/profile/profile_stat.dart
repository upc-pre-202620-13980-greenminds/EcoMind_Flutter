import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Number and label of the profile, such as "2 Day streak"
class ProfileStat extends StatelessWidget {
  const new({super.key, required this.value, required this.label});
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // The screen reader says "2, Day streak" as one item
    return Semantics(
      label: AppLocalizations.of(context).profileStatDescription(value, label),
      excludeSemantics: true,
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: colorScheme.primary,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
