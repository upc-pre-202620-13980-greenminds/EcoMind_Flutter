import 'package:ecomind_parents/features/monetization/domain/inventory.dart';
import 'package:ecomind_parents/features/monetization/domain/store_catalog.dart';

abstract class MonetizationRepository {
  Future<StoreCatalog> getCatalog();
  Future<Inventory> getInventory();
  Future<int> getGemBalance();
  Future<void> buyCosmetic(String cosmeticId);
  Future<void> setCosmeticEquipped(String ownedCosmeticId, bool equipped);
  Future<void> buyMultiplier(String multiplierId);
  Future<void> buyProtector(String protectorId);
}
