import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/iam/domain/session.dart';
import 'package:ecomind_parents/features/iam/domain/session_repository.dart';
import 'package:ecomind_parents/features/monetization/domain/inventory.dart';
import 'package:ecomind_parents/features/monetization/domain/monetization_exception.dart';
import 'package:ecomind_parents/features/monetization/domain/monetization_repository.dart';
import 'package:ecomind_parents/features/monetization/domain/store_catalog.dart';
import 'package:ecomind_parents/features/monetization/infrastructure/remote/monetization_api.dart';
import 'package:http/http.dart' as http;

class MonetizationRepositoryImpl implements MonetizationRepository {
  final MonetizationApi api;
  final SessionRepository sessionRepository;
  final Random _random;

  MonetizationRepositoryImpl({
    required this.api,
    required this.sessionRepository,
    Random? random,
  }) : _random = random ?? Random.secure();

  @override
  Future<StoreCatalog> getCatalog() => _guard(
    (session) async => (await api.getCatalog(session.accessToken)).toDomain(),
  );

  @override
  Future<Inventory> getInventory() => _guard(
    (session) async => (await api.getInventory(session.accessToken)).toDomain(),
  );

  @override
  Future<int> getGemBalance() =>
      _guard((session) => api.getGemBalance(session.accessToken));

  @override
  Future<void> buyCosmetic(String cosmeticId) =>
      _buy('/api/v1/monetization/me/cosmetics/purchases', cosmeticId);

  @override
  Future<void> buyMultiplier(String multiplierId) =>
      _buy('/api/v1/monetization/me/multipliers/purchases', multiplierId);

  @override
  Future<void> buyProtector(String protectorId) =>
      _buy('/api/v1/monetization/me/protectors/purchases', protectorId);

  Future<void> _buy(String path, String itemId) => _guard(
    (session) => api.buy(session.accessToken, path, itemId, _uuidV4()),
  );

  @override
  Future<void> setCosmeticEquipped(String ownedCosmeticId, bool equipped) =>
      _guard(
        (session) => api.setCosmeticEquipped(
          session.accessToken,
          ownedCosmeticId,
          equipped,
        ),
      );

  Future<T> _guard<T>(Future<T> Function(Session) request) async {
    final session = await sessionRepository.getSession();
    if (session == null || session.isExpired(DateTime.now())) {
      throw const MonetizationException(MonetizationError.sessionExpired);
    }
    try {
      return await request(session);
    } on ApiException catch (error) {
      final code = error.code.toUpperCase();
      if (code.contains('INSUFFICIENT')) {
        throw const MonetizationException(MonetizationError.insufficientGems);
      }
      if (code.contains('ALREADY')) {
        throw const MonetizationException(MonetizationError.alreadyOwned);
      }
      throw MonetizationException(switch (error.statusCode) {
        HttpStatus.unauthorized => MonetizationError.sessionExpired,
        HttpStatus.notFound => MonetizationError.notFound,
        _ => MonetizationError.unknown,
      });
    } on TimeoutException {
      throw const MonetizationException(MonetizationError.connection);
    } on SocketException {
      throw const MonetizationException(MonetizationError.connection);
    } on http.ClientException {
      throw const MonetizationException(MonetizationError.connection);
    }
  }

  String _uuidV4() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((value) => value.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
