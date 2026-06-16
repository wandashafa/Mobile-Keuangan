import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class PresensiService {
  static const String baseUrl =
      'http://127.0.0.1:8000';

  static Future<Map<String, dynamic>> absenMasuk() async {
    try {
      final token =
          await TokenStorage.getAccessToken();

      debugPrint("TOKEN PRESENSI = $token");

      final response = await http.post(
        Uri.parse("$baseUrl/api/absen/masuk"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> absenKeluar() async {
    try {
      final token =
          await TokenStorage.getAccessToken();

      final response = await http.post(
        Uri.parse("$baseUrl/api/absen/keluar"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }
}