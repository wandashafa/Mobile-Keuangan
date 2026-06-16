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
          json['ID_BEASISWA'] ?? json['id_beasiswa'] ?? 0,
      namaBeasiswa:
          json['NAMA_BEASISWA'] ?? json['nama_beasiswa'] ?? '',
      keterangan:
          json['KETERANGAN'] ?? json['keterangan'] ?? '',
    );
  }
}