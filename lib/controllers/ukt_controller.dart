import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/ukt_kategori.dart';
import '../services/token_storage.dart';

class UktController {
  static const String baseUrl =
      'https://keuangan4c06.vps-poliban.my.id/api';

  /// GET
  Future<List<UktKategori>> getKategori() async {
    
    final token =
    await TokenStorage.getAccessToken();

final response = await http.get(
  Uri.parse('$baseUrl/ukt-kategori'),
  headers: {
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  },
);


    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      List data = jsonData['data'];

      return data
          .map((e) => UktKategori.fromJson(e))
          .toList();
    } else {
      throw Exception('Gagal mengambil data UKT');
    }
  }

  /// POST
  Future<bool> tambahKategori({
    required int idJurusan,
    required int idTahunAkademik,
    required String namaKategori,
    required int nominal,
  }) async {
    final token =
    await TokenStorage.getAccessToken();

final response = await http.post(
  Uri.parse('$baseUrl/ukt-kategori'),
  headers: {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  },
      body: jsonEncode({
        "id_jurusan": idJurusan,
        "id_tahun_akademik": idTahunAkademik,
        "nama_kategori": namaKategori,
        "nominal": nominal,
      }),
    );

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  /// PUT
  Future<bool> updateKategori({
    required int id,
    required String namaKategori,
    required int nominal,
  }) async {
    final token =
    await TokenStorage.getAccessToken();

final response = await http.put(
  Uri.parse('$baseUrl/ukt-kategori/$id'),
  headers: {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  },
      body: jsonEncode({
        "nama_kategori": namaKategori,
        "nominal": nominal,
      }),
    );

    return response.statusCode == 200;
  }

  /// DELETE
  Future<bool> deleteKategori(int id) async {
    final token =
    await TokenStorage.getAccessToken();

final response = await http.delete(
  Uri.parse('$baseUrl/ukt-kategori/$id'),
  headers: {
    "Accept": "application/json",
    "Authorization": "Bearer $token",
  },
);
    return response.statusCode == 200;
  }
}