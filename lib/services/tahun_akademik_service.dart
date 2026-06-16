import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/utils/local_storage_cache.dart';

class TahunAkademikService {

  static final List _dummyTahun = [
    {"id_tahun_akademik": 1, "nama_tahun_akademik": "2024/2025 Ganjil"},
    {"id_tahun_akademik": 2, "nama_tahun_akademik": "2024/2025 Genap"}
  ];

  Future<List<dynamic>> getTahunAkademik() async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ApiConstants.mahasiswaBaseUrl}/tahun-akademik",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data["data"] ?? [];
        await LocalStorageCache.save('cache_tahun_akademik_list', list);
        return list;
      }
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_tahun_akademik_list');
    if (cached != null) return cached;
    await LocalStorageCache.save('cache_tahun_akademik_list', _dummyTahun);
    return _dummyTahun;
  }
}