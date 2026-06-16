import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/beasiswa.dart';

class BeasiswaController {
  static const String baseUrl =
    "https://keuangan4c06.vps-poliban.my.id/api";

  Future<List<Beasiswa>> getBeasiswa() async {
    final response = await http.get(
      Uri.parse("$baseUrl/beasiswa"),
    );

    final json = jsonDecode(response.body);

    return (json['data'] as List)
        .map((e) => Beasiswa.fromJson(e))
        .toList();
  }

  Future<bool> tambahBeasiswa({
    required String namaBeasiswa,
    required String keterangan,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/beasiswa"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "nama_beasiswa": namaBeasiswa,
        "keterangan": keterangan,
      }),
    );

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  Future<bool> updateBeasiswa({
    required int id,
    required String namaBeasiswa,
    required String keterangan,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/beasiswa/$id"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "nama_beasiswa": namaBeasiswa,
        "keterangan": keterangan,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteBeasiswa(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/beasiswa/$id"),
    );

    return response.statusCode == 200;
  }
}