import 'dart:convert';
import 'package:http/http.dart' as http;

class MahasiswaBeasiswaService {

  static const String baseUrl =
      'http://127.0.0.1:8000';

  Future<List<dynamic>> getData() async {

    final response = await http.get(
      Uri.parse(
        "$baseUrl/mahasiswa-beasiswa",
      ),
    );

    final data =
        jsonDecode(response.body);

    return data["data"];
  }

  Future<bool> createData(
    int idBeasiswa,
    String nim,
    int idTahunAkademik,
    String nominalPotongan,
  ) async {

    final response = await http.post(
      Uri.parse(
        "$baseUrl/mahasiswa-beasiswa",
      ),
      headers: {
        "Content-Type":
            "application/json",
      },
      body: jsonEncode({
        "id_beasiswa":
            idBeasiswa,
        "nim": nim,
        "id_tahun_akademik":
            idTahunAkademik,
        "nominal_potongan":
            nominalPotongan,
      }),
    );

    return response.statusCode == 200 ||
        response.statusCode == 201;
  }

  Future<bool> updateData(
    int idMb,
    String nominalPotongan,
  ) async {

    final response = await http.put(
      Uri.parse(
        "$baseUrl/mahasiswa-beasiswa/$idMb",
      ),
      headers: {
        "Content-Type":
            "application/json",
      },
      body: jsonEncode({
        "nominal_potongan":
            nominalPotongan,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteData(
      int idMb) async {

    final response = await http.delete(
      Uri.parse(
        "$baseUrl/mahasiswa-beasiswa/$idMb",
      ),
    );

    return response.statusCode == 200;
  }
}