import 'dart:convert';
import 'package:http/http.dart'
    as http;

import 'token_storage.dart';

class MetodeService {
  static const String baseUrl =
      'http://127.0.0.1:8000';

  Future<List<dynamic>>
      getMetode() async {
    final token =
        await TokenStorage
            .getAccessToken();

    final response =
        await http.get(
      Uri.parse(
        "$baseUrl/metode",
      ),
      headers: {
        "Accept":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
    );

    final data =
        jsonDecode(response.body);

    return data["data"];
  }
}