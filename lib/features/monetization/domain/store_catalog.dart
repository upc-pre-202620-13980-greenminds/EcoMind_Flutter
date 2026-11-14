enum CosmeticType { avatar, head, body, accessory, unknown }

CosmeticType cosmeticTypeFromString(String value) {
  return switch (value.toUpperCase()) {
    'AVATAR' => CosmeticType.avatar,
    'HEAD' => CosmeticType.head,
    'BODY' => CosmeticType.body,
    'ACCESSORY' => CosmeticType.accessory,
    _ => CosmeticType.unknown,
  };
}

class Cosmetic {
  final String id;
  final String name;
  final String description;
  final int priceInGems;
  final CosmeticType type;
  final String imageReference;

  const Cosmetic({
    required this.id,
    required this.name,
    required this.description,
    required this.priceInGems,
    required this.type,
    required this.imageReference,
  });
}

class Multiplier {
  final String id;
  final String name;
  final String description;
  final double factor;
  final int durationMinutes;
  final int priceInGems;

  const Multiplier({
    required this.id,
    required this.name,
    required this.description,
    required this.factor,
    required this.durationMinutes,
    required this.priceInGems,
  });
}

class StreakProtector {
  final String id;
  final String name;
  final String description;
  final int priceInGems;

  const StreakProtector({
    required this.id,
    required this.name,
    required this.description,
    required this.priceInGems,
  });
}

class GemPackage {
  final String id;
  final String name;
  final int gemAmount;
  final double price;
  final String currency;

  const GemPackage({
    required this.id,
    required this.name,
    required this.gemAmount,
    required this.price,
    required this.currency,
  });
}

class StoreCatalog {
  final List<Cosmetic> cosmetics;
  final List<Multiplier> multipliers;
  final List<StreakProtector> streakProtectors;
  final List<GemPackage> gemPackages;

  const StoreCatalog({
    this.cosmetics = const [],
    this.multipliers = const [],
    this.streakProtectors = const [],
    this.gemPackages = const [],
  });
}
