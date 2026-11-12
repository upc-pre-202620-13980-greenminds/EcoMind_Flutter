import 'package:ecomind_parents/features/users/domain/family.dart';
import 'package:ecomind_parents/features/users/domain/family_repository.dart';

class CreateFamilyUseCase {
  final FamilyRepository repository;

  const new({required this.repository});

  // The backend makes the parent the first member, with the PARENT role
  Future<Family> execute(String name, String commitment) {
    return repository.createFamily(name.trim(), commitment.trim());
  }
}
