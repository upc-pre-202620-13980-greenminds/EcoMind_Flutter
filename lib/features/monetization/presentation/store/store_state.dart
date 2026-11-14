import 'package:ecomind_parents/features/monetization/domain/inventory.dart';
import 'package:ecomind_parents/features/monetization/domain/monetization_exception.dart';
import 'package:ecomind_parents/features/monetization/domain/store_catalog.dart';

enum StoreCategory { cosmetics, multipliers, gems }

class StoreState {
  final StoreCatalog catalog;
  final Inventory inventory;
  final int gemBalance;
  final StoreCategory category;
  final bool showInventory;
  final bool isLoading;
  final String? busyItemId;
  final MonetizationError? error;
  final bool operationSucceeded;

  const StoreState({
    this.catalog = const StoreCatalog(),
    this.inventory = const Inventory(),
    this.gemBalance = 0,
    this.category = StoreCategory.cosmetics,
    this.showInventory = false,
    this.isLoading = false,
    this.busyItemId,
    this.error,
    this.operationSucceeded = false,
  });

  StoreState copyWith({
    StoreCatalog? catalog,
    Inventory? inventory,
    int? gemBalance,
    StoreCategory? category,
    bool? showInventory,
    bool? isLoading,
    String? busyItemId,
    bool clearBusyItem = false,
    MonetizationError? error,
    bool clearError = false,
    bool? operationSucceeded,
  }) => StoreState(
    catalog: catalog ?? this.catalog,
    inventory: inventory ?? this.inventory,
    gemBalance: gemBalance ?? this.gemBalance,
    category: category ?? this.category,
    showInventory: showInventory ?? this.showInventory,
    isLoading: isLoading ?? this.isLoading,
    busyItemId: clearBusyItem ? null : busyItemId ?? this.busyItemId,
    error: clearError ? null : error ?? this.error,
    operationSucceeded: operationSucceeded ?? this.operationSucceeded,
  );
}
