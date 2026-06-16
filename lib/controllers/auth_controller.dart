import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthController {
  /// LOGIN
  Future<bool> login(
    String email,
    String password,
  ) async {
    try {
      final result = await AuthService.login(
        email: email,
        password: password,
      );

      if (result["success"] != true) {
        debugPrint(result["message"]);
        return false;
      }

      final data = result["data"];

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        'access_token',
        data['access_token'] ?? '',
      );

      await prefs.setString(
        'refresh_token',
        data['refresh_token'] ?? '',
      );

      await prefs.setString(
        'token_type',
        data['token_type'] ?? 'Bearer',
      );

      if (data['user'] != null) {
        await prefs.setInt(
          'user_id',
          data['user']['id'] ?? 0,
        );

        await prefs.setString(
          'name',
          data['user']['name'] ?? '',
        );

        await prefs.setString(
          'email',
          data['user']['email'] ?? '',
        );
      }

      debugPrint("Login berhasil");

      return true;
    } catch (e) {
      debugPrint("Login Error: $e");
      return false;
    }
  }

  /// REFRESH TOKEN
  Future<bool> refreshAccessToken() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      final refreshToken =
          prefs.getString('refresh_token');

      if (refreshToken == null ||
          refreshToken.isEmpty) {
        return false;
      }

      final result =
          await AuthService.refreshToken(
        refreshToken,
      );

      if (result["success"] != true) {
        return false;
      }

      final data = result["data"];

      await prefs.setString(
        'access_token',
        data['access_token'] ?? '',
      );

      await prefs.setString(
        'refresh_token',
        data['refresh_token'] ?? '',
      );

      return true;
    } catch (e) {
      debugPrint(
        "Refresh Token Error: $e",
      );
      return false;
    }
  }

  /// LOGOUT
  Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();
  }

  /// ACCESS TOKEN
  Future<String?> getToken() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      'access_token',
    );
  }

  /// REFRESH TOKEN
  Future<String?> getRefreshToken() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      'refresh_token',
    );
  }

  /// USER ID
  Future<int?> getUserId() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getInt(
      'user_id',
    );
  }

  /// NAMA USER
  Future<String?> getName() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      'name',
    );
  }

  /// EMAIL USER
  Future<String?> getEmail() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      'email',
    );
  }

  /// STATUS LOGIN
  Future<bool> isLoggedIn() async {
    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString(
      'access_token',
    );

    return token != null &&
        token.isNotEmpty;
  }
}