// Rule of the personal commitment (HU-006), the same as in the student app
class PersonalCommitment {
  static const int maxLength = 150;

  // 1 to 150 characters, without the spaces at the start and at the end
  static bool isValid(String value) {
    final length = value.trim().length;
    return length >= 1 && length <= maxLength;
  }
}
