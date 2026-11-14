import 'package:ecomind_parents/features/users/application/get_my_family_use_case.dart';
import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';
import 'package:ecomind_parents/features/users/presentation/family/family_state.dart';
import 'package:flutter/material.dart';

// Shared by the Family tab and the screens that change the family,
// so all of them show the same list of members
class FamilyViewModel extends ChangeNotifier {
  final GetMyFamilyUseCase getMyFamily;

  new({required this.getMyFamily});

  FamilyState _state = FamilyState();
  FamilyState get state => _state;

  Future<void> loadFamily() async {
    // A new initial state, so the family of a previous parent is never shown
    _state = FamilyState().copyWith(isLoading: true);
    notifyListeners();

    try {
      final family = await getMyFamily.execute();
      _state = _state.copyWith(
        family: family,
        isLoading: false,
        hasLoaded: true,
      );
    } on UsersException catch (e) {
      _state = _state.copyWith(isLoading: false, errorMessage: e.error);
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: UsersError.unknown,
      );
    }
    notifyListeners();
  }

  // Called after creating the family or adding and removing members
  void onFamilyChanged(Family? family) {
    // copyWith cannot set the family back to null, so that case starts from a new state
    _state = family == null
        ? FamilyState(hasLoaded: true)
        : _state.copyWith(family: family, isLoading: false, hasLoaded: true);
    notifyListeners();
  }
}
