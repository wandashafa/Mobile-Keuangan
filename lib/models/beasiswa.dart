class Beasiswa {
  final int idBeasiswa;
  final String namaBeasiswa;
  final String keterangan;

  Beasiswa({
    required this.idBeasiswa,
    required this.namaBeasiswa,
    required this.keterangan,
  });

  factory Beasiswa.fromJson(
    Map<String, dynamic> json,
  ) {
    return Beasiswa(
      idBeasiswa:
          json['ID_BEASISWA'] ?? 0,
      namaBeasiswa:
          json['NAMA_BEASISWA'] ?? '',
      keterangan:
          json['KETERANGAN'] ?? '',
    );
  }
}