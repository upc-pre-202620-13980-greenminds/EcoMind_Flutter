import 'package:ecomind_parents/core/app_database.dart';
import 'package:ecomind_parents/features/iam/application/check_session_use_case.dart';
import 'package:ecomind_parents/features/iam/application/sign_in_use_case.dart';
import 'package:ecomind_parents/features/iam/application/sign_up_use_case.dart';
import 'package:ecomind_parents/features/iam/application/verify_email_use_case.dart';
import 'package:ecomind_parents/features/iam/domain/auth_repository.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/iam/infrastructure/auth_repository_impl.dart';
import 'package:ecomind_parents/features/iam/infrastructure/remote/iam_api.dart';
import 'package:ecomind_parents/features/iam/infrastructure/session_dao.dart';
import 'package:ecomind_parents/features/iam/infrastructure/session_repository_impl.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_in/sign_in_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/sign_up/sign_up_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/splash/splash_view_model.dart';
import 'package:ecomind_parents/features/iam/presentation/verify_email/verify_email_view_model.dart';
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
}
