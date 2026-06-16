import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/token_storage.dart';
import '../core/constants/api_constants.dart';
import '../core/utils/local_storage_cache.dart';

class StatusTagihanService {

  static final List _dummyStatus = [
    {"ID_STATUS_TAGIHAN": 1, "NAMA_STATUS_TAGIHAN": "Lunas"},
    {"ID_STATUS_TAGIHAN": 2, "NAMA_STATUS_TAGIHAN": "Cicil"},
    {"ID_STATUS_TAGIHAN": 3, "NAMA_STATUS_TAGIHAN": "Belum Bayar"}
  ];

  Future<List<dynamic>> getStatusTagihan() async {
    try {
      final token = await TokenStorage.getAccessToken();

      final response = await http.get(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/status-tagihan",
        ),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final list = json["data"] ?? [];
        await LocalStorageCache.save('cache_status_tagihan_list', list);
        return list;
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_status_tagihan_list');
    if (cached != null) return cached;
    await LocalStorageCache.save('cache_status_tagihan_list', _dummyStatus);
    return _dummyStatus;
  }

  Future<Map<String, dynamic>> getDetailStatus(
    int id,
  ) async {
    try {
      final token = await TokenStorage.getAccessToken();

      final response = await http.get(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/status-tagihan/$id",
        ),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final map = json["data"] ?? {};
        await LocalStorageCache.save('cache_detail_status_$id', map);
        return map;
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_detail_status_$id');
    if (cached != null) {
      return cached;
    }

    throw Exception(
      "Status tagihan tidak ditemukan",
    );
  }

  Future<bool> createStatus(
    String namaStatus,
  ) async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.post(
      Uri.parse(
        "${ApiConstants.mahasiswaBaseUrl}/status-tagihan",
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
      body: jsonEncode({
        "nama_status_tagihan":
            namaStatus,
      }),
    );

    return response.statusCode ==
            200 ||
        response.statusCode == 201;
  }

  Future<bool> updateStatus({
    required int id,
    required String namaStatus,
  }) async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.put(
      Uri.parse(
        "${ApiConstants.mahasiswaBaseUrl}/status-tagihan/$id",
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
      body: jsonEncode({
        "nama_status_tagihan":
            namaStatus,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteStatus(
    int id,
  ) async {
    final token =
        await TokenStorage.getAccessToken();

    final response =
        await http.delete(
      Uri.parse(
        "${ApiConstants.mahasiswaBaseUrl}/status-tagihan/$id",
      ),
      headers: {
        "Accept": "application/json",
        "Authorization":
            "Bearer $token",
      },
    );

    return response.statusCode == 200;
  }
}