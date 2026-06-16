import '../services/mahasiswa_beasiswa_service.dart';

class MahasiswaBeasiswaController {

  final MahasiswaBeasiswaService
      service =
          MahasiswaBeasiswaService();

  Future<List<dynamic>>
      getData() async {

    return await service.getData();
  }

  Future<bool> createData(
    int idBeasiswa,
    String nim,
    int idTahunAkademik,
    String nominalPotongan,
  ) async {

    return await service.createData(
      idBeasiswa,
      nim,
      idTahunAkademik,
      nominalPotongan,
    );
  }

  Future<bool> updateData(
    int idMb,
    String nominalPotongan,
  ) async {

    return await service.updateData(
      idMb,
      nominalPotongan,
    );
  }

  Future<bool> deleteData(
      int idMb) async {

    return await service.deleteData(
      idMb,
    );
  }
}