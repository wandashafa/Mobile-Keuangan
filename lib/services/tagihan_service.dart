import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/token_storage.dart';

class TagihanService {
  static const String baseUrl =
      'http://127.0.0.1:8000';

  Future<List<dynamic>> getTagihan() async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse("$baseUrl/tagihan"),
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
      getDetailTagihan(
    int id,
  ) async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.get(
      Uri.parse(
        "$baseUrl/tagihan/$id",
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

  Future<bool> createTagihan({
    required String nim,
    required String idTahunAkademik,
    required int idUktKategori,
    required int idStatusTagihan,
    int? idMb,
    required String jatuhTempo,
  }) async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.post(
      Uri.parse("$baseUrl/tagihan"),
      headers: {
        "Accept": "application/json",
        "Content-Type":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
      body: jsonEncode({
        "nim": nim,
        "id_tahun_akademik":
            idTahunAkademik,
        "id_ukt_kategori":
            idUktKategori,
        "id_status_tagihan":
            idStatusTagihan,
        "id_mb": idMb,
        "jatuh_tempo":
            jatuhTempo,
      }),
    );

    return response.statusCode ==
            200 ||
        response.statusCode == 201;
  }

  Future<bool> updateTagihan({
    required int idTagihan,
    required int idStatusTagihan,
    required double totalTagihan,
    required String jatuhTempo,
  }) async {
    final token =
        await TokenStorage.getAccessToken();

    final response = await http.put(
      Uri.parse(
        "$baseUrl/tagihan/$idTagihan",
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
      body: jsonEncode({
        "id_status_tagihan":
            idStatusTagihan,
        "total_tagihan":
            totalTagihan,
        "jatuh_tempo":
            jatuhTempo,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteTagihan(
    int id,
  ) async {
    final token =
        await TokenStorage.getAccessToken();

    final response =
        await http.delete(
      Uri.parse(
        "$baseUrl/tagihan/$id",
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