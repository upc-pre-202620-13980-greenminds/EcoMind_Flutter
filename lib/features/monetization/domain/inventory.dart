class OwnedCosmetic {
  final String id;
  final String cosmeticId;
  final bool equipped;

  const OwnedCosmetic({
    required this.id,
    required this.cosmeticId,
    required this.equipped,
  });
}

class OwnedProtector {
  final String id;
  final String protectorId;
  final int quantity;

  const OwnedProtector({
    required this.id,
    required this.protectorId,
    required this.quantity,
  });
}

class OwnedMultiplier {
  final String id;
  final String multiplierId;
  final double factor;
  final DateTime startsAt;
  final DateTime expiresAt;

  const OwnedMultiplier({
    required this.id,
    required this.multiplierId,
    required this.factor,
    required this.startsAt,
    required this.expiresAt,
  });

  bool isActive(DateTime now) =>
      !now.isBefore(startsAt) && now.isBefore(expiresAt);
}

class Inventory {
  final List<OwnedCosmetic> cosmetics;
  final List<OwnedProtector> protectors;
  final List<OwnedMultiplier> multipliers;

  const Inventory({
    this.cosmetics = const [],
    this.protectors = const [],
    this.multipliers = const [],
  });
}
