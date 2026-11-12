import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

// Header of the main screens: logo, balances and shortcuts
class EcoTopBar extends StatelessWidget {
  const new({
    super.key,
    required this.onNotificationsTap,
    required this.onSettingsTap,
    this.gemBalance,
    this.ecopoints,
    this.unreadNotifications = 0,
  });
  final VoidCallback onNotificationsTap;
  final VoidCallback onSettingsTap;
  // Null while the profile is not loaded: the counters are hidden
  final int? gemBalance;
  final int? ecopoints;
  // 0 hides the badge of the bell
  final int unreadNotifications;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gems = gemBalance;
    final points = ecopoints;

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
                if (gems != null)
                  _BalanceCounter(
                    asset: 'assets/images/ic_gem.png',
                    iconWidth: 22,
                    iconHeight: 22,
                    value: gems,
                    color: Theme.of(context).colorScheme.tertiary,
                    description: l10n.topBarGems(gems),
                  ),
                const SizedBox(width: 6),
                if (points != null)
                  _BalanceCounter(
                    asset: 'assets/images/ic_ecopoints.png',
                    iconWidth: 30,
                    iconHeight: 26,
                    value: points,
                    color: Theme.of(context).colorScheme.primary,
                    description: l10n.topBarEcopoints(points),
                  ),
                IconButton(
                  onPressed: onNotificationsTap,
                  // The screen reader says "Notifications, 2 unread"
                  tooltip: unreadNotifications > 0
                      ? l10n.topBarNotificationsUnread(unreadNotifications)
                      : l10n.topBarNotifications,
                  icon: Badge(
                    isLabelVisible: unreadNotifications > 0,
                    backgroundColor: Theme.of(context).colorScheme.error,
                    // Bigger numbers are shown as "99+" so the badge keeps its size
                    label: Text(
                      unreadNotifications > 99 ? '99+' : '$unreadNotifications',
                    ),
                    child: Image.asset(
                      'assets/images/ic_notifications.png',
                      width: 24,
                      height: 24,
                      excludeFromSemantics: true,
                    ),
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

class _BalanceCounter extends StatelessWidget {
  const new({
    required this.asset,
    required this.iconWidth,
    required this.iconHeight,
    required this.value,
    required this.color,
    required this.description,
  });
  final String asset;
  final double iconWidth;
  final double iconHeight;
  final int value;
  final Color color;
  final String description;

  @override
  Widget build(BuildContext context) {
    // The screen reader says "360 gems" instead of reading icon and number apart
    return Semantics(
      label: description,
      excludeSemantics: true,
      child: Row(
        spacing: 2,
        children: [
          Image.asset(asset, width: iconWidth, height: iconHeight),
          Text(
            value.toString(),
            maxLines: 1,
            style: Theme.of(context).textTheme.titleSmall
                ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
