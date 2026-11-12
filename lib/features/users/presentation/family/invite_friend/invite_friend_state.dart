import 'package:ecomind_parents/features/users/domain/family_candidate.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';

class InviteFriendState {
  const new({
    this.candidates = const [],
    this.query = '',
    this.isLoading = false,
    this.addingUserId,
    this.errorMessage,
  });

  final List<FamilyCandidate> candidates;
  // Text of the search field
  final String query;
  final bool isLoading;
  // Friend whose request is running, so only that row shows a spinner
  final int? addingUserId;
  final UsersError? errorMessage;

  List<FamilyCandidate> get visibleCandidates {
    final text = query.trim().toLowerCase();
    if (text.isEmpty) {
      return candidates;
    }
    return candidates
        .where((candidate) => candidate.name.toLowerCase().contains(text))
        .toList();
  }

  // The error and the running request are not kept by copyWith
  InviteFriendState copyWith({
    List<FamilyCandidate>? candidates,
    String? query,
    bool? isLoading,
    int? addingUserId,
    UsersError? errorMessage,
  }) {
    return InviteFriendState(
      candidates: candidates ?? this.candidates,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      addingUserId: addingUserId,
      errorMessage: errorMessage,
    );
  }
}
