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

  @override
  String get cancel => 'Cancel';

  @override
  String get tabError => 'This information could not be loaded.';

  @override
  String get familyEmptyTitle => 'No family yet';

  @override
  String get familyEmptyMessage =>
      'Create your family to bring everyone together.';

  @override
  String get familyCreate => 'Create family';

  @override
  String get familyManage => 'Manage';

  @override
  String familyMembersCount(int count) {
    return 'Members · $count';
  }

  @override
  String get familyManagerRole => 'Parent · family manager';

  @override
  String get familyRoleParent => 'Parent';

  @override
  String get familyRoleChild => 'Child';

  @override
  String get familyYou => 'You';

  @override
  String get createFamilyTitle => 'Create family';

  @override
  String get familyNameLabel => 'Family name';

  @override
  String get familyNamePlaceholder => 'Write family name';

  @override
  String get familyCommitmentLabel => 'Family commitment';

  @override
  String get familyCommitmentPlaceholder => 'Write family commitment';

  @override
  String get familyNameRequired => 'Enter a family name.';

  @override
  String get familyCommitmentRequired => 'Enter a family commitment.';

  @override
  String get familyRequiredInfo => 'Complete the required information.';

  @override
  String get createFamilySave => 'Save changes';

  @override
  String get errorCreatorNotParent =>
      'Only a parent account can create a family.';

  @override
  String get errorAlreadyInFamily => 'You already belong to a family.';

  @override
  String get errorFamilyFull => 'A family can have up to 5 members.';

  @override
  String get manageFamilyTitle => 'Manage family';

  @override
  String get manageMembersTitle => 'Members';

  @override
  String get manageAddMember => 'Add member';

  @override
  String get manageEditMember => 'Edit';

  @override
  String manageEditMemberDescription(String name) {
    return 'Open $name';
  }

  @override
  String get manageNoMembers => 'No other members yet.';

  @override
  String get inviteTitle => 'Invite a friend';

  @override
  String get inviteChooseFriend => 'Choose a friend';

  @override
  String get inviteSearchHint => 'Search your friends';

  @override
  String get inviteFriendSubtitle => 'Friend';

  @override
  String get inviteButton => 'Invite';

  @override
  String inviteButtonDescription(String name) {
    return 'Add $name to the family';
  }

  @override
  String get inviteEmpty =>
      'None of your friends can join right now. Friends who already belong to a family are not shown.';

  @override
  String inviteAdded(String name) {
    return '$name was added to the family.';
  }

  @override
  String get memberTitle => 'Family member';

  @override
  String get memberRoleLabel => 'Role in the family';

  @override
  String get memberRoleHelp =>
      'This describes their place in the family.\nIt does not change their account role.';

  @override
  String get removeMemberAction => 'Remove member';

  @override
  String get removeMemberTitle => 'Remove member';

  @override
  String removeMemberMessage(String name, String family) {
    return 'Remove $name from $family?\nThey will no longer belong to this family.';
  }

  @override
  String get conflictTitle => 'Add family member';

  @override
  String get conflictHeading => 'Already in a family';

  @override
  String get conflictMessage =>
      'A user can belong to only one active family at a time.';

  @override
  String get conflictBack => 'Back to members';

  @override
  String get weeklyReportTitle => 'Family weekly report';

  @override
  String get weeklyReportView => 'View report';

  @override
  String get weeklyReportLink => 'Weekly report';

  @override
  String get weeklyReportThisWeek => 'This week';

  @override
  String get weeklyReportProgress => 'Weekly progress';

  @override
  String weeklyReportQuests(int completed, int total) {
    return '$completed of $total quests completed';
  }

  @override
  String weeklyReportAchievements(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count achievements earned this week',
      one: '1 achievement earned this week',
    );
    return '$_temp0';
  }

  @override
  String get weeklyReportNoData =>
      'There is not enough data to generate a report this week.';

  @override
  String get weeklyReportNoFamily =>
      'Create your family to see its weekly report.';

  @override
  String topBarNotificationsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Notifications, $count unread',
      one: 'Notifications, 1 unread',
    );
    return '$_temp0';
  }

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String notificationsUnread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread',
      one: '1 unread',
    );
    return '$_temp0';
  }

  @override
  String get notificationsAllRead => 'All caught up';

  @override
  String get notificationsMarkAll => 'Mark all as read';

  @override
  String get notificationsEmptyTitle => 'No notifications yet';

  @override
  String get notificationsEmptyMessage =>
      'You’ll be notified about family achievements, weekly reports and community events.';

  @override
  String get notificationsErrorTitle => 'Couldn’t load your notifications';

  @override
  String get notificationsErrorMessage =>
      'Your notifications are currently unavailable. Try again to reload them.';

  @override
  String get notificationsActionFailed =>
      'Couldn’t update your notifications. Try again.';

  @override
  String get notificationsLabelAchievements => 'ACHIEVEMENTS';

  @override
  String get notificationsLabelProgress => 'PROGRESS';

  @override
  String get notificationsLabelEvents => 'EVENTS';

  @override
  String get notificationsLabelCommunity => 'COMMUNITY';

  @override
  String notificationsTimeMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String notificationsTimeHours(int hours) {
    return '$hours h';
  }

  @override
  String get notificationsTimeYesterday => 'Yesterday';

  @override
  String notificationsTimeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String notificationsRowUnread(
    String category,
    String title,
    String message,
    String time,
  ) {
    return 'Unread. $category. $title. $message. $time';
  }

  @override
  String notificationsRowRead(
    String category,
    String title,
    String message,
    String time,
  ) {
    return '$category. $title. $message. $time';
  }

  @override
  String get preferencesTitle => 'Notification preferences';

  @override
  String get preferencesDescription =>
      'Choose which notifications you want to receive.';

  @override
  String get preferencesAchievements => 'Achievements and badges';

  @override
  String get preferencesAchievementsDescription =>
      'Family badges and achievements';

  @override
  String get preferencesWeekly => 'Weekly progress summary';

  @override
  String get preferencesWeeklyDescription => 'Your family weekly report';

  @override
  String get preferencesEvents => 'Family community events';

  @override
  String get preferencesEventsDescription =>
      'Events for families published in your community';

  @override
  String get preferencesActivity => 'Community activity';

  @override
  String get preferencesActivityDescription =>
      'Reactions, shared achievements and community goals';

  @override
  String get preferencesSaveFailed =>
      'Couldn’t save your preference. Try again.';
}
