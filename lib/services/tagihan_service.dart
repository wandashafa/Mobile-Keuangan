import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/token_storage.dart';
import '../core/constants/api_constants.dart';
import '../core/utils/local_storage_cache.dart';

class TagihanService {

  static final List _dummyTagihan = [
    {
      "ID_TAGIHAN": 1,
      "NIM": "A0313001",
      "ID_TAHUN_AKADEMIK": "2",
      "ID_STATUS_TAGIHAN": 1,
      "TOTAL_TAGIHAN": 500000.0,
      "JATUH_TEMPO": "2026-06-30",
      "status_tagihan": {"NAMA_STATUS_TAGIHAN": "Lunas"},
      "ukt_kategori": {"NAMA_KATEGORI": "Kategori I", "NOMINAL": 500000.0}
    },
    {
      "ID_TAGIHAN": 2,
      "NIM": "A0313002",
      "ID_TAHUN_AKADEMIK": "2",
      "ID_STATUS_TAGIHAN": 2,
      "TOTAL_TAGIHAN": 1500000.0,
      "JATUH_TEMPO": "2026-06-30",
      "status_tagihan": {"NAMA_STATUS_TAGIHAN": "Belum Bayar"},
      "ukt_kategori": {"NAMA_KATEGORI": "Kategori II", "NOMINAL": 1500000.0}
    }
  ];

  Future<List<dynamic>> getTagihan() async {
    try {
      final token = await TokenStorage.getAccessToken();

      final response = await http.get(
        Uri.parse("${ApiConstants.mahasiswaBaseUrl}/tagihan"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final list = json["data"] ?? [];
        await LocalStorageCache.save('cache_tagihan_list', list);
        return list;
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_tagihan_list');
    if (cached != null) return cached;
    await LocalStorageCache.save('cache_tagihan_list', _dummyTagihan);
    return _dummyTagihan;
  }

  Future<Map<String, dynamic>> getDetailTagihan(
    int id,
  ) async {
    try {
      final token = await TokenStorage.getAccessToken();

      final response = await http.get(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/tagihan/$id",
        ),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final map = json["data"] ?? {};
        await LocalStorageCache.save('cache_detail_tagihan_$id', map);
        return map;
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_detail_tagihan_$id');
    if (cached != null) {
      return cached;
    }

    final listCached = await LocalStorageCache.get('cache_tagihan_list');
    if (listCached is List) {
      final found = listCached.firstWhere(
        (e) => (e['ID_TAGIHAN'] ?? e['id_tagihan'])?.toString() == id.toString(),
        orElse: () => null,
      );
      if (found != null) {
        return Map<String, dynamic>.from(found);
      }
    }

    throw Exception(
      "Tagihan tidak ditemukan",
    );
  }

  Future<bool> createTagihan({
    required String nim,
    required String idTahunAkademik,
    required int idUktKategori,
    required int idStatusTagihan,
    int? idMb,
    required String jatuhTempo,
  }) async {
    final token = await TokenStorage.getAccessToken();

    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.mahasiswaBaseUrl}/tagihan"),
        headers: {
          "Accept": "application/json",
          "Content-Type":
              "application/json",
          "Authorization":
              "Bearer $token",
        },
        body: jsonEncode({
          "nim": nim,
          "id_tahun_akademik":
              idTahunAkademik,
          "id_ukt_kategori":
              idUktKategori,
          "id_status_tagihan":
              idStatusTagihan,
          "id_mb": idMb,
          "jatuh_tempo":
              jatuhTempo,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_tagihan_list') ?? _dummyTagihan;
      final List<Map<String, dynamic>> list = (cachedRaw is List)
          ? cachedRaw.map((e) => Map<String, dynamic>.from(e)).toList()
          : _dummyTagihan.map((e) => Map<String, dynamic>.from(e)).toList();
      final newId = list.isEmpty ? 1 : (int.parse((list.last['ID_TAGIHAN'] ?? list.last['id_tagihan'] ?? 0).toString()) + 1);

      double catNominal = 0.0;
      String catName = "Kategori";
      try {
        final catList = await LocalStorageCache.get('cache_kategori_ukt') ?? [];
        final found = catList.firstWhere((e) => e['ID_UKT_KATEGORI'].toString() == idUktKategori.toString(), orElse: () => null);
        if (found != null) {
          catName = found['NAMA_KATEGORI'] ?? "Kategori";
          catNominal = double.parse((found['NOMINAL'] ?? 0.0).toString());
        }
      } catch (_) {}

      String statusName = "Belum Bayar";
      try {
        final statusList = await LocalStorageCache.get('cache_status_tagihan') ?? [];
        final found = statusList.firstWhere((e) => e['ID_STATUS_TAGIHAN'].toString() == idStatusTagihan.toString(), orElse: () => null);
        if (found != null) statusName = found['NAMA_STATUS_TAGIHAN'] ?? "Belum Bayar";
      } catch (_) {}

      list.add({
        "ID_TAGIHAN": newId,
        "NIM": nim,
        "ID_TAHUN_AKADEMIK": idTahunAkademik,
        "ID_STATUS_TAGIHAN": idStatusTagihan,
        "TOTAL_TAGIHAN": catNominal,
        "JATUH_TEMPO": jatuhTempo,
        "status_tagihan": {"NAMA_STATUS_TAGIHAN": statusName},
        "ukt_kategori": {"NAMA_KATEGORI": catName, "NOMINAL": catNominal}
      });

      await LocalStorageCache.save('cache_tagihan_list', list);
      return true;
    } catch (_) {}

    return false;
  }

  Future<bool> updateTagihan({
    required int idTagihan,
    required int idStatusTagihan,
    required double totalTagihan,
    required String jatuhTempo,
    String? nim,
    String? idTahunAkademik,
  }) async {
    final token = await TokenStorage.getAccessToken();

    try {
      final Map<String, dynamic> bodyData = {
        "id_status_tagihan": idStatusTagihan,
        "total_tagihan": totalTagihan,
        "jatuh_tempo": jatuhTempo,
      };
      if (nim != null) bodyData["nim"] = nim;
      if (idTahunAkademik != null) bodyData["id_tahun_akademik"] = idTahunAkademik;

      final response = await http.put(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/tagihan/$idTagihan",
        ),
        headers: {
          "Accept": "application/json",
          "Content-Type":
              "application/json",
          "Authorization":
              "Bearer $token",
        },
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_tagihan_list') ?? _dummyTagihan;
      final List<Map<String, dynamic>> list = (cachedRaw is List)
          ? cachedRaw.map((e) => Map<String, dynamic>.from(e)).toList()
          : _dummyTagihan.map((e) => Map<String, dynamic>.from(e)).toList();
      final index = list.indexWhere((e) => (e['ID_TAGIHAN'] ?? e['id_tagihan']).toString() == idTagihan.toString());
      if (index != -1) {
        String statusName = "Belum Bayar";
        try {
          final statusList = await LocalStorageCache.get('cache_status_tagihan_list') ?? [];
          final found = statusList.firstWhere((e) => (e['ID_STATUS_TAGIHAN'] ?? e['id_status_tagihan']).toString() == idStatusTagihan.toString(), orElse: () => null);
          if (found != null) statusName = found['NAMA_STATUS_TAGIHAN'] ?? found['nama_status_tagihan'] ?? "Belum Bayar";
        } catch (_) {}

        list[index]['ID_STATUS_TAGIHAN'] = idStatusTagihan;
        list[index]['TOTAL_TAGIHAN'] = totalTagihan;
        list[index]['JATUH_TEMPO'] = jatuhTempo;
        list[index]['status_tagihan'] = {"NAMA_STATUS_TAGIHAN": statusName};
        if (nim != null) {
          list[index]['NIM'] = nim;
          list[index]['nim'] = nim;
        }
        if (idTahunAkademik != null) {
          list[index]['ID_TAHUN_AKADEMIK'] = idTahunAkademik;
          list[index]['id_tahun_akademik'] = idTahunAkademik;
        }
        await LocalStorageCache.save('cache_tagihan_list', list);
        return true;
      }
    } catch (_) {}

    return false;
  }

  Future<bool> deleteTagihan(
    int id,
  ) async {
    final token = await TokenStorage.getAccessToken();

    try {
      final response = await http.delete(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/tagihan/$id",
        ),
        headers: {
          "Accept": "application/json",
          "Authorization":
              "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_tagihan_list') ?? _dummyTagihan;
      final List<Map<String, dynamic>> list = (cachedRaw is List)
          ? cachedRaw.map((e) => Map<String, dynamic>.from(e)).toList()
          : _dummyTagihan.map((e) => Map<String, dynamic>.from(e)).toList();
      list.removeWhere((e) => (e['ID_TAGIHAN'] ?? e['id_tagihan'] ?? '').toString() == id.toString());
      await LocalStorageCache.save('cache_tagihan_list', list);
      return true;
    } catch (_) {}

    return false;
  }
}