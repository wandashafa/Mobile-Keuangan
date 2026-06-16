import 'dart:convert';
import 'package:http/http.dart' as http;

class ProdiService {

  static const String baseUrl =
      'http://127.0.0.1:8000';

  Future<List<dynamic>> getProdi() async {

    final response = await http.get(
      Uri.parse("$baseUrl/prodi"),
    );

    final data =
        jsonDecode(response.body);

    return data["data"];
  }
}