import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Logo, title and explanation shared by the password recovery screens
class RecoveryHeading extends StatelessWidget {
  const new({super.key, required this.title, required this.message});
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Image.asset(
          'assets/images/img_logo_ecomind.png',
          width: 203,
          height: 74,
          semanticLabel: AppLocalizations.of(context).logoDescription,
        ),
        const SizedBox(height: 40),
        Semantics(
          header: true,
          // The title is announced when the content of the screen changes
          liveRegion: true,
          child: Text(
            title,
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
