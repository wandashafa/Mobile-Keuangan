import 'dart:convert';
import 'package:http/http.dart' as http;

import 'token_storage.dart';
import '../core/constants/api_constants.dart';
import '../core/utils/local_storage_cache.dart';

class UktService {

  Future<Map<String, String>> _headers() async {
    final token =
        await TokenStorage.getAccessToken();

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static final List _dummyKategori = [
    {"ID_UKT_KATEGORI": 1, "NAMA_KATEGORI": "Kategori I", "NOMINAL": 500000.0},
    {"ID_UKT_KATEGORI": 2, "NAMA_KATEGORI": "Kategori II", "NOMINAL": 1500000.0},
    {"ID_UKT_KATEGORI": 3, "NAMA_KATEGORI": "Kategori III", "NOMINAL": 2500000.0}
  ];

  Future<List<dynamic>> getUktKategori() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.mahasiswaBaseUrl}/ukt-kategori"),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data["data"] ?? [];
        await LocalStorageCache.save('cache_ukt_kategori', list);
        return list;
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_ukt_kategori');
    if (cached != null) return cached;
    await LocalStorageCache.save('cache_ukt_kategori', _dummyKategori);
    return _dummyKategori;
  }

  Future<bool> createUkt(
    int tahunAkademik,
    String kategori,
    String nominal,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.mahasiswaBaseUrl}/ukt-kategori"),
      headers: await _headers(),
      body: jsonEncode({
        "id_tahun_akademik":
            tahunAkademik,
        "nama_kategori":
            kategori,
        "nominal":
            nominal,
      }),
    );

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  Future<bool> updateUkt(
    int id,
    String kategori,
    String nominal,
  ) async {
    final response = await http.put(
      Uri.parse(
        "${ApiConstants.mahasiswaBaseUrl}/ukt-kategori/$id",
      ),
      headers: await _headers(),
      body: jsonEncode({
        "nama_kategori":
            kategori,
        "nominal":
            nominal,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteUkt(
    int id,
  ) async {
    final response = await http.delete(
      Uri.parse(
        "${ApiConstants.mahasiswaBaseUrl}/ukt-kategori/$id",
      ),
      headers: await _headers(),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>>
      getUktByNim(
    String nim,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/ext/ukt-kategori/$nim",
        ),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final map = data["data"] ?? {};
        await LocalStorageCache.save('cache_ukt_by_nim_$nim', map);
        return map;
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_ukt_by_nim_$nim');
    if (cached != null) {
      return cached;
    }

    throw Exception(
      "Gagal mengambil data UKT mahasiswa",
    );
  }
}