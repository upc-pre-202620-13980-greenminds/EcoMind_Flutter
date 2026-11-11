import 'package:ecomind_parents/features/iam/domain/auth_exception.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';

// Errors of the form fields; the ViewModel keeps the value and the page shows the text
enum FieldError {
  emailRequired,
  emailInvalid,
  passwordRequired,
  nameInvalid,
  passwordPolicy,
  passwordMismatch,
  termsRequired,
  codeFormat,
}

extension FieldErrorText on FieldError {
  String text(AppLocalizations l10n) {
    return switch (this) {
      FieldError.emailRequired => l10n.errorEmailRequired,
      FieldError.emailInvalid => l10n.errorEmailInvalid,
      FieldError.passwordRequired => l10n.errorPasswordRequired,
      FieldError.nameInvalid => l10n.errorNameInvalid,
      FieldError.passwordPolicy => l10n.errorPasswordPolicy,
      FieldError.passwordMismatch => l10n.errorPasswordMismatch,
      FieldError.termsRequired => l10n.errorTermsRequired,
      FieldError.codeFormat => l10n.errorCodeFormat,
    };
  }
}

extension AuthErrorText on AuthError {
  String text(AppLocalizations l10n) {
    return switch (this) {
      AuthError.invalidCredentials => l10n.errorInvalidCredentials,
      AuthError.notParent => l10n.errorStudentAccount,
      AuthError.emailConflict => l10n.errorEmailConflict,
      AuthError.passwordPolicy => l10n.errorPasswordPolicy,
      AuthError.codeInvalid => l10n.errorCodeInvalid,
      AuthError.codeExpired => l10n.errorCodeExpired,
      AuthError.tooManyAttempts => l10n.errorCodeAttempts,
      AuthError.connection => l10n.errorConnection,
      AuthError.unknown => l10n.errorUnknown,
    };
  }
}
