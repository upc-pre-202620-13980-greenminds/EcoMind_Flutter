import 'package:ecomind_parents/features/users/application/add_family_member_use_case.dart';
import 'package:ecomind_parents/features/users/application/get_invitable_friends_use_case.dart';
import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_candidate.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';
import 'package:ecomind_parents/features/users/presentation/family/invite_friend/invite_friend_state.dart';
import 'package:flutter/material.dart';

class InviteFriendViewModel extends ChangeNotifier {
  final GetInvitableFriendsUseCase getInvitableFriends;
  final AddFamilyMemberUseCase addFamilyMember;

  new({required this.getInvitableFriends, required this.addFamilyMember});

  InviteFriendState _state = InviteFriendState();
  InviteFriendState get state => _state;

  Future<void> loadCandidates() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final candidates = await getInvitableFriends.execute();
      _state = _state.copyWith(candidates: candidates, isLoading: false);
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

  void onQueryChange(String query) {
    _state = _state.copyWith(query: query);
    notifyListeners();
  }

  // Returns the family with the new member, or null when it failed;
  // the reason stays in errorMessage so the page can show it
  Future<Family?> add(Family family, FamilyCandidate candidate) async {
    if (_state.addingUserId != null) {
      return null;
    }

    _state = _state.copyWith(addingUserId: candidate.userId);
    notifyListeners();

    try {
      final updated = await addFamilyMember.execute(family, candidate);
      // The friend now belongs to the family, so they can no longer be invited
      _state = _state.copyWith(
        candidates: _state.candidates
            .where((c) => c.userId != candidate.userId)
            .toList(),
      );
      notifyListeners();
      return updated;
    } on UsersException catch (e) {
      _state = _state.copyWith(errorMessage: e.error);
    } catch (e) {
      _state = _state.copyWith(errorMessage: UsersError.unknown);
    }
    notifyListeners();
    return null;
  }
}
