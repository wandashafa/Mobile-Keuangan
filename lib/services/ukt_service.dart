import 'dart:convert';
import 'package:http/http.dart' as http;

import 'token_storage.dart';

class UktService {
  static const String baseUrl =
      'http://127.0.0.1:8000';

  Future<Map<String, String>> _headers() async {
    final token =
        await TokenStorage.getAccessToken();

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  Future<List<dynamic>> getUktKategori() async {
    final response = await http.get(
      Uri.parse("$baseUrl/ukt-kategori"),
      headers: await _headers(),
    );

    final data =
        jsonDecode(response.body);

    return data["data"] ?? [];
  }

  Future<bool> createUkt(
    int tahunAkademik,
    String kategori,
    String nominal,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/ukt-kategori"),
      headers: await _headers(),
      body: jsonEncode({
        "id_tahun_akademik":
            tahunAkademik,
        "nama_kategori":
            kategori,
        "nominal":
            nominal,
      }),
    );

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  Future<bool> updateUkt(
    int id,
    String kategori,
    String nominal,
  ) async {
    final response = await http.put(
      Uri.parse(
        "$baseUrl/ukt-kategori/$id",
      ),
      headers: await _headers(),
      body: jsonEncode({
        "nama_kategori":
            kategori,
        "nominal":
            nominal,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteUkt(
    int id,
  ) async {
    final response = await http.delete(
      Uri.parse(
        "$baseUrl/ukt-kategori/$id",
      ),
      headers: await _headers(),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>>
      getUktByNim(
    String nim,
  ) async {
    final response = await http.get(
      Uri.parse(
        "$baseUrl/ext/ukt-kategori/$nim",
      ),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final data =
          jsonDecode(response.body);

      return data["data"];
    }

    throw Exception(
      "Gagal mengambil data UKT mahasiswa",
    );
  }
}