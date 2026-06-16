import 'dart:convert';
import 'package:http/http.dart' as http;

import 'token_storage.dart';

class PembayaranService {
  static const String baseUrl =
      'http://127.0.0.1:8000';

  // =========================
  // GET ALL PEMBAYARAN
  // =========================
  Future<List<dynamic>> getPembayaran() async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse("$baseUrl/pembayaran"),
      headers: {
        "Accept": "application/json",
        "Authorization":
            "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data =
          jsonDecode(response.body);

      return data["data"];
    }

    throw Exception(
      "Gagal mengambil data pembayaran",
    );
  }

  // =========================
  // DETAIL PEMBAYARAN
  // =========================
  Future<Map<String, dynamic>>
      getDetailPembayaran(
    int id,
  ) async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse(
        "$baseUrl/pembayaran/$id",
      ),
      headers: {
        "Accept": "application/json",
        "Authorization":
            "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data =
          jsonDecode(response.body);

      return data["data"];
    }

    throw Exception(
      "Pembayaran tidak ditemukan",
    );
  }

  // =========================
  // CREATE PEMBAYARAN
  // =========================
  Future<bool> createPembayaran({
    required int idTagihan,
    required int idMetode,
    required double jumlahBayar,
    required String tanggalBayar,
    required int cicilanKe,
  }) async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.post(
      Uri.parse("$baseUrl/pembayaran"),
      headers: {
        "Accept": "application/json",
        "Content-Type":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
      body: jsonEncode({
        "id_tagihan":
            idTagihan,
        "id_metode":
            idMetode,
        "jumlah_bayar":
            jumlahBayar,
        "tanggal_bayar":
            tanggalBayar,
        "cicilan_ke":
            cicilanKe,
      }),
    );

    return response.statusCode ==
            200 ||
        response.statusCode ==
            201;
  }

  // =========================
  // UPDATE PEMBAYARAN
  // =========================
  Future<bool> updatePembayaran({
    required int idPembayaran,
    required double jumlahBayar,
    required int idMetode,
  }) async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.put(
      Uri.parse(
        "$baseUrl/pembayaran/$idPembayaran",
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
      body: jsonEncode({
        "jumlah_bayar":
            jumlahBayar,
        "id_metode":
            idMetode,
      }),
    );

    return response.statusCode ==
        200;
  }

  // =========================
  // DELETE PEMBAYARAN
  // =========================
  Future<bool> deletePembayaran(
    int id,
  ) async {
    final token =
        await TokenStorage.getAccessToken();

    final response =
        await http.delete(
      Uri.parse(
        "$baseUrl/pembayaran/$id",
      ),
      headers: {
        "Accept":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
    );

    return response.statusCode ==
        200;
  }
}