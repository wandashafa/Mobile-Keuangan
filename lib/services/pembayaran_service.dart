import 'dart:convert';
import 'package:http/http.dart' as http;

import 'token_storage.dart';
import '../core/constants/api_constants.dart';
import '../core/utils/local_storage_cache.dart';

class PembayaranService {

  static final List _dummyPembayaran = [
    {
      "ID_PEMBAYARAN": 1,
      "ID_TAGIHAN": 1,
      "ID_METODE": 1,
      "JUMLAH_BAYAR": 500000.0,
      "TANGGAL_BAYAR": "2026-06-16",
      "CICILAN_KE": 1
    }
  ];

  // =========================
  // GET ALL PEMBAYARAN
  // =========================
  Future<List<dynamic>> getPembayaran() async {
    try {
      final token = await TokenStorage.getAccessToken();

      final response = await http.get(
        Uri.parse("${ApiConstants.mahasiswaBaseUrl}/pembayaran"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data["data"] ?? [];
        await LocalStorageCache.save('cache_pembayaran', list);
        return list;
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_pembayaran');
    if (cached is List) return cached;
    await LocalStorageCache.save('cache_pembayaran', _dummyPembayaran);
    return _dummyPembayaran;
  }

  // =========================
  // DETAIL PEMBAYARAN
  // =========================
  Future<Map<String, dynamic>>
      getDetailPembayaran(
    int id,
  ) async {
    try {
      final token = await TokenStorage.getAccessToken();

      final response = await http.get(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/pembayaran/$id",
        ),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final map = data["data"] ?? {};
        await LocalStorageCache.save('cache_detail_pembayaran_$id', map);
        return map;
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_detail_pembayaran_$id');
    if (cached != null) {
      return cached;
    }

    final listCached = await LocalStorageCache.get('cache_pembayaran');
    if (listCached is List) {
      final found = listCached.firstWhere(
        (e) => (e['ID_PEMBAYARAN'] ?? e['id_pembayaran'])?.toString() == id.toString(),
        orElse: () => null,
      );
      if (found != null) {
        return Map<String, dynamic>.from(found);
      }
    }

    throw Exception(
      "Pembayaran tidak ditemukan",
    );
  }

  // =========================
  // CREATE PEMBAYARAN
  // =========================
  Future<bool> createPembayaran({
    required int idTagihan,
    required int idMetode,
    required double jumlahBayar,
    required String tanggalBayar,
    required int cicilanKe,
  }) async {
    final token = await TokenStorage.getAccessToken();

    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.mahasiswaBaseUrl}/pembayaran"),
        headers: {
          "Accept": "application/json",
          "Content-Type":
              "application/json",
          "Authorization":
              "Bearer $token",
        },
        body: jsonEncode({
          "id_tagihan":
              idTagihan,
          "id_metode":
              idMetode,
          "jumlah_bayar":
              jumlahBayar,
          "tanggal_bayar":
              tanggalBayar,
          "cicilan_ke":
              cicilanKe,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_pembayaran') ?? _dummyPembayaran;
      final List<Map<String, dynamic>> list = (cachedRaw is List)
          ? cachedRaw.map((e) => Map<String, dynamic>.from(e)).toList()
          : _dummyPembayaran.map((e) => Map<String, dynamic>.from(e)).toList();
      final lastItem = list.isEmpty ? null : list.last;
      final lastId = lastItem == null ? 0 : (lastItem['ID_PEMBAYARAN'] ?? lastItem['id_pembayaran'] ?? 0);
      final newId = (int.tryParse(lastId.toString()) ?? 0) + 1;

      // Resolve tagihan offline
      try {
        final tagihanList = await LocalStorageCache.get('cache_tagihan_list') ?? [];
        final List<Map<String, dynamic>> updatedTagihanList = (tagihanList is List)
            ? tagihanList.map((e) => Map<String, dynamic>.from(e)).toList()
            : [];
        final foundIndex = updatedTagihanList.indexWhere((e) => (e['ID_TAGIHAN'] ?? e['id_tagihan']).toString() == idTagihan.toString());
        if (foundIndex != -1) {
          updatedTagihanList[foundIndex]['ID_STATUS_TAGIHAN'] = 1; // Lunas
          updatedTagihanList[foundIndex]['id_status_tagihan'] = 1; // Lunas
          await LocalStorageCache.save('cache_tagihan_list', updatedTagihanList);
        }
      } catch (_) {}

      list.add({
        "ID_PEMBAYARAN": newId,
        "ID_TAGIHAN": idTagihan,
        "ID_METODE": idMetode,
        "JUMLAH_BAYAR": jumlahBayar,
        "TANGGAL_BAYAR": tanggalBayar,
        "CICILAN_KE": cicilanKe
      });

      await LocalStorageCache.save('cache_pembayaran', list);
      return true;
    } catch (_) {}

    return false;
  }

  // =========================
  // UPDATE PEMBAYARAN
  // =========================
  Future<bool> updatePembayaran({
    required int idPembayaran,
    required double jumlahBayar,
    required int idMetode,
  }) async {
    final token = await TokenStorage.getAccessToken();

    try {
      final response = await http.put(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/pembayaran/$idPembayaran",
        ),
        headers: {
          "Accept": "application/json",
          "Content-Type":
              "application/json",
          "Authorization":
              "Bearer $token",
        },
        body: jsonEncode({
          "jumlah_bayar":
              jumlahBayar,
          "id_metode":
              idMetode,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_pembayaran') ?? _dummyPembayaran;
      final List<Map<String, dynamic>> list = (cachedRaw is List)
          ? cachedRaw.map((e) => Map<String, dynamic>.from(e)).toList()
          : _dummyPembayaran.map((e) => Map<String, dynamic>.from(e)).toList();
      final index = list.indexWhere((e) => e['ID_PEMBAYARAN'].toString() == idPembayaran.toString());
      if (index != -1) {
        list[index]['JUMLAH_BAYAR'] = jumlahBayar;
        list[index]['ID_METODE'] = idMetode;
        await LocalStorageCache.save('cache_pembayaran', list);
        return true;
      }
    } catch (_) {}

    return false;
  }

  // =========================
  // DELETE PEMBAYARAN
  // =========================
  Future<bool> deletePembayaran(
    int id,
  ) async {
    final token = await TokenStorage.getAccessToken();

    try {
      final response = await http.delete(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/pembayaran/$id",
        ),
        headers: {
          "Accept":
              "application/json",
          "Authorization":
              "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_pembayaran') ?? _dummyPembayaran;
      final List<Map<String, dynamic>> list = (cachedRaw is List)
          ? cachedRaw.map((e) => Map<String, dynamic>.from(e)).toList()
          : _dummyPembayaran.map((e) => Map<String, dynamic>.from(e)).toList();
      list.removeWhere((e) => e['ID_PEMBAYARAN'].toString() == id.toString());
      await LocalStorageCache.save('cache_pembayaran', list);
      return true;
    } catch (_) {}

    return false;
  }
}