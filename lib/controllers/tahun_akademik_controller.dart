import '../models/tahun_akademik.dart';
import '../services/tahun_akademik_service.dart';

class TahunAkademikController {

  final TahunAkademikService service =
      TahunAkademikService();

  Future<List<TahunAkademik>>
      getTahunAkademik() async {

    final result =
        await service.getTahunAkademik();

    return result
        .map<TahunAkademik>(
          (e) =>
              TahunAkademik.fromJson(e),
        )
        .toList();
  }
}