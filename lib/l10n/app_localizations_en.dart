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
  String get navMainMenu => 'Quests';

  @override
  String get navProgress => 'Progress';

  @override
  String get progressActive => 'In Progress';

  @override
  String get progressFamily => 'Family Quest';

  @override
  String get progressFinished => 'Finished';

  @override
  String get progressSeeMore => 'See more';

  @override
  String get progressViewHistory => 'View history';

  @override
  String get progressHistory => 'Quest history';

  @override
  String get progressEmptyActive => 'You have no active activities.';

  @override
  String get progressEmptyFamily => 'Create a family plan to start!';

  @override
  String get progressEmptyFinished =>
      'You haven’t completed any activities yet. Start one!';

  @override
  String get progressUnavailableQuest => 'Unavailable quest';

  @override
  String get progressMissingDate => 'Completion date unavailable';

  @override
  String progressCompletedOn(String date) {
    return 'Completed on $date';
  }

  @override
  String get progressLoadError =>
      'We couldn’t update your progress. Pull down or try again.';

  @override
  String get progressCreateFamilyPlan => 'Create family plan';

  @override
  String get progressShowCompletions => 'Show other completions';

  @override
  String get progressHideCompletions => 'Hide other completions';

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
      'Version 1.2 · Updated November 12, 2026\n\n1. About EcoMind\nEcoMind is an academic sustainability and learning application developed by the GreenMinds project team as part of a UPC university course. These terms cover account access and the activities, family, community, learning and reward features available in this build. Availability may vary while the project is developed.\n\n2. Accounts and acceptance\nRegister with information you are authorized to use. Read these terms and the privacy information below before selecting the acceptance checkbox. Keep your password, email verification codes and recovery links private. Your email is used to verify registration and recover access. Sign out after using a shared device. Stopping use of the app does not delete your account; see section 7. If you do not agree, do not complete registration or stop using the account.\n\n3. Children and responsible adults\nChildren may participate only with the involvement and any legally required authorization of a parent or guardian. School use should be coordinated by a responsible adult. Linking accounts as a family does not verify that a participant is a legal parent or guardian. Selecting Student or Parent is a profile choice; it does not verify age, guardianship or parental authorization. Do not provide information about another child without the necessary authority.\n\n4. Information used by the app\nRegistration uses a name, email, password and profile role. The server stores a password hash; the app keeps session credentials on the device while you are signed in. Depending on the features you use, the server also keeps profile details, family and friendship relationships, commitments, activity and progress records, points and achievements, community participation, learning preferences and purchase or gem transaction records. Only provide information needed for the activity you choose.\n\n5. Purpose and visibility\nThese records support account access, verification and recovery, the features you request, progress and rewards, and project validation. Your name, avatar, posts, reactions, shared achievements or participation may be visible to other participants through the relevant family, friend or community features. Do not treat community content as private. Do not publish passwords, recovery links, precise home locations, sensitive information or images of other people without permission. Accepting these terms does not authorize unrelated marketing or unrestricted use of personal images.\n\n6. Service providers and payments\nAzure hosts the configured backend and database and processes stored app records. Azure Communication Services Email processes the recipient address and verification or recovery message. Resend may be used if configured in another project environment. Cloudinary processes event images uploaded through the community features. Development versions may record verification codes and recovery tokens in server logs visible to the project team; use test accounts for shared demonstrations. The payment screens in this academic build use a sandbox and have not been validated for real purchases. Do not enter real card or bank account details; use only designated payment test data. Minors must involve their responsible adult. Never send payment details through community posts or support messages.\n\n7. Control of your information\nSigning out removes session credentials from this device; it does not erase the server account or shared records. It does not end sessions on other devices or invalidate access credentials already issued by the server before they expire. Contact the project team if you suspect your account or device is compromised. Uninstalling the app also does not erase backend data. This build does not provide a self-service account deletion or data export screen. You may request access, correction or deletion of your information, or object to a use of your information, through the GreenMinds project contact who provided this academic build, using that private course or project channel. Identify the account email, but never send a password, code or recovery link. Requests require manual handling and appropriate identity verification. App data is used for the stated features and academic validation; no fixed automatic deletion schedule for account records is implemented in this build.\n\n8. Participation, content and safety\nTreat other participants respectfully. Do not harass, impersonate others, manipulate activity results, misuse accounts or attempt unauthorized access. Complete activities honestly and choose actions that are safe and appropriate for your age and surroundings. Respect the authors, sources and licenses of educational materials and content you share. Activities are educational guidance and do not replace professional safety advice or emergency services.\n\n9. Points, rewards and environmental claims\nEcoPoints, gems, streaks, rankings and achievements describe participation within EcoMind. They are not cash, investments or proof of measured environmental savings. Completing an activity does not by itself certify a reduction in water, energy, emissions or waste. Any stated estimate must be interpreted with its source and limitations.\n\n10. Project availability and updates\nEcoMind is an academic project and may contain incomplete features, interruptions or errors. Do not use it as the only record of essential information. Updates to these terms will identify their version and date and can be read from registration or your account. Nothing in these terms removes rights that cannot be waived under applicable law. Contact the GreenMinds team through the private project channel used to receive this build for account, privacy or content concerns.';

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
  String get signUpRoleLabel => 'I am a';

  @override
  String get errorRoleRequired => 'Select a role.';

  @override
  String get commitmentTitle => 'My commitment';

  @override
  String get commitmentEmpty => 'Set a personal commitment to keep you going.';

  @override
  String get commitmentAdd => 'Add commitment';

  @override
  String get commitmentAddTitle => 'Add commitment';

  @override
  String get commitmentEditTitle => 'Edit commitment';

  @override
  String get commitmentSubtitle =>
      'What sustainable habit do you want to keep?';

  @override
  String get commitmentLabel => 'My commitment';

  @override
  String get commitmentPlaceholder => 'Write your commitment';

  @override
  String get commitmentSave => 'Save commitment';

  @override
  String get commitmentRetry => 'Retry';

  @override
  String get commitmentCancel => 'Cancel';

  @override
  String get commitmentRequired => 'Write a commitment before saving.';

  @override
  String commitmentLength(int max) {
    return 'Your commitment can have up to $max characters.';
  }

  @override
  String commitmentCounter(int count, int max) {
    return '$count/$max';
  }

  @override
  String commitmentCounterDescription(int count, int max) {
    return '$count of $max characters';
  }

  @override
  String get commitmentSaveFailed => 'Couldn’t save your commitment.';

  @override
  String get commitmentSaveFailedHint => 'Your text is still here. Try again.';

  @override
  String get medalsTitle => 'Medals and achievements';

  @override
  String get medalsEmpty => 'You have no medals yet.';

  @override
  String get familyEmptyStudentMessage =>
      'A parent can create a family and add you as a member.';

  @override
  String get preferencesQuests => 'New and daily quests';

  @override
  String get preferencesQuestsDescription =>
      'New quests available and daily quests';

  @override
  String get preferencesLearning => 'Learning reminders';

  @override
  String get preferencesLearningDescription =>
      'Pending materials you haven’t reviewed';

  @override
  String get errorResetOutcomeUnknown =>
      'We couldn\'t confirm the password change. Try signing in with your new password, or retry without changing it.';

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
  String get topBarNotificationsCurrent =>
      'Notifications. You are already in Notifications.';

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

  @override
  String get errorResetTokenInvalid =>
      'This reset link has expired or was already used. Request a new link to reset your password.';

  @override
  String get errorEmailDelivery =>
      'We couldn\'t send the email right now. Try again in a few minutes.';

  @override
  String get signInForgotPassword => 'Forgot your password?';

  @override
  String get recoveryTitle => 'Reset your password';

  @override
  String get recoveryMessage =>
      'Enter the email of your parent account and we\'ll send you a link to create a new password.';

  @override
  String get recoveryButton => 'Send link';

  @override
  String get recoveryBackToSignIn => 'Back to sign in';

  @override
  String get recoverySentTitle => 'Check your email';

  @override
  String recoverySentMessage(String email) {
    return 'If $email belongs to an EcoMind parent account, you\'ll receive a link to reset your password. Open it on this device. If you don\'t see it, check your spam folder.';
  }

  @override
  String get recoveryResend => 'Send the link again';

  @override
  String get recoveryLinkResent => 'If the account exists, we sent a new link.';

  @override
  String get recoveryChangeEmail => 'Use a different email';

  @override
  String get resetTitle => 'Create a new password';

  @override
  String get resetMessage => 'Choose a new password for your EcoMind account.';

  @override
  String get resetPasswordLabel => 'New password';

  @override
  String get resetConfirmPasswordLabel => 'Confirm new password';

  @override
  String get resetButton => 'Save new password';

  @override
  String get resetInvalidTitle => 'This link isn\'t valid';

  @override
  String get resetInvalidMessage =>
      'The link is incomplete or damaged. Request a new link to reset your password.';

  @override
  String get resetRequestNewLink => 'Request a new link';

  @override
  String get resetSuccessTitle => 'Password updated';

  @override
  String get resetSuccessMessage =>
      'Your password was changed. Sign in with your new password.';

  @override
  String get questsWelcome => 'Welcome back';

  @override
  String questsWelcomeName(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get questsPickUp => 'Pick up where you left off';

  @override
  String get questsContinue => 'Continue quest';

  @override
  String get questsRecommended => 'Recommended quests';

  @override
  String get questsSearch => 'Search';

  @override
  String get questsSearchHint => 'Search by title';

  @override
  String questsMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String questsAge(int age) {
    return 'Ages $age+';
  }

  @override
  String get questsRetry => 'Try again';

  @override
  String get questsEmpty => 'There are no recommendations right now.';

  @override
  String get questsNoResults => 'No quests found.';

  @override
  String get questsPendingError => 'Could not load your pending quest.';

  @override
  String get questsCatalogError => 'Could not load the recommendations.';

  @override
  String get questsResponse => 'Your answer';

  @override
  String questsMinCharacters(int count) {
    return 'Minimum $count characters';
  }

  @override
  String get questsStart => 'Start quest';

  @override
  String get questsFinish => 'Finish quest';

  @override
  String get questsCompleted => 'Quest completed';

  @override
  String get questsDetailLabel => 'QUEST';

  @override
  String get questsEnergy => 'energy';

  @override
  String get questsWater => 'water';

  @override
  String get questsRecycle => 'recycling';

  @override
  String get questsCollaborative => 'collaborative';

  @override
  String questsRewardPoints(int count) {
    return '$count EcoPoints';
  }

  @override
  String questsRewardGems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gems',
      one: '1 gem',
    );
    return '$_temp0';
  }

  @override
  String questsPercentCompleted(int percent) {
    return '$percent% completed';
  }

  @override
  String questsAnswerCount(int count, int minimum) {
    return '$count / $minimum characters minimum';
  }

  @override
  String get questsAnswerSaved => 'Saved';

  @override
  String get questsViewSaved => 'View saved answers';

  @override
  String get questsRestart => 'Restart quest';

  @override
  String get questsActivitiesUnavailable =>
      'These activities are unavailable here.';

  @override
  String get questsStarting => 'Ready... set...\nQuest started!';

  @override
  String get questsCelebration => 'Quest completed!\nGood job!';

  @override
  String get questsNice => 'Nice!';

  @override
  String get questsDaily => 'Daily quest';

  @override
  String get questsPending => 'Quest in progress';

  @override
  String get questsFilters => 'Filters';

  @override
  String get questsFilterCategory => 'Category';

  @override
  String get questsFilterType => 'Quest type';

  @override
  String get questsFilterAge => 'Recommended age';

  @override
  String get questsFilterTime => 'Estimated time';

  @override
  String get questsFilterApply => 'Apply';

  @override
  String get questsFilterMinigame => 'Minigame';

  @override
  String get questsFilterActivities => 'Activities';

  @override
  String questsFilterAgeRange(String range) {
    return 'Ages $range';
  }

  @override
  String get questsFilterUpTo15 => 'Up to 15 min';

  @override
  String get questsFilterOver60 => 'More than 60 min';
}
