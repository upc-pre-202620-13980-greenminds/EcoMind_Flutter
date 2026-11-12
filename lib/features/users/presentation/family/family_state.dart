import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/users_exception.dart';

class FamilyState {
  const new({
    this.family,
    this.isLoading = false,
    this.hasLoaded = false,
    this.errorMessage,
  });

  // Null when the parent has no family yet
  final Family? family;
  final bool isLoading;
  // Tells "no family" apart from "not loaded yet"
  final bool hasLoaded;
  final UsersError? errorMessage;
}
