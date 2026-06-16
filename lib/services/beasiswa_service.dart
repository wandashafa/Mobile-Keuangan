import 'dart:convert';
import 'package:http/http.dart' as http;

class BeasiswaService {

  static const String baseUrl =
    'http://127.0.0.1:8000';
      
      Future<List<dynamic>>
      getBeasiswa() async {

    final response =
        await http.get(
      Uri.parse(
        "$baseUrl/beasiswa",
      ),
    );

    final data =
        jsonDecode(response.body);

    return data["data"];
  }

  Future<bool> createBeasiswa(
    String nama,
    String keterangan,
  ) async {

    final response =
        await http.post(
      Uri.parse(
        "$baseUrl/beasiswa",
      ),
      headers: {
        "Content-Type":
            "application/json",
      },
      body: jsonEncode({
        "nama_beasiswa":
            nama,
        "keterangan":
            keterangan,
      }),
    );

    return response.statusCode ==
            200 ||
        response.statusCode == 201;
  }

  Future<bool> updateBeasiswa(
    int id,
    String nama,
    String keterangan,
  ) async {

    final response =
        await http.put(
      Uri.parse(
        "$baseUrl/beasiswa/$id",
      ),
      headers: {
        "Content-Type":
            "application/json",
      },
      body: jsonEncode({
        "nama_beasiswa":
            nama,
        "keterangan":
            keterangan,
      }),
    );

    return response.statusCode ==
        200;
  }

  Future<bool> deleteBeasiswa(
    int id,
  ) async {

    final response =
        await http.delete(
      Uri.parse(
        "$baseUrl/beasiswa/$id",
      ),
    );

    return response.statusCode ==
        200;
  }
}