import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/utils/local_storage_cache.dart';

class MahasiswaController {

  static final List _dummyMahasiswa = [
    {"NIM": "A0313001", "NAMA": "Wanda Shafa"},
    {"NIM": "A0313002", "NAMA": "Darrell"},
    {"NIM": "A0313003", "NAMA": "Budi Santoso"},
    {"NIM": "A0313004", "NAMA": "Siti Aminah"}
  ];

  Future<Map<String, dynamic>> getMahasiswa(
      String nim) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/mahasiswa/$nim'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'] ?? {};
        await LocalStorageCache.save('cache_mahasiswa_$nim', data);
        return data;
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_mahasiswa_$nim');
    if (cached != null) return cached;
    final found = _dummyMahasiswa.firstWhere((e) => e['NIM'] == nim, orElse: () => null);
    return found ?? {};
  }

  Future<List<dynamic>> getAllMahasiswa() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.mahasiswaBaseUrl}/mahasiswa'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final list = json['data']?['data'] ?? [];
        await LocalStorageCache.save('cache_all_mahasiswa', list);
        return list;
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_all_mahasiswa');
    if (cached != null) return cached;
    await LocalStorageCache.save('cache_all_mahasiswa', _dummyMahasiswa);
    return _dummyMahasiswa;
  }
}