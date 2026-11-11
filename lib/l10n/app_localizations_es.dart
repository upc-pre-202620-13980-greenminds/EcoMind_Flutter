// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'EcoMind';

  @override
  String get logoDescription => 'Logotipo de EcoMind';

  @override
  String get navStore => 'Tienda';

  @override
  String get navRanking => 'Ranking';

  @override
  String get navMainMenu => 'Menú principal';

  @override
  String get navProgress => 'Progreso';

  @override
  String get navCommunity => 'Comunidad';

  @override
  String get navProfile => 'Perfil';

  @override
  String get topBarNotifications => 'Notificaciones';

  @override
  String get topBarSettings => 'Ajustes';

  @override
  String get comingSoonTitle => 'Próximamente';

  @override
  String get comingSoonMessage => 'Esta sección estará disponible pronto.';
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');
}
