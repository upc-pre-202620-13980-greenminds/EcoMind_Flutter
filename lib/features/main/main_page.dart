import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/widgets/coming_soon_view.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_page.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_view_model.dart';
import 'package:ecomind_parents/features/main/main_top_bar.dart';
import 'package:ecomind_parents/features/quests/infrastructure/quest_repository.dart';
import 'package:ecomind_parents/features/quests/presentation/quests_home_page.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/notifications/notifications_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/profile/profile_page.dart';
import 'package:ecomind_parents/features/users/presentation/profile/profile_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/report/weekly_report_view_model.dart';
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

  final ProfileViewModel profileViewModel = getIt<ProfileViewModel>();
  final FamilyViewModel familyViewModel = getIt<FamilyViewModel>();
  final WeeklyReportViewModel weeklyReportViewModel =
      getIt<WeeklyReportViewModel>();
  final NotificationsViewModel notificationsViewModel =
      getIt<NotificationsViewModel>();
  // Language used to load the inbox; it is loaded again if the language changes
  String? loadedLanguageTag;

  // Store, Ranking, Progress and Community belong to other members
  late final List<Widget> pages = [
    const ComingSoonView(),
    const ComingSoonView(),
    QuestsHomePage(
      profile: profileViewModel,
      familyViewModel: familyViewModel,
      repository: QuestRepository(
        sessionRepository: getIt<SessionRepository>(),
      ),
    ),
    const ComingSoonView(),
    const ComingSoonView(),
    ProfilePage(
      viewModel: profileViewModel,
      familyViewModel: familyViewModel,
      weeklyReportViewModel: weeklyReportViewModel,
    ),
  ];

  @override
  void initState() {
    super.initState();
    profileViewModel.addListener(onProfileChanged);
    familyViewModel.addListener(onFamilyChanged);
    // The top bar needs the balances even when another tab is open
    profileViewModel.loadProfile();
    // Loaded on every start, so a new parent never sees the previous family
    familyViewModel.loadFamily();
  }

  // The inbox needs the language of the application, which initState cannot read yet
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageTag = Localizations.localeOf(context).toLanguageTag();
    if (languageTag != loadedLanguageTag) {
      loadedLanguageTag = languageTag;
      notificationsViewModel.loadNotifications(languageTag);
    }
  }

  @override
  void dispose() {
    profileViewModel.removeListener(onProfileChanged);
    familyViewModel.removeListener(onFamilyChanged);
    super.dispose();
  }

  // The report depends on the members, so it is asked again when the family changes
  void onFamilyChanged() {
    if (!familyViewModel.state.isLoading) {
      weeklyReportViewModel.loadReport(familyViewModel.state.family);
    }
  }

  // An expired token sends the parent back to Sign in
  void onProfileChanged() {
    if (profileViewModel.state.isSessionExpired && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SignInPage(viewModel: getIt<SignInViewModel>()),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const MainTopBar(),
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
