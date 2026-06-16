import 'dart:convert';
import 'package:http/http.dart' as http;

class TahunAkademikService {

  static const String baseUrl =
      'http://127.0.0.1:8000';

  Future<List<dynamic>>
      getTahunAkademik() async {

    final response = await http.get(
      Uri.parse(
        "$baseUrl/tahun-akademik",
      ),
    );

    final data =
        jsonDecode(response.body);

    return data["data"];
  }
}