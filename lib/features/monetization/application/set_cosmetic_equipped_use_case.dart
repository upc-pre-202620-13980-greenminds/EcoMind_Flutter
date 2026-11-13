import 'package:ecomind_parents/features/monetization/domain/monetization_repository.dart';

class SetCosmeticEquippedUseCase {
  final MonetizationRepository repository;
  const SetCosmeticEquippedUseCase({required this.repository});

  Future<void> execute(String ownedCosmeticId, bool equipped) =>
      repository.setCosmeticEquipped(ownedCosmeticId, equipped);
}
