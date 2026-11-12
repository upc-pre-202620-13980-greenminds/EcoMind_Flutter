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

  @override
  String topBarGems(int count) {
    return '$count gemas';
  }

  @override
  String topBarEcopoints(int count) {
    return '$count ecopoints';
  }

  @override
  String get profileTitle => 'Tu perfil';

  @override
  String get profileEdit => 'Editar';

  @override
  String get roleParent => 'Madre o padre';

  @override
  String get roleStudent => 'Estudiante';

  @override
  String get profileStatStreak => 'Días de racha';

  @override
  String get profileStatEcopoints => 'EcoPoints';

  @override
  String get profileStatGems => 'Gemas';

  @override
  String profileStatDescription(int value, String label) {
    return '$value, $label';
  }

  @override
  String get profileShare => 'Compartir';

  @override
  String get profileFavorites => 'Favoritos';

  @override
  String get profileTabProfile => 'Perfil';

  @override
  String get profileTabFriends => 'Amigos';

  @override
  String get profileTabFamily => 'Familia';

  @override
  String get profileTryAgain => 'Reintentar';

  @override
  String get profileErrorTitle => 'No pudimos cargar tu perfil';

  @override
  String get profileErrorMessage =>
      'Tu información no está disponible en este momento.\nReintenta para cargarla de nuevo.';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get editProfileTitle => 'Editar perfil';

  @override
  String get editProfileNameLabel => 'Nombre';

  @override
  String get editProfileNamePlaceholder => 'Escribe tu nombre';

  @override
  String get editProfileRoleLabel => 'Rol';

  @override
  String get editProfileSave => 'Guardar cambios';

  @override
  String get editProfileCancel => 'Cancelar';

  @override
  String get editProfileNameRequired => 'Ingresa tu nombre.';

  @override
  String get editProfileNameLength =>
      'El nombre debe tener entre 2 y 120 caracteres.';

  @override
  String get editProfileSaveFailed => 'No pudimos guardar tus cambios.';

  @override
  String get editProfileSaveFailedHint =>
      'Tu texto sigue aquí. Inténtalo de nuevo.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get tabError => 'No se pudo cargar esta información.';

  @override
  String get familyEmptyTitle => 'Aún no tienes familia';

  @override
  String get familyEmptyMessage => 'Crea tu familia para reunir a todos.';

  @override
  String get familyCreate => 'Crear familia';

  @override
  String get familyManage => 'Gestionar';

  @override
  String familyMembersCount(int count) {
    return 'Miembros · $count';
  }

  @override
  String get familyManagerRole => 'Madre o padre · gestiona la familia';

  @override
  String get familyRoleParent => 'Madre o padre';

  @override
  String get familyRoleChild => 'Hija o hijo';

  @override
  String get familyYou => 'Tú';

  @override
  String get createFamilyTitle => 'Crear familia';

  @override
  String get familyNameLabel => 'Nombre de la familia';

  @override
  String get familyNamePlaceholder => 'Escribe el nombre de la familia';

  @override
  String get familyCommitmentLabel => 'Compromiso de la familia';

  @override
  String get familyCommitmentPlaceholder =>
      'Escribe el compromiso de la familia';

  @override
  String get familyNameRequired => 'Ingresa un nombre para la familia.';

  @override
  String get familyCommitmentRequired =>
      'Ingresa un compromiso para la familia.';

  @override
  String get familyRequiredInfo => 'Completa la información obligatoria.';

  @override
  String get createFamilySave => 'Guardar cambios';

  @override
  String get errorCreatorNotParent =>
      'Solo una cuenta de madre o padre puede crear una familia.';

  @override
  String get errorAlreadyInFamily => 'Ya perteneces a una familia.';

  @override
  String get errorFamilyFull => 'Una familia puede tener hasta 5 miembros.';

  @override
  String get manageFamilyTitle => 'Gestionar familia';

  @override
  String get manageMembersTitle => 'Miembros';

  @override
  String get manageAddMember => 'Agregar miembro';

  @override
  String get manageEditMember => 'Editar';

  @override
  String manageEditMemberDescription(String name) {
    return 'Abrir a $name';
  }

  @override
  String get manageNoMembers => 'Aún no hay otros miembros.';

  @override
  String get inviteTitle => 'Invitar a un amigo';

  @override
  String get inviteChooseFriend => 'Elige a un amigo';

  @override
  String get inviteSearchHint => 'Busca entre tus amigos';

  @override
  String get inviteFriendSubtitle => 'Amigo';

  @override
  String get inviteButton => 'Invitar';

  @override
  String inviteButtonDescription(String name) {
    return 'Agregar a $name a la familia';
  }

  @override
  String get inviteEmpty =>
      'Ninguno de tus amigos puede unirse ahora. No se muestran los amigos que ya pertenecen a una familia.';

  @override
  String inviteAdded(String name) {
    return '$name se agregó a la familia.';
  }

  @override
  String get memberTitle => 'Miembro de la familia';

  @override
  String get memberRoleLabel => 'Rol en la familia';

  @override
  String get memberRoleHelp =>
      'Describe su lugar en la familia.\nNo cambia el rol de su cuenta.';

  @override
  String get removeMemberAction => 'Quitar miembro';

  @override
  String get removeMemberTitle => 'Quitar miembro';

  @override
  String removeMemberMessage(String name, String family) {
    return '¿Quitar a $name de $family?\nYa no pertenecerá a esta familia.';
  }

  @override
  String get conflictTitle => 'Agregar miembro';

  @override
  String get conflictHeading => 'Ya pertenece a una familia';

  @override
  String get conflictMessage =>
      'Un usuario solo puede pertenecer a una familia activa a la vez.';

  @override
  String get conflictBack => 'Volver a los miembros';

  @override
  String get weeklyReportTitle => 'Informe semanal de la familia';

  @override
  String get weeklyReportView => 'Ver informe';

  @override
  String get weeklyReportLink => 'Informe semanal';

  @override
  String get weeklyReportThisWeek => 'Esta semana';

  @override
  String get weeklyReportProgress => 'Progreso semanal';

  @override
  String weeklyReportQuests(int completed, int total) {
    return '$completed de $total retos completados';
  }

  @override
  String weeklyReportAchievements(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count logros obtenidos esta semana',
      one: '1 logro obtenido esta semana',
    );
    return '$_temp0';
  }

  @override
  String get weeklyReportNoData =>
      'No hay datos suficientes para generar un reporte esta semana.';

  @override
  String get weeklyReportNoFamily =>
      'Crea tu familia para ver su informe semanal.';
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');
}
