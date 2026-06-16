import '../models/tagihan.dart';
import '../services/tagihan_service.dart';

class TagihanController {
  final TagihanService service =
      TagihanService();

  Future<List<Tagihan>>
      getTagihan() async {
    final result =
        await service.getTagihan();

    return result
        .map<Tagihan>(
          (e) => Tagihan.fromJson(e),
        )
        .toList();
  }

  Future<Tagihan?> getDetailTagihan(
    int id,
  ) async {
    final result =
        await service.getDetailTagihan(
      id,
    );

    return Tagihan.fromJson(result);
  }

  Future<bool> createTagihan({
    required String nim,
    required String idTahunAkademik,
    required int idUktKategori,
    required int idStatusTagihan,
    int? idMb,
    required String jatuhTempo,
  }) async {
    return await service.createTagihan(
      nim: nim,
      idTahunAkademik:
          idTahunAkademik,
      idUktKategori:
          idUktKategori,
      idStatusTagihan:
          idStatusTagihan,
      idMb: idMb,
      jatuhTempo:
          jatuhTempo,
    );
  }

  Future<bool> updateTagihan({
    required int idTagihan,
    required int idStatusTagihan,
    required double totalTagihan,
    required String jatuhTempo,
  }) async {
    return await service.updateTagihan(
      idTagihan:
          idTagihan,
      idStatusTagihan:
          idStatusTagihan,
      totalTagihan:
          totalTagihan,
      jatuhTempo:
          jatuhTempo,
    );
  }

  Future<bool> deleteTagihan(
    int id,
  ) async {
    return await service.deleteTagihan(
      id,
    );
  }
}