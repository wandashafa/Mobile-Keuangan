import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/ukt_kategori.dart';
import '../services/token_storage.dart';
import '../core/constants/api_constants.dart';
import '../core/utils/local_storage_cache.dart';

class UktController {

  /// GET
  Future<List<UktKategori>> getKategori() async {
    try {
      final token = await TokenStorage.getAccessToken();

      final response = await http.get(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/ukt-kategori'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List data = jsonData['data'] ?? [];
        await LocalStorageCache.save('cache_controller_ukt_kategori', data);
        return data.map((e) => UktKategori.fromJson(e)).toList();
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_controller_ukt_kategori');
    if (cached != null) {
      return (cached as List).map((e) => UktKategori.fromJson(e)).toList();
    }
    return [];
  }

  /// POST
  Future<bool> tambahKategori({
    required int idJurusan,
    required int idTahunAkademik,
    required String namaKategori,
    required int nominal,
  }) async {
    final token = await TokenStorage.getAccessToken();

    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/ukt-kategori'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "id_jurusan": idJurusan,
          "id_tahun_akademik": idTahunAkademik,
          "nama_kategori": namaKategori,
          "nominal": nominal,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_controller_ukt_kategori') ?? [];
      final List list = List.from(cachedRaw);
      final newId = list.isEmpty ? 1 : (int.parse(list.last['ID_UKT_KATEGORI'].toString()) + 1);
      final newItem = {
        "ID_UKT_KATEGORI": newId,
        "ID_JURUSAN": idJurusan,
        "ID_TAHUN_AKADEMIK": idTahunAkademik,
        "NAMA_KATEGORI": namaKategori,
        "NOMINAL": nominal.toDouble()
      };
      list.add(newItem);
      await LocalStorageCache.save('cache_controller_ukt_kategori', list);
      await LocalStorageCache.save('cache_kategori_ukt', list);
      return true;
    } catch (_) {}

    return false;
  }

  /// PUT
  Future<bool> updateKategori({
    required int id,
    required String namaKategori,
    required int nominal,
  }) async {
    final token = await TokenStorage.getAccessToken();

    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/ukt-kategori/$id'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "nama_kategori": namaKategori,
          "nominal": nominal,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_controller_ukt_kategori') ?? [];
      final List list = List.from(cachedRaw);
      final index = list.indexWhere((e) => e['ID_UKT_KATEGORI'].toString() == id.toString());
      if (index != -1) {
        list[index]['NAMA_KATEGORI'] = namaKategori;
        list[index]['NOMINAL'] = nominal.toDouble();
        await LocalStorageCache.save('cache_controller_ukt_kategori', list);
        await LocalStorageCache.save('cache_kategori_ukt', list);
        return true;
      }
    } catch (_) {}

    return false;
  }

  /// DELETE
  Future<bool> deleteKategori(int id) async {
    final token = await TokenStorage.getAccessToken();

    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/ukt-kategori/$id'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_controller_ukt_kategori') ?? [];
      final List list = List.from(cachedRaw);
      list.removeWhere((e) => e['ID_UKT_KATEGORI'].toString() == id.toString());
      await LocalStorageCache.save('cache_controller_ukt_kategori', list);
      await LocalStorageCache.save('cache_kategori_ukt', list);
      return true;
    } catch (_) {}

    return false;
  }
}