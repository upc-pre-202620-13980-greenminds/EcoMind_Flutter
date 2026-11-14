import 'dart:convert';
import 'dart:io';

import 'package:ecomind_parents/core/api_config.dart';
import 'package:ecomind_parents/core/api_exception.dart';
import 'package:ecomind_parents/features/monetization/infrastructure/remote/monetization_dto.dart';
import 'package:http/http.dart' as http;

class MonetizationApi {
  Map<String, String> _headers(String token, {bool json = false}) => {
    'Authorization': 'Bearer $token',
    if (json) 'Content-Type': 'application/json',
  };

  Future<StoreCatalogDto> getCatalog(String token) async {
    final response = await http
        .get(
          ApiConfig.uri('/api/v1/monetization/store'),
          headers: _headers(token),
        )
        .timeout(ApiConfig.timeout);
    if (response.statusCode == HttpStatus.ok) {
      return StoreCatalogDto(_object(response));
    }
    throw ApiException.fromResponse(response);
  }

  Future<InventoryDto> getInventory(String token) async {
    final response = await http
        .get(
          ApiConfig.uri('/api/v1/monetization/me/inventory'),
          headers: _headers(token),
        )
        .timeout(ApiConfig.timeout);
    if (response.statusCode == HttpStatus.ok) {
      return InventoryDto(_object(response));
    }
    throw ApiException.fromResponse(response);
  }

  Future<int> getGemBalance(String token) async {
    final response = await http
        .get(
          ApiConfig.uri('/api/v1/monetization/me/wallet'),
          headers: _headers(token),
        )
        .timeout(ApiConfig.timeout);
    if (response.statusCode == HttpStatus.ok) {
      return (_object(response)['balance'] as num?)?.toInt() ?? 0;
    }
    throw ApiException.fromResponse(response);
  }

  Future<void> buy(
    String token,
    String path,
    String itemId,
    String requestId,
  ) async {
    final response = await http
        .post(
          ApiConfig.uri(path),
          headers: _headers(token, json: true),
          body: jsonEncode({'itemId': itemId, 'requestId': requestId}),
        )
        .timeout(ApiConfig.timeout);
    if (response.statusCode != HttpStatus.created) {
      throw ApiException.fromResponse(response);
    }
  }

  Future<void> setCosmeticEquipped(
    String token,
    String ownedCosmeticId,
    bool equipped,
  ) async {
    final uri = ApiConfig.uri(
      '/api/v1/monetization/me/cosmetics/$ownedCosmeticId/equipped',
    );
    final response = equipped
        ? await http
              .put(uri, headers: _headers(token))
              .timeout(ApiConfig.timeout)
        : await http
              .delete(uri, headers: _headers(token))
              .timeout(ApiConfig.timeout);
    if (response.statusCode != HttpStatus.noContent) {
      throw ApiException.fromResponse(response);
    }
  }

  Map<String, dynamic> _object(http.Response response) =>
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
}
