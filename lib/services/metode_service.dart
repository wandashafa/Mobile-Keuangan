import 'dart:convert';
import 'package:http/http.dart' as http;

import 'token_storage.dart';
import '../core/constants/api_constants.dart';
import '../core/utils/local_storage_cache.dart';

class MetodeService {

  static final List _dummyMetode = [
    {"id_metode": 1, "nama_metode": "Transfer Bank"},
    {"id_metode": 2, "nama_metode": "E-Wallet"},
    {"id_metode": 3, "nama_metode": "Tunai / Loket"}
  ];

  Future<List<dynamic>> getMetode() async {
    try {
      final token = await TokenStorage.getAccessToken();

      final response = await http.get(
        Uri.parse("${ApiConstants.mahasiswaBaseUrl}/metode"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data["data"] ?? [];
        await LocalStorageCache.save('cache_metode', list);
        return list;
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_metode');
    if (cached != null) return cached;
    await LocalStorageCache.save('cache_metode', _dummyMetode);
    return _dummyMetode;
  }
}