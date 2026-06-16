import 'dart:convert';
import 'package:http/http.dart' as http;

class MahasiswaController {
  static const String baseUrl =
      'https://keuangan4c06.vps-poliban.my.id/api';

  Future<Map<String, dynamic>> getMahasiswa(
      String nim) async {
    final response = await http.get(
      Uri.parse('$baseUrl/mahasiswa/$nim'),
    );

    final json = jsonDecode(response.body);

    return json['data'];
  }

  Future<List<dynamic>> getAllMahasiswa() async {
  final response = await http.get(
    Uri.parse('$baseUrl/mahasiswa'),
  );

  final json = jsonDecode(response.body);

  return json['data']['data'];
}
}