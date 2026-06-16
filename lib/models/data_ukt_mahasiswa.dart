class DataUktMahasiswa {
  final int idTagihan;
  final String nim;
  final String nama;
  final String prodi;
  final int idTahunAkademik;
  final String kategoriUkt;
  final double totalTagihan;
  final String statusTagihan;

  DataUktMahasiswa({
    required this.idTagihan,
    required this.nim,
    required this.nama,
    required this.prodi,
    required this.idTahunAkademik,
    required this.kategoriUkt,
    required this.totalTagihan,
    required this.statusTagihan,
  });
}