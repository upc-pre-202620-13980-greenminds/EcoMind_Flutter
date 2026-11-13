import 'package:ecomind_parents/features/monetization/domain/inventory.dart';
import 'package:ecomind_parents/features/monetization/domain/monetization_repository.dart';

class GetInventoryUseCase {
  final MonetizationRepository repository;
  const GetInventoryUseCase({required this.repository});
  Future<Inventory> execute() => repository.getInventory();
}
