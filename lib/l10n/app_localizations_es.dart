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

  @override
  String get loading => 'Cargando';

  @override
  String get signInEmailLabel => 'Correo electrónico';

  @override
  String get signInPasswordLabel => 'Contraseña';

  @override
  String get signInButton => 'Iniciar sesión';

  @override
  String get signInNoAccount => '¿No tienes una cuenta?';

  @override
  String get signInSignUpLink => 'Regístrate';

  @override
  String get signInVerifyEmailHint =>
      'Si acabas de registrarte, primero verifica tu correo.';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get signUpNameLabel => 'Nombre';

  @override
  String get signUpConfirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get signUpTermsPrefix => 'Acepto los';

  @override
  String get signUpTermsLink => 'términos y la política';

  @override
  String get signUpTermsCheckbox => 'Acepto los términos y la política';

  @override
  String get signUpButton => 'Registrarme';

  @override
  String get signUpHaveAccount => '¿Ya tienes una cuenta?';

  @override
  String get termsTitle => 'Términos y política';

  @override
  String get termsBody =>
      'EcoMind es un proyecto educativo de sostenibilidad para estudiantes y familias. Sus actividades, materiales educativos y funciones de progreso apoyan el aprendizaje de hábitos ambientales.\n\nTu cuenta\nUsa tus propios datos de cuenta y mantén tu contraseña privada. Tu correo se utiliza para verificar tu cuenta y recuperar tu contraseña. Cierra sesión cuando termines de usar un dispositivo compartido.\n\nParticipación\nCompleta las actividades con honestidad y trata con respeto a los demás participantes. Los puntos, las rachas y los logros representan participación en EcoMind; no certifican ahorros ambientales medidos.\n\nPrivacidad\nEvita compartir información sensible en publicaciones comunitarias o evidencias de actividades. No compartas información personal de otras personas sin su permiso.\n\nLa información de términos y privacidad está pendiente de revisión por el equipo del proyecto.';

  @override
  String get verifyEmailSubtitle => '¡Ya casi terminas!';

  @override
  String verifyEmailMessage(String email) {
    return 'Enviamos un correo a $email. Revisa tu bandeja de entrada e ingresa el código.';
  }

  @override
  String get verifyEmailCodeLabel => 'Código de confirmación';

  @override
  String get verifyEmailButton => 'Confirmar correo';

  @override
  String get verifyEmailResend => 'Reenviar código';

  @override
  String get verifyEmailCodeResent => 'Te enviamos un código nuevo.';

  @override
  String get verifyEmailGoBack => 'Volver';

  @override
  String get errorEmailRequired => 'Ingresa tu correo electrónico.';

  @override
  String get errorEmailInvalid => 'Ingresa un correo electrónico válido.';

  @override
  String get errorPasswordRequired => 'Ingresa tu contraseña.';

  @override
  String get errorInvalidCredentials =>
      'El correo o la contraseña son incorrectos.';

  @override
  String get errorNameInvalid => 'Ingresa tu nombre (de 2 a 120 caracteres).';

  @override
  String get errorPasswordPolicy =>
      'La contraseña debe tener entre 8 y 72 caracteres, con al menos una letra y un número.';

  @override
  String get errorPasswordMismatch => 'Las contraseñas no coinciden.';

  @override
  String get errorTermsRequired => 'Debes aceptar los términos y la política.';

  @override
  String get errorEmailConflict =>
      'Este correo electrónico ya está registrado.';

  @override
  String get errorCodeFormat => 'Ingresa el código de 6 dígitos.';

  @override
  String get errorCodeInvalid => 'El código de verificación no es válido.';

  @override
  String get errorCodeExpired =>
      'El código de verificación venció. Solicita uno nuevo.';

  @override
  String get errorCodeAttempts =>
      'Demasiados intentos. Solicita un código nuevo.';

  @override
  String get errorStudentAccount =>
      'Esta aplicación es para madres y padres. Los estudiantes inician sesión en la aplicación EcoMind para estudiantes.';

  @override
  String get errorConnection =>
      'No se pudo conectar con el servidor. Inténtalo de nuevo.';

  @override
  String get errorUnknown => 'Ocurrió un problema. Inténtalo de nuevo.';
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');
}
