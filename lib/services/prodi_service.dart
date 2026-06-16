import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/utils/local_storage_cache.dart';

class ProdiService {

  Future<List<dynamic>> getProdi() async {
    try {
      final response = await http.get(
        Uri.parse("${ApiConstants.mahasiswaBaseUrl}/prodi"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data["data"] ?? [];
        await LocalStorageCache.save('cache_prodi_list', list);
        return list;
      }
    } catch (_) {}

    return await LocalStorageCache.get('cache_prodi_list') ?? [];
  }
}