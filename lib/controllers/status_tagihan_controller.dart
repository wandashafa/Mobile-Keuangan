import '../models/status_tagihan.dart';
import '../services/status_tagihan_service.dart';

class StatusTagihanController {
  final StatusTagihanService
      service =
          StatusTagihanService();

  Future<List<StatusTagihan>>
      getStatusTagihan() async {
    final result =
        await service
            .getStatusTagihan();

    return result
        .map<StatusTagihan>(
          (e) =>
              StatusTagihan.fromJson(
            e,
          ),
        )
        .toList();
  }

  Future<bool> createStatus(
    String namaStatus,
  ) async {
    return await service
        .createStatus(
      namaStatus,
    );
  }

  Future<bool> updateStatus({
    required int id,
    required String namaStatus,
  }) async {
    return await service
        .updateStatus(
      id: id,
      namaStatus: namaStatus,
    );
  }

  Future<bool> deleteStatus(
    int id,
  ) async {
    return await service
        .deleteStatus(id);
  }
}