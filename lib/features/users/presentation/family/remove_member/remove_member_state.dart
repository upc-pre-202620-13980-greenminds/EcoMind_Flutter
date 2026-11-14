import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';

class RemoveMemberState {
  const new({
    this.isRemoving = false,
    this.isRemoved = false,
    this.updatedFamily,
    this.errorMessage,
  });

  final bool isRemoving;
  final bool isRemoved;
  // Family without the member, as the backend returns it
  final Family? updatedFamily;
  final UsersError? errorMessage;

  // The error is not kept by copyWith: a new change clears it
  RemoveMemberState copyWith({
    bool? isRemoving,
    bool? isRemoved,
    Family? updatedFamily,
    UsersError? errorMessage,
  }) {
    return RemoveMemberState(
      isRemoving: isRemoving ?? this.isRemoving,
      isRemoved: isRemoved ?? this.isRemoved,
      updatedFamily: updatedFamily ?? this.updatedFamily,
      errorMessage: errorMessage,
    );
  }
}
