import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Header of the main screens: logo and shortcuts
class EcoTopBar extends StatelessWidget {
  const new({
    super.key,
    required this.onNotificationsTap,
    required this.onSettingsTap,
  });
  final VoidCallback onNotificationsTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: SizedBox(
            height: 63,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/img_logo_ecomind.png',
                  width: 100,
                  height: 36,
                  semanticLabel: l10n.logoDescription,
                ),
                const Spacer(),
                IconButton(
                  onPressed: onNotificationsTap,
                  tooltip: l10n.topBarNotifications,
                  icon: Image.asset(
                    'assets/images/ic_notifications.png',
                    width: 24,
                    height: 24,
                    excludeFromSemantics: true,
                  ),
                ),
                IconButton(
                  onPressed: onSettingsTap,
                  tooltip: l10n.topBarSettings,
                  icon: Image.asset(
                    'assets/images/ic_settings.png',
                    width: 24,
                    height: 24,
                    excludeFromSemantics: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 2,
          thickness: 2,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ],
    );
  }
}
