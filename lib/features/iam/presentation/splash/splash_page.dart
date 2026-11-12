import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_page.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/splash/splash_state.dart';
import 'package:ecomind_parents/features/iam/presentation/splash/splash_view_model.dart';
import 'package:ecomind_parents/features/main/main_page.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  final SplashViewModel viewModel;
  const new({super.key, required this.viewModel});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(onStateChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(onStateChanged);
    super.dispose();
  }

  // Navigation is a one time action, so it is done here and not inside build
  void onStateChanged() {
    final destination = widget.viewModel.state.destination;
    if (destination == null || !mounted) {
      return;
    }
    // A reset link may have replaced the splash while the session was checked;
    // the route can still be mounted during the transition, so it must not
    // replace the screen that is now on top
    if (!(ModalRoute.of(context)?.isCurrent ?? false)) {
      return;
    }
    final Widget nextPage = switch (destination) {
      SplashDestination.main => const MainPage(),
      SplashDestination.signIn => SignInPage(
        viewModel: getIt<SignInViewModel>(),
      ),
    };
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/img_logo_ecomind.png',
          width: 203,
          height: 74,
          semanticLabel: AppLocalizations.of(context).logoDescription,
        ),
      ),
    );
  }
}
