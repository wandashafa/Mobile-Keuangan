import '../services/prodi_service.dart';

class ProdiController {

  final ProdiService service =
      ProdiService();

  Future<List<dynamic>> getProdi() async {

    return await service.getProdi();
  }
}