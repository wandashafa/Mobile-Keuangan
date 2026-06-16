import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';

class DashboardService {
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final mahasiswaRes = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/mahasiswa',
        ),
      );

      final tagihanRes = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/tagihan',
        ),
      );

      final pembayaranRes = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/pembayaran',
        ),
      );

      final beasiswaRes = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/beasiswa',
        ),
      );

      final tahunRes = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/tahun-akademik',
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

      return {
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
    } catch (e) {
      throw Exception(
        'Gagal memuat dashboard: $e',
      );
    }
  }
}