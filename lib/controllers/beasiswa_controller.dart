import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/beasiswa.dart';
import '../core/constants/api_constants.dart';
import '../services/token_storage.dart';
import '../core/utils/local_storage_cache.dart';

class BeasiswaController {
  Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.getAccessToken();
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static final List _dummyBeasiswa = [
    {"ID_BEASISWA": 1, "NAMA_BEASISWA": "KIP Kuliah", "KETERANGAN": "Bantuan biaya pendidikan dari pemerintah"},
    {"ID_BEASISWA": 2, "NAMA_BEASISWA": "Beasiswa Prestasi", "KETERANGAN": "Beasiswa akademik nilai IPK tinggi"},
    {"ID_BEASISWA": 3, "NAMA_BEASISWA": "Beasiswa PPA", "KETERANGAN": "Peningkatan Prestasi Akademik"}
  ];

  Future<List<Beasiswa>> getBeasiswa() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.mahasiswaBaseUrl}/beasiswa"),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final list = json['data'] as List? ?? [];
        await LocalStorageCache.save('cache_beasiswa', list);
        return list.map((e) => Beasiswa.fromJson(e)).toList();
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_beasiswa');
    if (cached != null) {
      return (cached as List).map((e) => Beasiswa.fromJson(e)).toList();
    }
    await LocalStorageCache.save('cache_beasiswa', _dummyBeasiswa);
    return _dummyBeasiswa.map((e) => Beasiswa.fromJson(e)).toList();
  }

  Future<bool> tambahBeasiswa({
    required String namaBeasiswa,
    required String keterangan,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.mahasiswaBaseUrl}/beasiswa"),
        headers: await _headers(),
        body: jsonEncode({
          "nama_beasiswa": namaBeasiswa,
          "keterangan": keterangan,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_beasiswa') ?? _dummyBeasiswa;
      final List list = List.from(cachedRaw);
      final lastItem = list.isEmpty ? null : list.last;
      final lastId = lastItem == null ? 0 : (lastItem['ID_BEASISWA'] ?? lastItem['id_beasiswa'] ?? 0);
      final newId = (int.tryParse(lastId.toString()) ?? 0) + 1;
      list.add({
        "ID_BEASISWA": newId,
        "NAMA_BEASISWA": namaBeasiswa,
        "KETERANGAN": keterangan
      });
      await LocalStorageCache.save('cache_beasiswa', list);
      return true;
    } catch (_) {}

    return false;
  }

  Future<bool> updateBeasiswa({
    required int id,
    required String namaBeasiswa,
    required String keterangan,
  }) async {
    try {
      final response = await http.put(
        Uri.parse("${ApiConstants.mahasiswaBaseUrl}/beasiswa/$id"),
        headers: await _headers(),
        body: jsonEncode({
          "nama_beasiswa": namaBeasiswa,
          "keterangan": keterangan,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_beasiswa') ?? _dummyBeasiswa;
      final List list = List.from(cachedRaw);
      final index = list.indexWhere((e) => (e['ID_BEASISWA'] ?? e['id_beasiswa']).toString() == id.toString());
      if (index != -1) {
        list[index]['NAMA_BEASISWA'] = namaBeasiswa;
        list[index]['nama_beasiswa'] = namaBeasiswa;
        list[index]['KETERANGAN'] = keterangan;
        list[index]['keterangan'] = keterangan;
        await LocalStorageCache.save('cache_beasiswa', list);
        return true;
      }
    } catch (_) {}

    return false;
  }

  Future<bool> deleteBeasiswa(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("${ApiConstants.mahasiswaBaseUrl}/beasiswa/$id"),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_beasiswa') ?? _dummyBeasiswa;
      final List list = List.from(cachedRaw);
      list.removeWhere((e) => (e['ID_BEASISWA'] ?? e['id_beasiswa']).toString() == id.toString());
      await LocalStorageCache.save('cache_beasiswa', list);
      return true;
    } catch (_) {}

    return false;
  }
}