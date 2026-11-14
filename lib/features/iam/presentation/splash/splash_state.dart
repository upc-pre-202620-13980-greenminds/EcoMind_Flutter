enum SplashDestination { signIn, main }

class SplashState {
  const new({this.destination, this.isLoading = false});

  // Null while the stored session is being checked
  final SplashDestination? destination;
  final bool isLoading;

  SplashState copyWith({SplashDestination? destination, bool? isLoading}) {
    return SplashState(
      destination: destination ?? this.destination,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
