import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('es', '419'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'EcoMind'**
  String get appTitle;

  /// No description provided for @logoDescription.
  ///
  /// In en, this message translates to:
  /// **'EcoMind logo'**
  String get logoDescription;

  /// No description provided for @navStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get navStore;

  /// No description provided for @navRanking.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get navRanking;

  /// No description provided for @navMainMenu.
  ///
  /// In en, this message translates to:
  /// **'Main menu'**
  String get navMainMenu;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navCommunity;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @topBarNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get topBarNotifications;

  /// No description provided for @topBarSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get topBarSettings;

  /// No description provided for @comingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoonTitle;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'This section will be available soon.'**
  String get comingSoonMessage;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @signInEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signInEmailLabel;

  /// No description provided for @signInPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signInPasswordLabel;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInButton;

  /// No description provided for @signInNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get signInNoAccount;

  /// No description provided for @signInSignUpLink.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signInSignUpLink;

  /// No description provided for @signInVerifyEmailHint.
  ///
  /// In en, this message translates to:
  /// **'If you just signed up, verify your email first.'**
  String get signInVerifyEmailHint;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @signUpNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get signUpNameLabel;

  /// No description provided for @signUpConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get signUpConfirmPasswordLabel;

  /// No description provided for @signUpTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the'**
  String get signUpTermsPrefix;

  /// No description provided for @signUpTermsLink.
  ///
  /// In en, this message translates to:
  /// **'terms & policy'**
  String get signUpTermsLink;

  /// No description provided for @signUpTermsCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms and policy'**
  String get signUpTermsCheckbox;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpButton;

  /// No description provided for @signUpHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signUpHaveAccount;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & policy'**
  String get termsTitle;

  /// No description provided for @termsBody.
  ///
  /// In en, this message translates to:
  /// **'Version 1.2 · Updated November 12, 2026\n\n1. About EcoMind\nEcoMind is an academic sustainability and learning application developed by the GreenMinds project team as part of a UPC university course. These terms cover account access and the activities, family, community, learning and reward features available in this build. Availability may vary while the project is developed.\n\n2. Accounts and acceptance\nRegister with information you are authorized to use. Read these terms and the privacy information below before selecting the acceptance checkbox. Keep your password, email verification codes and recovery links private. Your email is used to verify registration and recover access. Sign out after using a shared device. Stopping use of the app does not delete your account; see section 7. If you do not agree, do not complete registration or stop using the account.\n\n3. Children and responsible adults\nChildren may participate only with the involvement and any legally required authorization of a parent or guardian. School use should be coordinated by a responsible adult. Linking accounts as a family does not verify that a participant is a legal parent or guardian. Selecting Student or Parent is a profile choice; it does not verify age, guardianship or parental authorization. Do not provide information about another child without the necessary authority.\n\n4. Information used by the app\nRegistration uses a name, email, password and profile role. The server stores a password hash; the app keeps session credentials on the device while you are signed in. Depending on the features you use, the server also keeps profile details, family and friendship relationships, commitments, activity and progress records, points and achievements, community participation, learning preferences and purchase or gem transaction records. Only provide information needed for the activity you choose.\n\n5. Purpose and visibility\nThese records support account access, verification and recovery, the features you request, progress and rewards, and project validation. Your name, avatar, posts, reactions, shared achievements or participation may be visible to other participants through the relevant family, friend or community features. Do not treat community content as private. Do not publish passwords, recovery links, precise home locations, sensitive information or images of other people without permission. Accepting these terms does not authorize unrelated marketing or unrestricted use of personal images.\n\n6. Service providers and payments\nAzure hosts the configured backend and database and processes stored app records. Azure Communication Services Email processes the recipient address and verification or recovery message. Resend may be used if configured in another project environment. Cloudinary processes event images uploaded through the community features. Development versions may record verification codes and recovery tokens in server logs visible to the project team; use test accounts for shared demonstrations. The payment screens in this academic build use a sandbox and have not been validated for real purchases. Do not enter real card or bank account details; use only designated payment test data. Minors must involve their responsible adult. Never send payment details through community posts or support messages.\n\n7. Control of your information\nSigning out removes session credentials from this device; it does not erase the server account or shared records. It does not end sessions on other devices or invalidate access credentials already issued by the server before they expire. Contact the project team if you suspect your account or device is compromised. Uninstalling the app also does not erase backend data. This build does not provide a self-service account deletion or data export screen. You may request access, correction or deletion of your information, or object to a use of your information, through the GreenMinds project contact who provided this academic build, using that private course or project channel. Identify the account email, but never send a password, code or recovery link. Requests require manual handling and appropriate identity verification. App data is used for the stated features and academic validation; no fixed automatic deletion schedule for account records is implemented in this build.\n\n8. Participation, content and safety\nTreat other participants respectfully. Do not harass, impersonate others, manipulate activity results, misuse accounts or attempt unauthorized access. Complete activities honestly and choose actions that are safe and appropriate for your age and surroundings. Respect the authors, sources and licenses of educational materials and content you share. Activities are educational guidance and do not replace professional safety advice or emergency services.\n\n9. Points, rewards and environmental claims\nEcoPoints, gems, streaks, rankings and achievements describe participation within EcoMind. They are not cash, investments or proof of measured environmental savings. Completing an activity does not by itself certify a reduction in water, energy, emissions or waste. Any stated estimate must be interpreted with its source and limitations.\n\n10. Project availability and updates\nEcoMind is an academic project and may contain incomplete features, interruptions or errors. Do not use it as the only record of essential information. Updates to these terms will identify their version and date and can be read from registration or your account. Nothing in these terms removes rights that cannot be waived under applicable law. Contact the GreenMinds team through the private project channel used to receive this build for account, privacy or content concerns.'**
  String get termsBody;

  /// No description provided for @verifyEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re almost there!'**
  String get verifyEmailSubtitle;

  /// No description provided for @verifyEmailMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent an email to {email}. Please check your inbox and enter the code.'**
  String verifyEmailMessage(String email);

  /// No description provided for @verifyEmailCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirmation code'**
  String get verifyEmailCodeLabel;

  /// No description provided for @verifyEmailButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm email'**
  String get verifyEmailButton;

  /// No description provided for @verifyEmailResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get verifyEmailResend;

  /// No description provided for @verifyEmailCodeResent.
  ///
  /// In en, this message translates to:
  /// **'We sent you a new code.'**
  String get verifyEmailCodeResent;

  /// No description provided for @verifyEmailGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get verifyEmailGoBack;

  /// No description provided for @errorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address.'**
  String get errorEmailRequired;

  /// No description provided for @errorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get errorEmailInvalid;

  /// No description provided for @errorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get errorPasswordRequired;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'The email or password is incorrect.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter your name (2 to 120 characters).'**
  String get errorNameInvalid;

  /// No description provided for @errorPasswordPolicy.
  ///
  /// In en, this message translates to:
  /// **'The password must have 8 to 72 characters, with at least one letter and one digit.'**
  String get errorPasswordPolicy;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords do not match.'**
  String get errorPasswordMismatch;

  /// No description provided for @errorTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms and policy.'**
  String get errorTermsRequired;

  /// No description provided for @errorEmailConflict.
  ///
  /// In en, this message translates to:
  /// **'This email address is already registered.'**
  String get errorEmailConflict;

  /// No description provided for @errorCodeFormat.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code.'**
  String get errorCodeFormat;

  /// No description provided for @errorCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'The verification code is not valid.'**
  String get errorCodeInvalid;

  /// No description provided for @errorCodeExpired.
  ///
  /// In en, this message translates to:
  /// **'The verification code has expired. Request a new one.'**
  String get errorCodeExpired;

  /// No description provided for @errorCodeAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Request a new code.'**
  String get errorCodeAttempts;

  /// No description provided for @errorStudentAccount.
  ///
  /// In en, this message translates to:
  /// **'This application is for parents. Students sign in with the EcoMind student app.'**
  String get errorStudentAccount;

  /// No description provided for @errorConnection.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the server. Try again.'**
  String get errorConnection;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get errorUnknown;

  /// No description provided for @topBarGems.
  ///
  /// In en, this message translates to:
  /// **'{count} gems'**
  String topBarGems(int count);

  /// No description provided for @topBarEcopoints.
  ///
  /// In en, this message translates to:
  /// **'{count} ecopoints'**
  String topBarEcopoints(int count);

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get profileTitle;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profileEdit;

  /// No description provided for @roleParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get roleParent;

  /// No description provided for @roleStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get roleStudent;

  /// No description provided for @profileStatStreak.
  ///
  /// In en, this message translates to:
  /// **'Day streak'**
  String get profileStatStreak;

  /// No description provided for @profileStatEcopoints.
  ///
  /// In en, this message translates to:
  /// **'EcoPoints'**
  String get profileStatEcopoints;

  /// No description provided for @profileStatGems.
  ///
  /// In en, this message translates to:
  /// **'Gems'**
  String get profileStatGems;

  /// No description provided for @profileStatDescription.
  ///
  /// In en, this message translates to:
  /// **'{value}, {label}'**
  String profileStatDescription(int value, String label);

  /// No description provided for @profileShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get profileShare;

  /// No description provided for @profileFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get profileFavorites;

  /// No description provided for @profileTabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTabProfile;

  /// No description provided for @profileTabFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get profileTabFriends;

  /// No description provided for @profileTabFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get profileTabFamily;

  /// No description provided for @profileTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get profileTryAgain;

  /// No description provided for @profileErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load your profile'**
  String get profileErrorTitle;

  /// No description provided for @profileErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Your information is currently unavailable.\nTry again to reload it.'**
  String get profileErrorMessage;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @editProfileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get editProfileNameLabel;

  /// No description provided for @editProfileNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write name'**
  String get editProfileNamePlaceholder;

  /// No description provided for @editProfileRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get editProfileRoleLabel;

  /// No description provided for @editProfileSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get editProfileSave;

  /// No description provided for @editProfileCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get editProfileCancel;

  /// No description provided for @editProfileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your name.'**
  String get editProfileNameRequired;

  /// No description provided for @editProfileNameLength.
  ///
  /// In en, this message translates to:
  /// **'The name must have 2 to 120 characters.'**
  String get editProfileNameLength;

  /// No description provided for @editProfileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save your changes.'**
  String get editProfileSaveFailed;

  /// No description provided for @editProfileSaveFailedHint.
  ///
  /// In en, this message translates to:
  /// **'Your text is still here. Try again.'**
  String get editProfileSaveFailedHint;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @tabError.
  ///
  /// In en, this message translates to:
  /// **'This information could not be loaded.'**
  String get tabError;

  /// No description provided for @familyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No family yet'**
  String get familyEmptyTitle;

  /// No description provided for @familyEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create your family to bring everyone together.'**
  String get familyEmptyMessage;

  /// No description provided for @familyCreate.
  ///
  /// In en, this message translates to:
  /// **'Create family'**
  String get familyCreate;

  /// No description provided for @familyManage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get familyManage;

  /// No description provided for @familyMembersCount.
  ///
  /// In en, this message translates to:
  /// **'Members · {count}'**
  String familyMembersCount(int count);

  /// No description provided for @familyManagerRole.
  ///
  /// In en, this message translates to:
  /// **'Parent · family manager'**
  String get familyManagerRole;

  /// No description provided for @familyRoleParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get familyRoleParent;

  /// No description provided for @familyRoleChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get familyRoleChild;

  /// No description provided for @familyYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get familyYou;

  /// No description provided for @createFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Create family'**
  String get createFamilyTitle;

  /// No description provided for @familyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Family name'**
  String get familyNameLabel;

  /// No description provided for @familyNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write family name'**
  String get familyNamePlaceholder;

  /// No description provided for @familyCommitmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Family commitment'**
  String get familyCommitmentLabel;

  /// No description provided for @familyCommitmentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write family commitment'**
  String get familyCommitmentPlaceholder;

  /// No description provided for @familyNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a family name.'**
  String get familyNameRequired;

  /// No description provided for @familyCommitmentRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a family commitment.'**
  String get familyCommitmentRequired;

  /// No description provided for @familyRequiredInfo.
  ///
  /// In en, this message translates to:
  /// **'Complete the required information.'**
  String get familyRequiredInfo;

  /// No description provided for @createFamilySave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get createFamilySave;

  /// No description provided for @errorCreatorNotParent.
  ///
  /// In en, this message translates to:
  /// **'Only a parent account can create a family.'**
  String get errorCreatorNotParent;

  /// No description provided for @errorAlreadyInFamily.
  ///
  /// In en, this message translates to:
  /// **'You already belong to a family.'**
  String get errorAlreadyInFamily;

  /// No description provided for @errorFamilyFull.
  ///
  /// In en, this message translates to:
  /// **'A family can have up to 5 members.'**
  String get errorFamilyFull;

  /// No description provided for @manageFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage family'**
  String get manageFamilyTitle;

  /// No description provided for @manageMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get manageMembersTitle;

  /// No description provided for @manageAddMember.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get manageAddMember;

  /// No description provided for @manageEditMember.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get manageEditMember;

  /// No description provided for @manageEditMemberDescription.
  ///
  /// In en, this message translates to:
  /// **'Open {name}'**
  String manageEditMemberDescription(String name);

  /// No description provided for @manageNoMembers.
  ///
  /// In en, this message translates to:
  /// **'No other members yet.'**
  String get manageNoMembers;

  /// No description provided for @inviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend'**
  String get inviteTitle;

  /// No description provided for @inviteChooseFriend.
  ///
  /// In en, this message translates to:
  /// **'Choose a friend'**
  String get inviteChooseFriend;

  /// No description provided for @inviteSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search your friends'**
  String get inviteSearchHint;

  /// No description provided for @inviteFriendSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get inviteFriendSubtitle;

  /// No description provided for @inviteButton.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get inviteButton;

  /// No description provided for @inviteButtonDescription.
  ///
  /// In en, this message translates to:
  /// **'Add {name} to the family'**
  String inviteButtonDescription(String name);

  /// No description provided for @inviteEmpty.
  ///
  /// In en, this message translates to:
  /// **'None of your friends can join right now. Friends who already belong to a family are not shown.'**
  String get inviteEmpty;

  /// No description provided for @inviteAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} was added to the family.'**
  String inviteAdded(String name);

  /// No description provided for @memberTitle.
  ///
  /// In en, this message translates to:
  /// **'Family member'**
  String get memberTitle;

  /// No description provided for @memberRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role in the family'**
  String get memberRoleLabel;

  /// No description provided for @memberRoleHelp.
  ///
  /// In en, this message translates to:
  /// **'This describes their place in the family.\nIt does not change their account role.'**
  String get memberRoleHelp;

  /// No description provided for @removeMemberAction.
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get removeMemberAction;

  /// No description provided for @removeMemberTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get removeMemberTitle;

  /// No description provided for @removeMemberMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from {family}?\nThey will no longer belong to this family.'**
  String removeMemberMessage(String name, String family);

  /// No description provided for @conflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Add family member'**
  String get conflictTitle;

  /// No description provided for @conflictHeading.
  ///
  /// In en, this message translates to:
  /// **'Already in a family'**
  String get conflictHeading;

  /// No description provided for @conflictMessage.
  ///
  /// In en, this message translates to:
  /// **'A user can belong to only one active family at a time.'**
  String get conflictMessage;

  /// No description provided for @conflictBack.
  ///
  /// In en, this message translates to:
  /// **'Back to members'**
  String get conflictBack;

  /// No description provided for @weeklyReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Family weekly report'**
  String get weeklyReportTitle;

  /// No description provided for @weeklyReportView.
  ///
  /// In en, this message translates to:
  /// **'View report'**
  String get weeklyReportView;

  /// No description provided for @weeklyReportLink.
  ///
  /// In en, this message translates to:
  /// **'Weekly report'**
  String get weeklyReportLink;

  /// No description provided for @weeklyReportThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get weeklyReportThisWeek;

  /// No description provided for @weeklyReportProgress.
  ///
  /// In en, this message translates to:
  /// **'Weekly progress'**
  String get weeklyReportProgress;

  /// No description provided for @weeklyReportQuests.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} quests completed'**
  String weeklyReportQuests(int completed, int total);

  /// No description provided for @weeklyReportAchievements.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 achievement earned this week} other{{count} achievements earned this week}}'**
  String weeklyReportAchievements(int count);

  /// No description provided for @weeklyReportNoData.
  ///
  /// In en, this message translates to:
  /// **'There is not enough data to generate a report this week.'**
  String get weeklyReportNoData;

  /// No description provided for @weeklyReportNoFamily.
  ///
  /// In en, this message translates to:
  /// **'Create your family to see its weekly report.'**
  String get weeklyReportNoFamily;

  /// No description provided for @topBarNotificationsUnread.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Notifications, 1 unread} other{Notifications, {count} unread}}'**
  String topBarNotificationsUnread(int count);

  /// No description provided for @topBarNotificationsCurrent.
  ///
  /// In en, this message translates to:
  /// **'Notifications. You are already in Notifications.'**
  String get topBarNotificationsCurrent;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsUnread.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unread} other{{count} unread}}'**
  String notificationsUnread(int count);

  /// No description provided for @notificationsAllRead.
  ///
  /// In en, this message translates to:
  /// **'All caught up'**
  String get notificationsAllRead;

  /// No description provided for @notificationsMarkAll.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notificationsMarkAll;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'You’ll be notified about family achievements, weekly reports and community events.'**
  String get notificationsEmptyMessage;

  /// No description provided for @notificationsErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load your notifications'**
  String get notificationsErrorTitle;

  /// No description provided for @notificationsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Your notifications are currently unavailable. Try again to reload them.'**
  String get notificationsErrorMessage;

  /// No description provided for @notificationsActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t update your notifications. Try again.'**
  String get notificationsActionFailed;

  /// No description provided for @notificationsLabelAchievements.
  ///
  /// In en, this message translates to:
  /// **'ACHIEVEMENTS'**
  String get notificationsLabelAchievements;

  /// No description provided for @notificationsLabelProgress.
  ///
  /// In en, this message translates to:
  /// **'PROGRESS'**
  String get notificationsLabelProgress;

  /// No description provided for @notificationsLabelEvents.
  ///
  /// In en, this message translates to:
  /// **'EVENTS'**
  String get notificationsLabelEvents;

  /// No description provided for @notificationsLabelCommunity.
  ///
  /// In en, this message translates to:
  /// **'COMMUNITY'**
  String get notificationsLabelCommunity;

  /// No description provided for @notificationsTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String notificationsTimeMinutes(int minutes);

  /// No description provided for @notificationsTimeHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h'**
  String notificationsTimeHours(int hours);

  /// No description provided for @notificationsTimeYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notificationsTimeYesterday;

  /// No description provided for @notificationsTimeDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day} other{{days} days}}'**
  String notificationsTimeDays(int days);

  /// No description provided for @notificationsRowUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread. {category}. {title}. {message}. {time}'**
  String notificationsRowUnread(
    String category,
    String title,
    String message,
    String time,
  );

  /// No description provided for @notificationsRowRead.
  ///
  /// In en, this message translates to:
  /// **'{category}. {title}. {message}. {time}'**
  String notificationsRowRead(
    String category,
    String title,
    String message,
    String time,
  );

  /// No description provided for @preferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get preferencesTitle;

  /// No description provided for @preferencesDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose which notifications you want to receive.'**
  String get preferencesDescription;

  /// No description provided for @preferencesAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements and badges'**
  String get preferencesAchievements;

  /// No description provided for @preferencesAchievementsDescription.
  ///
  /// In en, this message translates to:
  /// **'Family badges and achievements'**
  String get preferencesAchievementsDescription;

  /// No description provided for @preferencesWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly progress summary'**
  String get preferencesWeekly;

  /// No description provided for @preferencesWeeklyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your family weekly report'**
  String get preferencesWeeklyDescription;

  /// No description provided for @preferencesEvents.
  ///
  /// In en, this message translates to:
  /// **'Family community events'**
  String get preferencesEvents;

  /// No description provided for @preferencesEventsDescription.
  ///
  /// In en, this message translates to:
  /// **'Events for families published in your community'**
  String get preferencesEventsDescription;

  /// No description provided for @preferencesActivity.
  ///
  /// In en, this message translates to:
  /// **'Community activity'**
  String get preferencesActivity;

  /// No description provided for @preferencesActivityDescription.
  ///
  /// In en, this message translates to:
  /// **'Reactions, shared achievements and community goals'**
  String get preferencesActivityDescription;

  /// No description provided for @preferencesSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save your preference. Try again.'**
  String get preferencesSaveFailed;

  /// No description provided for @errorResetTokenInvalid.
  ///
  /// In en, this message translates to:
  /// **'This reset link has expired or was already used. Request a new link to reset your password.'**
  String get errorResetTokenInvalid;

  /// No description provided for @errorEmailDelivery.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t send the email right now. Try again in a few minutes.'**
  String get errorEmailDelivery;

  /// No description provided for @signInForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get signInForgotPassword;

  /// No description provided for @recoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get recoveryTitle;

  /// No description provided for @recoveryMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter the email of your parent account and we\'ll send you a link to create a new password.'**
  String get recoveryMessage;

  /// No description provided for @recoveryButton.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get recoveryButton;

  /// No description provided for @recoveryBackToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get recoveryBackToSignIn;

  /// No description provided for @recoverySentTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get recoverySentTitle;

  /// No description provided for @recoverySentMessage.
  ///
  /// In en, this message translates to:
  /// **'If {email} belongs to an EcoMind parent account, you\'ll receive a link to reset your password. Open it on this device. If you don\'t see it, check your spam folder.'**
  String recoverySentMessage(String email);

  /// No description provided for @recoveryResend.
  ///
  /// In en, this message translates to:
  /// **'Send the link again'**
  String get recoveryResend;

  /// No description provided for @recoveryLinkResent.
  ///
  /// In en, this message translates to:
  /// **'If the account exists, we sent a new link.'**
  String get recoveryLinkResent;

  /// No description provided for @recoveryChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'Use a different email'**
  String get recoveryChangeEmail;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new password'**
  String get resetTitle;

  /// No description provided for @resetMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password for your EcoMind account.'**
  String get resetMessage;

  /// No description provided for @resetPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get resetPasswordLabel;

  /// No description provided for @resetConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get resetConfirmPasswordLabel;

  /// No description provided for @resetButton.
  ///
  /// In en, this message translates to:
  /// **'Save new password'**
  String get resetButton;

  /// No description provided for @resetInvalidTitle.
  ///
  /// In en, this message translates to:
  /// **'This link isn\'t valid'**
  String get resetInvalidTitle;

  /// No description provided for @resetInvalidMessage.
  ///
  /// In en, this message translates to:
  /// **'The link is incomplete or damaged. Request a new link to reset your password.'**
  String get resetInvalidMessage;

  /// No description provided for @resetRequestNewLink.
  ///
  /// In en, this message translates to:
  /// **'Request a new link'**
  String get resetRequestNewLink;

  /// No description provided for @resetSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get resetSuccessTitle;

  /// No description provided for @resetSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password was changed. Sign in with your new password.'**
  String get resetSuccessMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es':
      {
        switch (locale.countryCode) {
          case '419':
            return AppLocalizationsEs419();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
