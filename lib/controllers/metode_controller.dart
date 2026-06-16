import '../models/metode.dart';
import '../services/metode_service.dart';

class MetodeController {
  final service =
      MetodeService();

  Future<List<Metode>>
      getMetode() async {
    final result =
        await service.getMetode();

    return result
        .map<Metode>(
          (e) =>
              Metode.fromJson(
            e,
          ),
        )
        .toList();
  }
}