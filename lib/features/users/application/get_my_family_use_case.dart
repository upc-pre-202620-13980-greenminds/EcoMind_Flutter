import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_repository.dart';

class GetMyFamilyUseCase {
  final FamilyRepository repository;

  const new({required this.repository});

  Future<Family?> execute() {
    return repository.getMyFamily();
  }
}
