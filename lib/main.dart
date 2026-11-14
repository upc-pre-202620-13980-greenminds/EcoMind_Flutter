import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/theme.dart';
import 'package:ecomind_parents/features/iam/navigation/password_reset_link.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_page.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/splash/splash_page.dart';
import 'package:ecomind_parents/features/iam/presentation/splash/splash_view_model.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Created first so the link that opened the application is not lost;
  // the stream emits that link and every link received later
  final appLinks = AppLinks();
  setupDependencies();
  runApp(MainApp(links: appLinks.uriLinkStream));
}

class MainApp extends StatefulWidget {
  // Links opened from outside the application; tests can provide their own
  final Stream<Uri>? links;
  const new({super.key, this.links});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // The same link can arrive twice at start up; reopening it later still works
  static const Duration duplicateWindow = Duration(seconds: 2);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<Uri>? linkSubscription;

  // Kept in memory only until the navigator exists
  Uri? pendingLink;
  // Duplicate detection keeps a hash rather than the full URI
  int? lastLinkHash;
  DateTime? lastLinkTime;

  @override
  void initState() {
    super.initState();
    listenToLinks();
  }

  @override
  void didUpdateWidget(MainApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.links != widget.links) {
      linkSubscription?.cancel();
      listenToLinks();
    }
  }

  @override
  void dispose() {
    linkSubscription?.cancel();
    linkSubscription = null;
    pendingLink = null;
    super.dispose();
  }

  void listenToLinks() {
    // Errors of the platform are ignored on purpose: links are never logged
    linkSubscription = widget.links?.listen(onLink, onError: (Object error) {});
  }

  void onLink(Uri uri) {
    // Links to other routes are ignored; only the reset route is opened
    if (!PasswordResetLink.matches(uri) || isDuplicate(uri)) {
      return;
    }
    pendingLink = uri;
    openPendingLink();
  }

  bool isDuplicate(Uri uri) {
    final hash = uri.toString().hashCode;
    final now = DateTime.now();
    final previousTime = lastLinkTime;
    final duplicate =
        hash == lastLinkHash &&
        previousTime != null &&
        now.difference(previousTime) < duplicateWindow;
    lastLinkHash = hash;
    lastLinkTime = now;
    return duplicate;
  }

  // On a cold start the link can arrive before the first frame
  void openPendingLink() {
    if (!mounted) {
      return;
    }
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => openPendingLink());
      WidgetsBinding.instance.ensureVisualUpdate();
      return;
    }

    final uri = pendingLink;
    pendingLink = null;
    if (uri == null) {
      return;
    }
    // A matching link without a usable token opens the screen that explains it
    final token = PasswordResetLink.tokenFrom(uri);

    // Splash, Sign in or Main are removed: the reset screen is the only one left
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        settings: const RouteSettings(name: PasswordResetLink.routeName),
        builder: (context) => ResetPasswordPage(
          viewModel: getIt<ResetPasswordViewModel>(),
          token: token,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: const MaterialTheme(ecoMindTextTheme).light(),
      darkTheme: const MaterialTheme(ecoMindTextTheme).dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: SplashPage(viewModel: getIt<SplashViewModel>()),
    );
  }
}
