import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import 'token_storage.dart';
import '../core/utils/local_storage_cache.dart';

class MahasiswaBeasiswaService {
  Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.getAccessToken();
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static final List _dummyMahasiswaBeasiswa = [
    {
      "id_mb": 1,
      "id_beasiswa": 1,
      "nim": "A0313001",
      "id_tahun_akademik": 2,
      "nominal_potongan": "1500000",
      "mahasiswa": {"nama": "Wanda Shafa", "nim": "A0313001"},
      "beasiswa": {"nama_beasiswa": "KIP Kuliah"}
    },
    {
      "id_mb": 2,
      "id_beasiswa": 2,
      "nim": "A0313002",
      "id_tahun_akademik": 2,
      "nominal_potongan": "2000000",
      "mahasiswa": {"nama": "Darrell", "nim": "A0313002"},
      "beasiswa": {"nama_beasiswa": "Beasiswa Prestasi"}
    },
    {
      "id_mb": 3,
      "id_beasiswa": 3,
      "nim": "A0313003",
      "id_tahun_akademik": 2,
      "nominal_potongan": "1000000",
      "mahasiswa": {"nama": "Budi Santoso", "nim": "A0313003"},
      "beasiswa": {"nama_beasiswa": "Beasiswa Perusahaan"}
    }
  ];

  Future<List<dynamic>> getData() async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/mahasiswa-beasiswa",
        ),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data["data"] ?? [];
        await LocalStorageCache.save('cache_mahasiswa_beasiswa', list);
        return list;
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_mahasiswa_beasiswa');
    if (cached != null) return cached;
    await LocalStorageCache.save('cache_mahasiswa_beasiswa', _dummyMahasiswaBeasiswa);
    return _dummyMahasiswaBeasiswa;
  }

  Future<bool> createData(
    int idBeasiswa,
    String nim,
    int idTahunAkademik,
    String nominalPotongan,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/mahasiswa-beasiswa",
        ),
        headers: await _headers(),
        body: jsonEncode({
          "id_beasiswa":
              idBeasiswa,
          "nim": nim,
          "id_tahun_akademik":
              idTahunAkademik,
          "nominal_potongan":
              nominalPotongan,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_mahasiswa_beasiswa') ?? _dummyMahasiswaBeasiswa;
      final List<Map<String, dynamic>> list = (cachedRaw is List)
          ? cachedRaw.map((e) => Map<String, dynamic>.from(e)).toList()
          : _dummyMahasiswaBeasiswa.map((e) => Map<String, dynamic>.from(e)).toList();
      final newId = list.isEmpty ? 1 : (int.parse((list.last['id_mb'] ?? list.last['ID_MB'] ?? 0).toString()) + 1);
      
      // Try to find mahasiswa name & beasiswa name for offline display
      String mhsName = nim;
      try {
        final mhsList = await LocalStorageCache.get('cache_all_mahasiswa') ?? [];
        final foundMhs = mhsList.firstWhere((e) => (e['nim'] ?? e['NIM'] ?? '').toString() == nim, orElse: () => null);
        if (foundMhs != null) mhsName = foundMhs['nama'] ?? foundMhs['NAMA'] ?? nim;
      } catch (_) {}

      String bName = "Beasiswa";
      try {
        final bList = await LocalStorageCache.get('cache_beasiswa') ?? [];
        final foundB = bList.firstWhere((e) => (e['id_beasiswa'] ?? e['ID_BEASISWA'] ?? '').toString() == idBeasiswa.toString(), orElse: () => null);
        if (foundB != null) bName = foundB['nama_beasiswa'] ?? foundB['NAMA_BEASISWA'] ?? "Beasiswa";
      } catch (_) {}

      list.add({
        "id_mb": newId,
        "id_beasiswa": idBeasiswa,
        "nim": nim,
        "id_tahun_akademik": idTahunAkademik,
        "nominal_potongan": nominalPotongan,
        "mahasiswa": {"nama": mhsName, "nim": nim},
        "beasiswa": {"nama_beasiswa": bName}
      });
      await LocalStorageCache.save('cache_mahasiswa_beasiswa', list);
      return true;
    } catch (_) {}

    return false;
  }

  Future<bool> updateData(
    int idMb,
    String nominalPotongan,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/mahasiswa-beasiswa/$idMb",
        ),
        headers: await _headers(),
        body: jsonEncode({
          "nominal_potongan":
              nominalPotongan,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_mahasiswa_beasiswa') ?? _dummyMahasiswaBeasiswa;
      final List<Map<String, dynamic>> list = (cachedRaw is List)
          ? cachedRaw.map((e) => Map<String, dynamic>.from(e)).toList()
          : _dummyMahasiswaBeasiswa.map((e) => Map<String, dynamic>.from(e)).toList();
      final index = list.indexWhere((e) => (e['id_mb'] ?? e['ID_MB'] ?? '').toString() == idMb.toString());
      if (index != -1) {
        list[index]['nominal_potongan'] = nominalPotongan;
        await LocalStorageCache.save('cache_mahasiswa_beasiswa', list);
        return true;
      }
    } catch (_) {}

    return false;
  }

  Future<bool> deleteData(
      int idMb) async {
    try {
      final response = await http.delete(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/mahasiswa-beasiswa/$idMb",
        ),
        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (_) {}

    try {
      final cachedRaw = await LocalStorageCache.get('cache_mahasiswa_beasiswa') ?? _dummyMahasiswaBeasiswa;
      final List<Map<String, dynamic>> list = (cachedRaw is List)
          ? cachedRaw.map((e) => Map<String, dynamic>.from(e)).toList()
          : _dummyMahasiswaBeasiswa.map((e) => Map<String, dynamic>.from(e)).toList();
      list.removeWhere((e) => (e['id_mb'] ?? e['ID_MB'] ?? '').toString() == idMb.toString());
      await LocalStorageCache.save('cache_mahasiswa_beasiswa', list);
      return true;
    } catch (_) {}

    return false;
  }
}