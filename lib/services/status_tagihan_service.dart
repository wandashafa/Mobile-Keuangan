import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/token_storage.dart';

class StatusTagihanService {
  static const String baseUrl =
      'http://127.0.0.1:8000';

  Future<List<dynamic>>
      getStatusTagihan() async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse(
        "$baseUrl/status-tagihan",
      ),
      headers: {
        "Accept": "application/json",
        "Authorization":
            "Bearer $token",
      },
    );

    final json =
        jsonDecode(response.body);

    return json["data"];
  }

  Future<Map<String, dynamic>>
      getDetailStatus(
    int id,
  ) async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse(
        "$baseUrl/status-tagihan/$id",
      ),
      headers: {
        "Accept": "application/json",
        "Authorization":
            "Bearer $token",
      },
    );

    final json =
        jsonDecode(response.body);

    return json["data"];
  }

  Future<bool> createStatus(
    String namaStatus,
  ) async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.post(
      Uri.parse(
        "$baseUrl/status-tagihan",
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
      body: jsonEncode({
        "nama_status_tagihan":
            namaStatus,
      }),
    );

    return response.statusCode ==
            200 ||
        response.statusCode == 201;
  }

  Future<bool> updateStatus({
    required int id,
    required String namaStatus,
  }) async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.put(
      Uri.parse(
        "$baseUrl/status-tagihan/$id",
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
      body: jsonEncode({
        "nama_status_tagihan":
            namaStatus,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteStatus(
    int id,
  ) async {
    final token =
        await TokenStorage.getAccessToken();

    final response =
        await http.delete(
      Uri.parse(
        "$baseUrl/status-tagihan/$id",
      ),
      headers: {
        "Accept": "application/json",
        "Authorization":
            "Bearer $token",
      },
    );

    return response.statusCode == 200;
  }
}