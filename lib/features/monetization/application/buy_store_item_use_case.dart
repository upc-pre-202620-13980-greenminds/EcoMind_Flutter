import 'package:ecomind_parents/features/monetization/domain/monetization_repository.dart';

enum StoreItemKind { cosmetic, multiplier, protector }

class BuyStoreItemUseCase {
  final MonetizationRepository repository;
  const BuyStoreItemUseCase({required this.repository});

  Future<void> execute(StoreItemKind kind, String itemId) => switch (kind) {
    StoreItemKind.cosmetic => repository.buyCosmetic(itemId),
    StoreItemKind.multiplier => repository.buyMultiplier(itemId),
    StoreItemKind.protector => repository.buyProtector(itemId),
  };
}
