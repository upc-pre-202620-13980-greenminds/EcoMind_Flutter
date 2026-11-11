import 'package:ecomind_parents/core/app_database.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
}
