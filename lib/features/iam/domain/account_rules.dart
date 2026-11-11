// Same rules the backend applies, checked before sending the request

abstract final class EmailAddress {
  static const int maxLength = 255;
  static final RegExp _pattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$',
  );

  static String normalize(String value) => value.trim().toLowerCase();

  static bool isValid(String value) {
    return value.length <= maxLength && _pattern.hasMatch(value);
  }
}

abstract final class PersonName {
  static const int minLength = 2;
  static const int maxLength = 120;

  static bool isValid(String value) {
    final length = value.trim().length;
    return length >= minLength && length <= maxLength;
  }
}

abstract final class PasswordPolicy {
  static const int minLength = 8;
  static const int maxLength = 72;

  static bool isSatisfiedBy(String password) {
    if (password.length < minLength || password.length > maxLength) {
      return false;
    }
    final hasLetter = RegExp(r'\p{L}', unicode: true).hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);
    return hasLetter && hasDigit;
  }
}

abstract final class VerificationCode {
  static const int length = 6;

  static bool isValid(String value) {
    return RegExp(r'^\d{6}$').hasMatch(value);
  }
}
