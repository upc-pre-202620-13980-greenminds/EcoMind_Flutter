// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EcoMind';

  @override
  String get logoDescription => 'EcoMind logo';

  @override
  String get navStore => 'Store';

  @override
  String get navRanking => 'Ranking';

  @override
  String get navMainMenu => 'Main menu';

  @override
  String get navProgress => 'Progress';

  @override
  String get navCommunity => 'Community';

  @override
  String get navProfile => 'Profile';

  @override
  String get topBarNotifications => 'Notifications';

  @override
  String get topBarSettings => 'Settings';

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get comingSoonMessage => 'This section will be available soon.';

  @override
  String get loading => 'Loading';

  @override
  String get signInEmailLabel => 'Email';

  @override
  String get signInPasswordLabel => 'Password';

  @override
  String get signInButton => 'Sign in';

  @override
  String get signInNoAccount => 'Don\'t have an account?';

  @override
  String get signInSignUpLink => 'Sign up';

  @override
  String get signInVerifyEmailHint =>
      'If you just signed up, verify your email first.';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get signUpNameLabel => 'Name';

  @override
  String get signUpConfirmPasswordLabel => 'Confirm password';

  @override
  String get signUpTermsPrefix => 'I agree to the';

  @override
  String get signUpTermsLink => 'terms & policy';

  @override
  String get signUpTermsCheckbox => 'I agree to the terms and policy';

  @override
  String get signUpButton => 'Sign up';

  @override
  String get signUpHaveAccount => 'Already have an account?';

  @override
  String get termsTitle => 'Terms & policy';

  @override
  String get termsBody =>
      'EcoMind is an educational sustainability project for students and families. Activities, educational materials and progress features support learning about environmental habits.\n\nYour account\nUse your own account information and keep your password private. Your email is used for account verification and password recovery. Sign out when you finish using a shared device.\n\nParticipation\nComplete activities honestly and treat other participants with respect. Points, streaks and achievements represent participation in EcoMind; they do not certify measured environmental savings.\n\nPrivacy\nAvoid sharing sensitive information in community posts or activity evidence. Do not share another person’s personal information without permission.\n\nTerms and privacy information are pending review by the project team.';

  @override
  String get verifyEmailSubtitle => 'You\'re almost there!';

  @override
  String verifyEmailMessage(String email) {
    return 'We\'ve sent an email to $email. Please check your inbox and enter the code.';
  }

  @override
  String get verifyEmailCodeLabel => 'Confirmation code';

  @override
  String get verifyEmailButton => 'Confirm email';

  @override
  String get verifyEmailResend => 'Resend code';

  @override
  String get verifyEmailCodeResent => 'We sent you a new code.';

  @override
  String get verifyEmailGoBack => 'Go back';

  @override
  String get errorEmailRequired => 'Enter your email address.';

  @override
  String get errorEmailInvalid => 'Enter a valid email address.';

  @override
  String get errorPasswordRequired => 'Enter your password.';

  @override
  String get errorInvalidCredentials => 'The email or password is incorrect.';

  @override
  String get errorNameInvalid => 'Enter your name (2 to 120 characters).';

  @override
  String get errorPasswordPolicy =>
      'The password must have 8 to 72 characters, with at least one letter and one digit.';

  @override
  String get errorPasswordMismatch => 'The passwords do not match.';

  @override
  String get errorTermsRequired => 'You must accept the terms and policy.';

  @override
  String get errorEmailConflict => 'This email address is already registered.';

  @override
  String get errorCodeFormat => 'Enter the 6-digit code.';

  @override
  String get errorCodeInvalid => 'The verification code is not valid.';

  @override
  String get errorCodeExpired =>
      'The verification code has expired. Request a new one.';

  @override
  String get errorCodeAttempts => 'Too many attempts. Request a new code.';

  @override
  String get errorStudentAccount =>
      'This application is for parents. Students sign in with the EcoMind student app.';

  @override
  String get errorConnection => 'Could not connect to the server. Try again.';

  @override
  String get errorUnknown => 'Something went wrong. Try again.';

  @override
  String topBarGems(int count) {
    return '$count gems';
  }

  @override
  String topBarEcopoints(int count) {
    return '$count ecopoints';
  }

  @override
  String get profileTitle => 'Your profile';

  @override
  String get profileEdit => 'Edit';

  @override
  String get roleParent => 'Parent';

  @override
  String get roleStudent => 'Student';

  @override
  String get profileStatStreak => 'Day streak';

  @override
  String get profileStatEcopoints => 'EcoPoints';

  @override
  String get profileStatGems => 'Gems';

  @override
  String profileStatDescription(int value, String label) {
    return '$value, $label';
  }

  @override
  String get profileShare => 'Share';

  @override
  String get profileFavorites => 'Favorites';

  @override
  String get profileTabProfile => 'Profile';

  @override
  String get profileTabFriends => 'Friends';

  @override
  String get profileTabFamily => 'Family';

  @override
  String get profileTryAgain => 'Try again';

  @override
  String get profileErrorTitle => 'Couldn’t load your profile';

  @override
  String get profileErrorMessage =>
      'Your information is currently unavailable.\nTry again to reload it.';

  @override
  String get signOut => 'Sign out';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get editProfileNameLabel => 'Name';

  @override
  String get editProfileNamePlaceholder => 'Write name';

  @override
  String get editProfileRoleLabel => 'Role';

  @override
  String get editProfileSave => 'Save changes';

  @override
  String get editProfileCancel => 'Cancel';

  @override
  String get editProfileNameRequired => 'Enter your name.';

  @override
  String get editProfileNameLength => 'The name must have 2 to 120 characters.';

  @override
  String get editProfileSaveFailed => 'Couldn’t save your changes.';

  @override
  String get editProfileSaveFailedHint => 'Your text is still here. Try again.';
}
