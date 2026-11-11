import 'package:ecomind_parents/core/widgets/coming_soon_page.dart';
import 'package:ecomind_parents/core/widgets/coming_soon_view.dart';
import 'package:ecomind_parents/core/widgets/eco_top_bar.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const new({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // The parent application opens on the Profile section
  int selectedIndex = 5;

  // Store, Ranking, Main menu, Progress and Community belong to other members;
  // Profile is replaced when its screen is implemented
  final List<Widget> pages = const [
    ComingSoonView(),
    ComingSoonView(),
    ComingSoonView(),
    ComingSoonView(),
    ComingSoonView(),
    ComingSoonView(),
  ];

  void openComingSoon() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComingSoonPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            EcoTopBar(
              onNotificationsTap: openComingSoon,
              onSettingsTap: openComingSoon,
            ),
            Expanded(child: pages[selectedIndex]),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            height: 62,
            // The design only shows the icons; the label is still read by the screen reader
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            indicatorColor: Colors.transparent,
            backgroundColor: Theme.of(context).colorScheme.surface,
            destinations: [
              navDestination('store', l10n.navStore, 41, 42),
              navDestination('ranking', l10n.navRanking, 37, 36),
              navDestination('main_menu', l10n.navMainMenu, 50, 50),
              navDestination('progress', l10n.navProgress, 37, 36),
              navDestination('community', l10n.navCommunity, 41, 40),
              navDestination('profile', l10n.navProfile, 37, 38),
            ],
          ),
        ],
      ),
    );
  }

  // The inactive images already come faded from the design
  NavigationDestination navDestination(
    String name,
    String label,
    double width,
    double height,
  ) {
    return NavigationDestination(
      icon: Image.asset(
        'assets/images/ic_nav_${name}_inactive.png',
        width: width,
        height: height,
        excludeFromSemantics: true,
      ),
      selectedIcon: Image.asset(
        'assets/images/ic_nav_${name}_active.png',
        width: width,
        height: height,
        excludeFromSemantics: true,
      ),
      label: label,
      tooltip: label,
    );
  }
}
