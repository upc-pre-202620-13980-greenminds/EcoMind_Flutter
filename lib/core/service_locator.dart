import 'package:ecomind_parents/core/app_database.dart';
import 'package:ecomind_parents/features/iam/application/check_session_use_case.dart';
import 'package:ecomind_parents/features/iam/application/confirm_password_recovery_use_case.dart';
import 'package:ecomind_parents/features/iam/application/request_password_recovery_use_case.dart';
import 'package:ecomind_parents/features/iam/application/sign_in_use_case.dart';
import 'package:ecomind_parents/features/iam/application/sign_out_use_case.dart';
import 'package:ecomind_parents/features/iam/application/sign_up_use_case.dart';
import 'package:ecomind_parents/features/iam/application/verify_email_use_case.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/iam/infrastructure/auth_repository_impl.dart';
import 'package:ecomind_parents/features/iam/infrastructure/remote/iam_api.dart';
import 'package:ecomind_parents/features/iam/infrastructure/session_dao.dart';
import 'package:ecomind_parents/features/iam/infrastructure/session_repository_impl.dart';
import 'package:ecomind_parents/features/iam/presentation/recovery_request/password_recovery_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/reset_password/reset_password_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_up/sign_up_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/splash/splash_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/verify_email/verify_email_view_model.dart';
import 'package:ecomind_parents/features/monetization/application/buy_store_item_use_case.dart';
import 'package:ecomind_parents/features/monetization/application/get_gem_balance_use_case.dart';
import 'package:ecomind_parents/features/monetization/application/get_inventory_use_case.dart';
import 'package:ecomind_parents/features/monetization/application/get_store_catalog_use_case.dart';
import 'package:ecomind_parents/features/monetization/application/set_cosmetic_equipped_use_case.dart';
import 'package:ecomind_parents/features/monetization/domain/monetization_repository.dart';
import 'package:ecomind_parents/features/monetization/infrastructure/monetization_repository_impl.dart';
import 'package:ecomind_parents/features/monetization/infrastructure/remote/monetization_api.dart';
import 'package:ecomind_parents/features/monetization/presentation/store/store_view_model.dart';
import 'package:ecomind_parents/features/users/application/add_family_member_use_case.dart';
import 'package:ecomind_parents/features/users/application/create_family_use_case.dart';
import 'package:ecomind_parents/features/users/application/get_current_profile_use_case.dart';
import 'package:ecomind_parents/features/users/application/get_invitable_friends_use_case.dart';
import 'package:ecomind_parents/features/users/application/get_my_family_use_case.dart';
import 'package:ecomind_parents/features/users/application/get_notification_preferences_use_case.dart';
import 'package:ecomind_parents/features/users/application/get_visible_notifications_use_case.dart';
import 'package:ecomind_parents/features/users/application/mark_all_notifications_read_use_case.dart';
import 'package:ecomind_parents/features/users/application/mark_notification_read_use_case.dart';
import 'package:ecomind_parents/features/users/application/update_notification_preferences_use_case.dart';
import 'package:ecomind_parents/features/users/domain/notification_preferences_repository.dart';
import 'package:ecomind_parents/features/users/domain/notification_repository.dart';
import 'package:ecomind_parents/features/users/infrastructure/local/notification_preferences_dao.dart';
import 'package:ecomind_parents/features/users/infrastructure/notification_preferences_repository_impl.dart';
import 'package:ecomind_parents/features/users/infrastructure/notification_repository_impl.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/notification_api.dart';
import 'package:ecomind_parents/features/users/presentation/notification_preferences/notification_preferences_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/notifications/notifications_view_model.dart';
import 'package:ecomind_parents/features/users/application/get_weekly_report_use_case.dart';
import 'package:ecomind_parents/features/users/domain/family_report_repository.dart';
import 'package:ecomind_parents/features/users/infrastructure/family_report_repository_impl.dart';
import 'package:ecomind_parents/features/users/infrastructure/local/weekly_quests_local_data_source.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/gamification_api.dart';
import 'package:ecomind_parents/features/users/presentation/report/weekly_report_view_model.dart';
import 'package:ecomind_parents/features/users/application/remove_family_member_use_case.dart';
import 'package:ecomind_parents/features/users/domain/family_repository.dart';
import 'package:ecomind_parents/features/users/infrastructure/family_repository_impl.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/family_api.dart';
import 'package:ecomind_parents/features/users/presentation/family/create_family/create_family_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/family/invite_friend/invite_friend_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/family/remove_member/remove_member_view_model.dart';
import 'package:ecomind_parents/features/users/application/update_profile_name_use_case.dart';
import 'package:ecomind_parents/features/users/domain/user_profile_repository.dart';
import 'package:ecomind_parents/features/users/infrastructure/remote/user_api.dart';
import 'package:ecomind_parents/features/users/infrastructure/user_profile_repository_impl.dart';
import 'package:ecomind_parents/features/users/presentation/edit_profile/edit_profile_view_model.dart';
import 'package:ecomind_parents/features/users/presentation/profile/profile_view_model.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  getIt.registerLazySingleton<SessionDao>(
    () => SessionDao(appDatabase: getIt<AppDatabase>()),
  );

  getIt.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(dao: getIt<SessionDao>()),
  );

  getIt.registerLazySingleton<IamApi>(() => IamApi());

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(api: getIt<IamApi>()),
  );

  getIt.registerLazySingleton<CheckSessionUseCase>(
    () => CheckSessionUseCase(repository: getIt<SessionRepository>()),
  );

  getIt.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(
      authRepository: getIt<AuthRepository>(),
      sessionRepository: getIt<SessionRepository>(),
    ),
  );

  getIt.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<VerifyEmailUseCase>(
    () => VerifyEmailUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(
      authRepository: getIt<AuthRepository>(),
      sessionRepository: getIt<SessionRepository>(),
    ),
  );

  getIt.registerLazySingleton<RequestPasswordRecoveryUseCase>(
    () => RequestPasswordRecoveryUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<ConfirmPasswordRecoveryUseCase>(
    () => ConfirmPasswordRecoveryUseCase(
      authRepository: getIt<AuthRepository>(),
      sessionRepository: getIt<SessionRepository>(),
    ),
  );

  getIt.registerLazySingleton<UserApi>(() => UserApi());

  getIt.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(
      api: getIt<UserApi>(),
      sessionRepository: getIt<SessionRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetCurrentProfileUseCase>(
    () => GetCurrentProfileUseCase(repository: getIt<UserProfileRepository>()),
  );

  getIt.registerLazySingleton<UpdateProfileNameUseCase>(
    () => UpdateProfileNameUseCase(repository: getIt<UserProfileRepository>()),
  );

  // Shared by MainPage, the top bar and the Profile tab
  getIt.registerLazySingleton<ProfileViewModel>(
    () => ProfileViewModel(
      getCurrentProfile: getIt<GetCurrentProfileUseCase>(),
      signOutUseCase: getIt<SignOutUseCase>(),
    ),
  );

  getIt.registerFactory<EditProfileViewModel>(
    () => EditProfileViewModel(
      updateProfileName: getIt<UpdateProfileNameUseCase>(),
    ),
  );

  getIt.registerLazySingleton<FamilyApi>(() => FamilyApi());

  getIt.registerLazySingleton<FamilyRepository>(
    () => FamilyRepositoryImpl(
      familyApi: getIt<FamilyApi>(),
      userApi: getIt<UserApi>(),
      sessionRepository: getIt<SessionRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetMyFamilyUseCase>(
    () => GetMyFamilyUseCase(repository: getIt<FamilyRepository>()),
  );

  getIt.registerLazySingleton<CreateFamilyUseCase>(
    () => CreateFamilyUseCase(repository: getIt<FamilyRepository>()),
  );

  getIt.registerLazySingleton<GetInvitableFriendsUseCase>(
    () => GetInvitableFriendsUseCase(repository: getIt<FamilyRepository>()),
  );

  getIt.registerLazySingleton<AddFamilyMemberUseCase>(
    () => AddFamilyMemberUseCase(repository: getIt<FamilyRepository>()),
  );

  getIt.registerLazySingleton<RemoveFamilyMemberUseCase>(
    () => RemoveFamilyMemberUseCase(repository: getIt<FamilyRepository>()),
  );

  // Shared by the Family tab and the screens that change the family
  getIt.registerLazySingleton<FamilyViewModel>(
    () => FamilyViewModel(getMyFamily: getIt<GetMyFamilyUseCase>()),
  );

  getIt.registerFactory<CreateFamilyViewModel>(
    () => CreateFamilyViewModel(createFamily: getIt<CreateFamilyUseCase>()),
  );

  getIt.registerFactory<InviteFriendViewModel>(
    () => InviteFriendViewModel(
      getInvitableFriends: getIt<GetInvitableFriendsUseCase>(),
      addFamilyMember: getIt<AddFamilyMemberUseCase>(),
    ),
  );

  getIt.registerFactory<RemoveMemberViewModel>(
    () => RemoveMemberViewModel(
      removeFamilyMember: getIt<RemoveFamilyMemberUseCase>(),
    ),
  );

  getIt.registerLazySingleton<WeeklyQuestsLocalDataSource>(
    () => WeeklyQuestsLocalDataSource(),
  );

  getIt.registerLazySingleton<GamificationApi>(() => GamificationApi());

  getIt.registerLazySingleton<FamilyReportRepository>(
    () => FamilyReportRepositoryImpl(
      questsDataSource: getIt<WeeklyQuestsLocalDataSource>(),
      gamificationApi: getIt<GamificationApi>(),
      sessionRepository: getIt<SessionRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetWeeklyReportUseCase>(
    () => GetWeeklyReportUseCase(repository: getIt<FamilyReportRepository>()),
  );

  // Shared by the report card of the Profile tab and the report screen
  getIt.registerLazySingleton<WeeklyReportViewModel>(
    () =>
        WeeklyReportViewModel(getWeeklyReport: getIt<GetWeeklyReportUseCase>()),
  );

  getIt.registerLazySingleton<NotificationApi>(() => NotificationApi());

  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      api: getIt<NotificationApi>(),
      sessionRepository: getIt<SessionRepository>(),
    ),
  );

  getIt.registerLazySingleton<NotificationPreferencesDao>(
    () => NotificationPreferencesDao(appDatabase: getIt<AppDatabase>()),
  );

  getIt.registerLazySingleton<NotificationPreferencesRepository>(
    () => NotificationPreferencesRepositoryImpl(
      dao: getIt<NotificationPreferencesDao>(),
      sessionRepository: getIt<SessionRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetVisibleNotificationsUseCase>(
    () => GetVisibleNotificationsUseCase(
      notificationRepository: getIt<NotificationRepository>(),
      preferencesRepository: getIt<NotificationPreferencesRepository>(),
    ),
  );

  getIt.registerLazySingleton<MarkNotificationReadUseCase>(
    () => MarkNotificationReadUseCase(
      repository: getIt<NotificationRepository>(),
    ),
  );

  getIt.registerLazySingleton<MarkAllNotificationsReadUseCase>(
    () => MarkAllNotificationsReadUseCase(
      repository: getIt<NotificationRepository>(),
    ),
  );

  getIt.registerLazySingleton<GetNotificationPreferencesUseCase>(
    () => GetNotificationPreferencesUseCase(
      repository: getIt<NotificationPreferencesRepository>(),
    ),
  );

  getIt.registerLazySingleton<UpdateNotificationPreferencesUseCase>(
    () => UpdateNotificationPreferencesUseCase(
      repository: getIt<NotificationPreferencesRepository>(),
    ),
  );

  // Shared by the inbox and the badge of the bell
  getIt.registerLazySingleton<NotificationsViewModel>(
    () => NotificationsViewModel(
      getVisibleNotifications: getIt<GetVisibleNotificationsUseCase>(),
      markNotificationRead: getIt<MarkNotificationReadUseCase>(),
      markAllNotificationsRead: getIt<MarkAllNotificationsReadUseCase>(),
    ),
  );

  getIt.registerFactory<NotificationPreferencesViewModel>(
    () => NotificationPreferencesViewModel(
      getPreferences: getIt<GetNotificationPreferencesUseCase>(),
      updatePreferences: getIt<UpdateNotificationPreferencesUseCase>(),
    ),
  );

  getIt.registerLazySingleton<SplashViewModel>(
    () => SplashViewModel(checkSession: getIt<CheckSessionUseCase>()),
  );

  // Forms get a new ViewModel every time they open, so they always start empty
  getIt.registerFactory<SignInViewModel>(
    () => SignInViewModel(signIn: getIt<SignInUseCase>()),
  );

  getIt.registerFactory<SignUpViewModel>(
    () => SignUpViewModel(signUp: getIt<SignUpUseCase>()),
  );

  getIt.registerFactory<VerifyEmailViewModel>(
    () => VerifyEmailViewModel(
      verifyEmail: getIt<VerifyEmailUseCase>(),
      signUp: getIt<SignUpUseCase>(),
      signIn: getIt<SignInUseCase>(),
    ),
  );

  // Disposed by their pages, so the typed email, passwords and token do not outlive them
  getIt.registerFactory<PasswordRecoveryViewModel>(
    () => PasswordRecoveryViewModel(
      requestPasswordRecovery: getIt<RequestPasswordRecoveryUseCase>(),
    ),
  );

  getIt.registerFactory<ResetPasswordViewModel>(
    () => ResetPasswordViewModel(
      confirmPasswordRecovery: getIt<ConfirmPasswordRecoveryUseCase>(),
    ),
  );

  getIt.registerLazySingleton<MonetizationApi>(() => MonetizationApi());
  getIt.registerLazySingleton<MonetizationRepository>(
    () => MonetizationRepositoryImpl(
      api: getIt<MonetizationApi>(),
      sessionRepository: getIt<SessionRepository>(),
    ),
  );
  getIt.registerLazySingleton<GetStoreCatalogUseCase>(
    () => GetStoreCatalogUseCase(repository: getIt<MonetizationRepository>()),
  );
  getIt.registerLazySingleton<GetInventoryUseCase>(
    () => GetInventoryUseCase(repository: getIt<MonetizationRepository>()),
  );
  getIt.registerLazySingleton<GetGemBalanceUseCase>(
    () => GetGemBalanceUseCase(repository: getIt<MonetizationRepository>()),
  );
  getIt.registerLazySingleton<BuyStoreItemUseCase>(
    () => BuyStoreItemUseCase(repository: getIt<MonetizationRepository>()),
  );
  getIt.registerLazySingleton<SetCosmeticEquippedUseCase>(
    () =>
        SetCosmeticEquippedUseCase(repository: getIt<MonetizationRepository>()),
  );
  getIt.registerLazySingleton<StoreViewModel>(
    () => StoreViewModel(
      getCatalog: getIt<GetStoreCatalogUseCase>(),
      getInventory: getIt<GetInventoryUseCase>(),
      getGemBalance: getIt<GetGemBalanceUseCase>(),
      buyItem: getIt<BuyStoreItemUseCase>(),
      setCosmeticEquipped: getIt<SetCosmeticEquippedUseCase>(),
    ),
  );
}
