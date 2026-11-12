import 'package:ecomind_parents/features/users/application/create_family_use_case.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';
import 'package:ecomind_parents/features/users/presentation/family/create_family/create_family_state.dart';
import 'package:flutter/material.dart';

class CreateFamilyViewModel extends ChangeNotifier {
  final CreateFamilyUseCase createFamily;

  new({required this.createFamily});

  CreateFamilyState _state = CreateFamilyState();
  CreateFamilyState get state => _state;

  void onNameChange(String name) {
    _state = _state.copyWith(name: name, nameMissing: false);
    notifyListeners();
  }

  void onCommitmentChange(String commitment) {
    _state = _state.copyWith(commitment: commitment, commitmentMissing: false);
    notifyListeners();
  }

  Future<void> save() async {
    if (_state.isSaving) {
      return;
    }

    final nameMissing = _state.name.trim().isEmpty;
    final commitmentMissing = _state.commitment.trim().isEmpty;
    if (nameMissing || commitmentMissing) {
      _state = _state.copyWith(
        nameMissing: nameMissing,
        commitmentMissing: commitmentMissing,
      );
      notifyListeners();
      return;
    }

    _state = _state.copyWith(isSaving: true);
    notifyListeners();

    try {
      final family = await createFamily.execute(_state.name, _state.commitment);
      _state = _state.copyWith(isSaving: false, createdFamily: family);
    } on UsersException catch (e) {
      _state = _state.copyWith(isSaving: false, errorMessage: e.error);
    } catch (e) {
      _state = _state.copyWith(
        isSaving: false,
        errorMessage: UsersError.unknown,
      );
    }
    notifyListeners();
  }
}
