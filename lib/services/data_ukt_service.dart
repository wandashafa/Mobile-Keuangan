import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';
import '../core/constants/api_constants.dart';
import '../core/utils/local_storage_cache.dart';

class DataUktService {

  static Future<Map<String, String>>
      _headers() async {
    final token =
        await TokenStorage.getAccessToken();

    return {
  "Accept": "application/json",
  "Content-Type": "application/json",
  "Authorization": "Bearer $token",
};
  }

  static final List _dummyTahun = [
    {"id_tahun_akademik": 1, "nama_tahun_akademik": "2024/2025 Ganjil"},
    {"id_tahun_akademik": 2, "nama_tahun_akademik": "2024/2025 Genap"}
  ];

  static final List _dummyProdi = [
    {"id_prodi": 1, "nama_prodi": "Teknik Informatika"},
    {"id_prodi": 2, "nama_prodi": "Teknik Sipil"},
    {"id_prodi": 3, "nama_prodi": "Akuntansi"}
  ];

  static final List _dummyMahasiswa = [
    {
      "nim": "A0313001",
      "nama": "Budi Santoso",
      "id_status_mhs": 1,
      "prodi": {"id_prodi": 1, "nama_prodi": "Teknik Informatika"},
      "jenis_kelamin": {"id_jk": 1, "nama_jk": "Laki-laki"}
    },
    {
      "nim": "A0313002",
      "nama": "Siti Aminah",
      "id_status_mhs": 1,
      "prodi": {"id_prodi": 2, "nama_prodi": "Teknik Sipil"},
      "jenis_kelamin": {"id_jk": 2, "nama_jk": "Perempuan"}
    }
  ];

  static final List _dummyTagihan = [
    {
      "NIM": "A0313001",
      "ukt_kategori": {
        "ID_UKT_KATEGORI": 1,
        "NAMA_KATEGORI": "Kategori I",
        "NOMINAL": 500000.0
      },
      "status_tagihan": {
        "ID_STATUS_TAGIHAN": 1,
        "NAMA_STATUS_TAGIHAN": "Lunas"
      }
    },
    {
      "NIM": "A0313002",
      "ukt_kategori": {
        "ID_UKT_KATEGORI": 2,
        "NAMA_KATEGORI": "Kategori II",
        "NOMINAL": 1500000.0
      },
      "status_tagihan": {
        "ID_STATUS_TAGIHAN": 2,
        "NAMA_STATUS_TAGIHAN": "Belum Bayar"
      }
    }
  ];

  static final List _dummyKategoriUkt = [
    {
      "ID_UKT_KATEGORI": 1,
      "ID_JURUSAN": 1,
      "ID_TAHUN_AKADEMIK": 2,
      "NAMA_KATEGORI": "Kategori I",
      "NOMINAL": 500000.0
    },
    {
      "ID_UKT_KATEGORI": 2,
      "ID_JURUSAN": 2,
      "ID_TAHUN_AKADEMIK": 2,
      "NAMA_KATEGORI": "Kategori II",
      "NOMINAL": 1500000.0
    }
  ];

  static final List _dummyStatusTagihan = [
    {"ID_STATUS_TAGIHAN": 1, "NAMA_STATUS_TAGIHAN": "Lunas"},
    {"ID_STATUS_TAGIHAN": 2, "NAMA_STATUS_TAGIHAN": "Belum Bayar"}
  ];

  static final List _dummyStatusMahasiswa = [
    {"ID_STATUS_MHS": 1, "NAMA_STATUS_MHS": "Aktif"},
    {"ID_STATUS_MHS": 2, "NAMA_STATUS_MHS": "Cuti"}
  ];

  static Future<List> getTahun() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/tahun-akademik'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"] ?? [];
        await LocalStorageCache.save('cache_tahun', data);
        return data;
      }
    } catch (_) {}
    final cached = await LocalStorageCache.get('cache_tahun');
    if (cached is List) return cached;
    await LocalStorageCache.save('cache_tahun', _dummyTahun);
    return _dummyTahun;
  }

  static Future<List> getProdi() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/prodi'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"] ?? [];
        await LocalStorageCache.save('cache_prodi', data);
        return data;
      }
    } catch (_) {}
    final cached = await LocalStorageCache.get('cache_prodi');
    if (cached is List) return cached;
    await LocalStorageCache.save('cache_prodi', _dummyProdi);
    return _dummyProdi;
  }

  static Future<List> getMahasiswa() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/mahasiswa'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data["data"]?["data"] ?? [];
        await LocalStorageCache.save('cache_mahasiswa', list);
        return list;
      }
    } catch (_) {}
    final cached = await LocalStorageCache.get('cache_mahasiswa');
    if (cached is List) return cached;
    await LocalStorageCache.save('cache_mahasiswa', _dummyMahasiswa);
    return _dummyMahasiswa;
  }

  static Future<List> getTagihan() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/tagihan'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"] ?? [];
        await LocalStorageCache.save('cache_tagihan', data);
        return data;
      }
    } catch (_) {}
    final cached = await LocalStorageCache.get('cache_tagihan');
    if (cached is List) return cached;
    await LocalStorageCache.save('cache_tagihan', _dummyTagihan);
    return _dummyTagihan;
  }

  static Future<List> getKategoriUkt() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/ukt-kategori'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"] ?? [];
        await LocalStorageCache.save('cache_kategori_ukt', data);
        return data;
      }
    } catch (_) {}
    final cached = await LocalStorageCache.get('cache_kategori_ukt');
    if (cached is List) return cached;
    await LocalStorageCache.save('cache_kategori_ukt', _dummyKategoriUkt);
    return _dummyKategoriUkt;
  }

  static Future<List> getStatusTagihan() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/status-tagihan'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"] ?? [];
        await LocalStorageCache.save('cache_status_tagihan', data);
        return data;
      }
    } catch (_) {}
    final cached = await LocalStorageCache.get('cache_status_tagihan');
    if (cached is List) return cached;
    await LocalStorageCache.save('cache_status_tagihan', _dummyStatusTagihan);
    return _dummyStatusTagihan;
  }

  static Future<List> getStatusMahasiswa() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/status-mahasiswa'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data["data"]?["data"] ?? [];
        await LocalStorageCache.save('cache_status_mahasiswa', list);
        return list;
      }
    } catch (_) {}
    final cached = await LocalStorageCache.get('cache_status_mahasiswa');
    if (cached is List) return cached;
    await LocalStorageCache.save('cache_status_mahasiswa', _dummyStatusMahasiswa);
    return _dummyStatusMahasiswa;
  }

  static Future<Map<String, dynamic>> updateStatusMahasiswa({
    required String nim,
    required int idStatus,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/mahasiswa/$nim/status'),
        headers: await _headers(),
        body: jsonEncode({"id_status_mhs": idStatus}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (_) {}

    try {
      final mhsList = List.from(await getMahasiswa());
      final idx = mhsList.indexWhere((e) => e['nim'] == nim);
      if (idx != -1) {
        mhsList[idx]['id_status_mhs'] = idStatus;
        await LocalStorageCache.save('cache_mahasiswa', mhsList);
      }
    } catch (_) {}
    return {"success": true, "message": "Berhasil memperbarui status (Offline Mode)"};
  }

  static Future<Map<String, dynamic>> updateUktMahasiswa({
    required String nim,
    required int idUktKategori,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/mahasiswa/$nim/ukt-kategori'),
        headers: await _headers(),
        body: jsonEncode({"id_ukt_kategori": idUktKategori}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (_) {}

    try {
      final tagihanList = List.from(await getTagihan());
      final index = tagihanList.indexWhere((e) => e['NIM'] == nim);
      if (index != -1) {
        final kategoriList = await getKategoriUkt();
        final cat = kategoriList.firstWhere(
          (c) => c['ID_UKT_KATEGORI'].toString() == idUktKategori.toString(),
          orElse: () => null,
        );
        if (cat != null) {
          tagihanList[index]['ukt_kategori'] = {
            "ID_UKT_KATEGORI": idUktKategori,
            "NAMA_KATEGORI": cat['NAMA_KATEGORI'],
            "NOMINAL": cat['NOMINAL']
          };
          await LocalStorageCache.save('cache_tagihan', tagihanList);
        }
      }
    } catch (_) {}
    return {"success": true, "message": "Berhasil memperbarui UKT (Offline Mode)"};
  }
}