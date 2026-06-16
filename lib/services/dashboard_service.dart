import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/utils/local_storage_cache.dart';

class DashboardService {
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final mahasiswaRes = await http.get(
        Uri.parse(
          '${ApiConstants.mahasiswaBaseUrl}/mahasiswa',
        ),
      );

      final tagihanRes = await http.get(
        Uri.parse(
          '${ApiConstants.mahasiswaBaseUrl}/tagihan',
        ),
      );

      final pembayaranRes = await http.get(
        Uri.parse(
          '${ApiConstants.mahasiswaBaseUrl}/pembayaran',
        ),
      );

      final beasiswaRes = await http.get(
        Uri.parse(
          '${ApiConstants.mahasiswaBaseUrl}/beasiswa',
        ),
      );

      final tahunRes = await http.get(
        Uri.parse(
          '${ApiConstants.mahasiswaBaseUrl}/tahun-akademik',
        ),
      );

      final mahasiswaData =
          jsonDecode(mahasiswaRes.body);

      final tagihanData =
          jsonDecode(tagihanRes.body);

      final pembayaranData =
          jsonDecode(pembayaranRes.body);

      final beasiswaData =
          jsonDecode(beasiswaRes.body);

      final tahunData =
          jsonDecode(tahunRes.body);

      final result = {
        "mahasiswa":
            mahasiswaData["data"] ?? [],
        "tagihan":
            tagihanData["data"] ?? [],
        "pembayaran":
            pembayaranData["data"] ?? [],
        "beasiswa":
            beasiswaData["data"] ?? [],
        "tahun":
            tahunData["data"] ?? [],
      };

      await LocalStorageCache.save('cache_dashboard_data', result);
      return result;
    } catch (_) {}

    final cached = await LocalStorageCache.get('cache_dashboard_data');
    if (cached != null) {
      return Map<String, dynamic>.from(cached);
    }

    return {
      "mahasiswa": [],
      "tagihan": [],
      "pembayaran": [],
      "beasiswa": [],
      "tahun": [],
    };
  }
}