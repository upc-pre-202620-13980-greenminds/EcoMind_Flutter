import 'package:ecomind_parents/features/monetization/application/buy_store_item_use_case.dart';
import 'package:ecomind_parents/features/monetization/application/get_gem_balance_use_case.dart';
import 'package:ecomind_parents/features/monetization/application/get_inventory_use_case.dart';
import 'package:ecomind_parents/features/monetization/application/get_store_catalog_use_case.dart';
import 'package:ecomind_parents/features/monetization/application/set_cosmetic_equipped_use_case.dart';
import 'package:ecomind_parents/features/monetization/domain/monetization_exception.dart';
import 'package:ecomind_parents/features/monetization/presentation/store/store_state.dart';
import 'package:flutter/foundation.dart';

class StoreViewModel extends ChangeNotifier {
  final GetStoreCatalogUseCase getCatalog;
  final GetInventoryUseCase getInventory;
  final GetGemBalanceUseCase getGemBalance;
  final BuyStoreItemUseCase buyItem;
  final SetCosmeticEquippedUseCase setCosmeticEquipped;

  StoreViewModel({
    required this.getCatalog,
    required this.getInventory,
    required this.getGemBalance,
    required this.buyItem,
    required this.setCosmeticEquipped,
  });

  StoreState _state = const StoreState();
  StoreState get state => _state;

  Future<void> load() async {
    _state = _state.copyWith(isLoading: true, clearError: true);
    notifyListeners();
    try {
      final results = await Future.wait([
        getCatalog.execute(),
        getInventory.execute(),
        getGemBalance.execute(),
      ]);
      _state = _state.copyWith(
        catalog: results[0] as dynamic,
        inventory: results[1] as dynamic,
        gemBalance: results[2] as int,
        isLoading: false,
      );
    } on MonetizationException catch (error) {
      _state = _state.copyWith(isLoading: false, error: error.error);
    } catch (_) {
      _state = _state.copyWith(
        isLoading: false,
        error: MonetizationError.unknown,
      );
    }
    notifyListeners();
  }

  void selectCategory(StoreCategory category) {
    _state = _state.copyWith(category: category);
    notifyListeners();
  }

  void setInventoryVisible(bool visible) {
    _state = _state.copyWith(showInventory: visible);
    notifyListeners();
  }

  Future<void> purchase(StoreItemKind kind, String itemId) async {
    await _perform(itemId, () => buyItem.execute(kind, itemId));
  }

  Future<void> changeEquipment(String ownedCosmeticId, bool equipped) async {
    await _perform(
      ownedCosmeticId,
      () => setCosmeticEquipped.execute(ownedCosmeticId, equipped),
    );
  }

  Future<void> _perform(
    String itemId,
    Future<void> Function() operation,
  ) async {
    _state = _state.copyWith(
      busyItemId: itemId,
      clearError: true,
      operationSucceeded: false,
    );
    notifyListeners();
    try {
      await operation();
      final inventory = await getInventory.execute();
      final balance = await getGemBalance.execute();
      _state = _state.copyWith(
        inventory: inventory,
        gemBalance: balance,
        clearBusyItem: true,
        operationSucceeded: true,
      );
    } on MonetizationException catch (error) {
      _state = _state.copyWith(
        clearBusyItem: true,
        error: error.error,
        operationSucceeded: false,
      );
    }
    notifyListeners();
  }

  void consumeFeedback() {
    _state = _state.copyWith(clearError: true, operationSucceeded: false);
  }
}
