import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';

class CreateFamilyState {
  const new({
    this.name = '',
    this.commitment = '',
    this.isSaving = false,
    this.nameMissing = false,
    this.commitmentMissing = false,
    this.createdFamily,
    this.errorMessage,
  });

  final String name;
  final String commitment;
  final bool isSaving;
  // Required fields left empty (frame 45)
  final bool nameMissing;
  final bool commitmentMissing;
  // Family returned by the backend; the page closes with it
  final Family? createdFamily;
  final UsersError? errorMessage;

  bool get hasMissingFields => nameMissing || commitmentMissing;

  // The error is not kept by copyWith: a new change clears it
  CreateFamilyState copyWith({
    String? name,
    String? commitment,
    bool? isSaving,
    bool? nameMissing,
    bool? commitmentMissing,
    Family? createdFamily,
    UsersError? errorMessage,
  }) {
    return CreateFamilyState(
      name: name ?? this.name,
      commitment: commitment ?? this.commitment,
      isSaving: isSaving ?? this.isSaving,
      nameMissing: nameMissing ?? this.nameMissing,
      commitmentMissing: commitmentMissing ?? this.commitmentMissing,
      createdFamily: createdFamily ?? this.createdFamily,
      errorMessage: errorMessage,
    );
  }
}
