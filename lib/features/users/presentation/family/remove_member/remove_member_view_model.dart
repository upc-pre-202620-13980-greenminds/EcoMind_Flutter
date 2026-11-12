import 'package:ecomind_parents/features/users/application/remove_family_member_use_case.dart';
import 'package:ecomind_parents/features/users/domain/family_member.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';
import 'package:ecomind_parents/features/users/presentation/family/remove_member/remove_member_state.dart';
import 'package:flutter/material.dart';

class RemoveMemberViewModel extends ChangeNotifier {
  final RemoveFamilyMemberUseCase removeFamilyMember;

  new({required this.removeFamilyMember});

  RemoveMemberState _state = RemoveMemberState();
  RemoveMemberState get state => _state;

  Future<void> remove(FamilyMember member) async {
    if (_state.isRemoving) {
      return;
    }

    _state = _state.copyWith(isRemoving: true);
    notifyListeners();

    try {
      final family = await removeFamilyMember.execute(member);
      _state = _state.copyWith(
        isRemoving: false,
        isRemoved: true,
        updatedFamily: family,
      );
    } on UsersException catch (e) {
      _state = _state.copyWith(isRemoving: false, errorMessage: e.error);
    } catch (e) {
      _state = _state.copyWith(
        isRemoving: false,
        errorMessage: UsersError.unknown,
      );
    }
    notifyListeners();
  }
}
