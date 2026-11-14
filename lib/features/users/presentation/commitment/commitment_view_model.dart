import 'package:ecomind_parents/features/users/application/save_commitment_use_case.dart';
import 'package:ecomind_parents/features/users/domain/personal_commitment.dart';
import 'package:ecomind_parents/features/users/presentation/commitment/commitment_state.dart';
import 'package:flutter/material.dart';

class CommitmentViewModel extends ChangeNotifier {
  final SaveCommitmentUseCase saveCommitment;

  new({required this.saveCommitment});

  CommitmentState _state = CommitmentState();
  CommitmentState get state => _state;

  // When editing, the field starts with the commitment the user already has
  void start(String? text) {
    _state = CommitmentState(text: text ?? '');
  }

  void onTextChange(String text) {
    _state = _state.copyWith(text: text, saveFailed: false);
    notifyListeners();
  }

  Future<void> save() async {
    if (_state.isSaving) {
      return;
    }

    final text = _state.text.trim();
    final CommitmentError? textError = text.isEmpty
        ? CommitmentError.required
        : !PersonalCommitment.isValid(text)
        ? CommitmentError.length
        : null;
    if (textError != null) {
      _state = _state.copyWith(textError: textError);
      notifyListeners();
      return;
    }

    _state = _state.copyWith(isSaving: true, saveFailed: false);
    notifyListeners();

    try {
      final saved = await saveCommitment.execute(text);
      _state = _state.copyWith(isSaving: false, savedText: saved);
    } catch (e) {
      _state = _state.copyWith(isSaving: false, saveFailed: true);
    }
    notifyListeners();
  }
}
