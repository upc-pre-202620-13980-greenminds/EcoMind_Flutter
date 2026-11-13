enum CommitmentError { required, length }

class CommitmentState {
  const new({
    this.text = '',
    this.isSaving = false,
    this.saveFailed = false,
    this.savedText,
    this.textError,
  });

  final String text;
  final bool isSaving;
  // The text stays in the field so the user can try again (frame 08)
  final bool saveFailed;
  // Commitment saved on the device; the page closes with it
  final String? savedText;
  final CommitmentError? textError;

  // The error is not kept by copyWith: a new change clears it
  CommitmentState copyWith({
    String? text,
    bool? isSaving,
    bool? saveFailed,
    String? savedText,
    CommitmentError? textError,
  }) {
    return CommitmentState(
      text: text ?? this.text,
      isSaving: isSaving ?? this.isSaving,
      saveFailed: saveFailed ?? this.saveFailed,
      savedText: savedText ?? this.savedText,
      textError: textError,
    );
  }
}
