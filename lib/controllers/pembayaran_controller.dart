import '../models/pembayaran.dart';
import '../services/pembayaran_service.dart';

class PembayaranController {
  final PembayaranService service =
      PembayaranService();

  Future<List<Pembayaran>>
      getPembayaran() async {
    final result =
        await service.getPembayaran();

    return result
        .map<Pembayaran>(
          (e) =>
              Pembayaran.fromJson(e),
        )
        .toList();
  }

  Future<Pembayaran>
      getDetailPembayaran(
    int id,
  ) async {
    final result =
        await service
            .getDetailPembayaran(
      id,
    );

    return Pembayaran.fromJson(
      result,
    );
  }

  Future<bool> createPembayaran({
    required int idTagihan,
    required int idMetode,
    required double jumlahBayar,
    required String tanggalBayar,
    required int cicilanKe,
  }) async {
    return await service
        .createPembayaran(
      idTagihan: idTagihan,
      idMetode: idMetode,
      jumlahBayar: jumlahBayar,
      tanggalBayar:
          tanggalBayar,
      cicilanKe: cicilanKe,
    );
  }

  Future<bool> updatePembayaran({
    required int idPembayaran,
    required double jumlahBayar,
    required int idMetode,
  }) async {
    return await service
        .updatePembayaran(
      idPembayaran:
          idPembayaran,
      jumlahBayar:
          jumlahBayar,
      idMetode:
          idMetode,
    );
  }

  Future<bool> deletePembayaran(
    int id,
  ) async {
    return await service
        .deletePembayaran(id);
  }
}