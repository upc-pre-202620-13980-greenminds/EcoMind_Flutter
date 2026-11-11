import 'package:ecomind_parents/features/iam/application/check_session_use_case.dart';
import 'package:ecomind_parents/features/iam/presentation/splash/splash_state.dart';
import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  final CheckSessionUseCase checkSession;

  new({required this.checkSession}) {
    decideDestination();
  }

  // Reading the session takes a few milliseconds; without this the logo would not be seen
  static const Duration minVisibleTime = Duration(seconds: 1);

  SplashState _state = SplashState();
  SplashState get state => _state;

  Future<void> decideDestination() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    bool hasSession;
    try {
      // Both start at the same time, so the splash lasts the longer of the two
      final results = await Future.wait([
        checkSession.execute(),
        Future.delayed(minVisibleTime, () => false),
      ]);
      hasSession = results.first;
    } catch (e) {
      // A database that cannot be read is treated as no session
      hasSession = false;
    }

    _state = _state.copyWith(
      destination: hasSession
          ? SplashDestination.main
          : SplashDestination.signIn,
      isLoading: false,
    );
    notifyListeners();
  }
}
