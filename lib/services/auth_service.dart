import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';

class AuthService {

  /// LOGIN
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": data,
        };
      }

      return {
        "success": false,
        "message": data["message"] ?? "Login gagal",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Tidak dapat terhubung ke server autentikasi.",
      };
    }
  }

  /// REFRESH TOKEN
  static Future<Map<String, dynamic>> refreshToken(
      String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.adminBaseUrl}/auth/refresh"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "refresh_token": refreshToken,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "data": data,
        };
      }

      return {
        "success": false,
        "message":
            data["message"] ?? "Refresh token tidak valid atau kadaluarsa.",
      };
    } catch (e) {
      return {
        "success": false,
        "message": "Gagal menghubungi server.",
      };
    }
  }
}