import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';


class DataUktService {
  static const String baseUrl =
    'http://127.0.0.1:8000';

  static Future<Map<String, String>>
      _headers() async {
    final token =
        await TokenStorage.getAccessToken();

    return {
  "Accept": "application/json",
  "Content-Type": "application/json",
  "Authorization": "Bearer $token",
};
  }

  static Future<List> getTahun() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/tahun-akademik',
      ),
      headers: await _headers(),
    );

    return jsonDecode(
      response.body,
    )["data"];
  }

  static Future<List> getProdi() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/prodi',
      ),
      headers: await _headers(),
    );

    return jsonDecode(
      response.body,
    )["data"];
  }

  static Future<List> getMahasiswa() async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/mahasiswa'),
    headers: await _headers(),
  );

  final data = jsonDecode(response.body);

  return data["data"]["data"];
}

  static Future<List> getTagihan()
      async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/tagihan',
      ),
      headers: await _headers(),
    );

    return jsonDecode(
      response.body,
    )["data"];
  }

  static Future<List>
      getKategoriUkt() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/ukt-kategori',
      ),
      headers: await _headers(),
    );

    return jsonDecode(
      response.body,
    )["data"];
  }

  static Future<List>
      getStatusTagihan() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/status-tagihan',
      ),
      headers: await _headers(),
    );

    return jsonDecode(
      response.body,
    )["data"];
  }

  static Future<List> getStatusMahasiswa() async {
  final response = await http.get(
    Uri.parse(
      '$baseUrl/api/status-mahasiswa',
    ),
    headers: await _headers(),
  );

  final data = jsonDecode(response.body);

  return data["data"]["data"];
}

static Future<Map<String, dynamic>>
    updateStatusMahasiswa({
  required String nim,
  required int idStatus,
}) async {
  final response = await http.put(
    Uri.parse(
      '$baseUrl/api/mahasiswa/$nim/status',
    ),
    headers: await _headers(),
    body: jsonEncode({
      "id_status_mhs": idStatus,
    }),
  );

  return jsonDecode(response.body);
}
}