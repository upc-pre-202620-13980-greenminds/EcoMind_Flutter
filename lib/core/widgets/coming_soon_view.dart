import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Content shown in the sections that are not part of this application yet
class ComingSoonView extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Text(
              l10n.comingSoonTitle,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.center,
            ),
            Text(
              l10n.comingSoonMessage,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
