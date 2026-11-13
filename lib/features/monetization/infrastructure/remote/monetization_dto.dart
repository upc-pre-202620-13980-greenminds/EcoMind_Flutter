import 'package:ecomind_parents/features/monetization/domain/inventory.dart';
import 'package:ecomind_parents/features/monetization/domain/store_catalog.dart';

class StoreCatalogDto {
  final Map<String, dynamic> json;
  const StoreCatalogDto(this.json);

  StoreCatalog toDomain() => StoreCatalog(
    cosmetics: _list('cosmetics')
        .map(
          (item) => Cosmetic(
            id: item['id'] as String,
            name: item['name'] as String? ?? '',
            description: item['description'] as String? ?? '',
            priceInGems: (item['priceInGems'] as num?)?.toInt() ?? 0,
            type: cosmeticTypeFromString(item['type'] as String? ?? ''),
            imageReference: item['imageReference'] as String? ?? '',
          ),
        )
        .toList(),
    multipliers: _list('multipliers')
        .map(
          (item) => Multiplier(
            id: item['id'] as String,
            name: item['name'] as String? ?? '',
            description: item['description'] as String? ?? '',
            factor: (item['factor'] as num?)?.toDouble() ?? 1,
            durationMinutes: (item['durationMinutes'] as num?)?.toInt() ?? 0,
            priceInGems: (item['priceInGems'] as num?)?.toInt() ?? 0,
          ),
        )
        .toList(),
    streakProtectors: _list('streakProtectors')
        .map(
          (item) => StreakProtector(
            id: item['id'] as String,
            name: item['name'] as String? ?? '',
            description: item['description'] as String? ?? '',
            priceInGems: (item['priceInGems'] as num?)?.toInt() ?? 0,
          ),
        )
        .toList(),
    gemPackages: _list('gemPackages')
        .map(
          (item) => GemPackage(
            id: item['id'] as String,
            name: item['name'] as String? ?? '',
            gemAmount: (item['gemAmount'] as num?)?.toInt() ?? 0,
            price: (item['price'] as num?)?.toDouble() ?? 0,
            currency: item['currency'] as String? ?? '',
          ),
        )
        .toList(),
  );

  List<Map<String, dynamic>> _list(String key) =>
      (json[key] as List? ?? const []).cast<Map<String, dynamic>>();
}

class InventoryDto {
  final Map<String, dynamic> json;
  const InventoryDto(this.json);

  Inventory toDomain() => Inventory(
    cosmetics: _list('cosmetics')
        .map(
          (item) => OwnedCosmetic(
            id: item['id'] as String,
            cosmeticId: item['cosmeticId'] as String,
            equipped: item['equipped'] as bool? ?? false,
          ),
        )
        .toList(),
    protectors: _list('protectors')
        .map(
          (item) => OwnedProtector(
            id: item['id'] as String,
            protectorId: item['protectorId'] as String,
            quantity: (item['quantity'] as num?)?.toInt() ?? 0,
          ),
        )
        .toList(),
    multipliers: _list('multipliers')
        .map(
          (item) => OwnedMultiplier(
            id: item['id'] as String,
            multiplierId: item['multiplierId'] as String,
            factor: (item['factor'] as num?)?.toDouble() ?? 1,
            startsAt: DateTime.parse(item['startsAt'] as String),
            expiresAt: DateTime.parse(item['expiresAt'] as String),
          ),
        )
        .toList(),
  );

  List<Map<String, dynamic>> _list(String key) =>
      (json[key] as List? ?? const []).cast<Map<String, dynamic>>();
}
