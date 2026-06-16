class TahunAkademik {
  final int id;
  final String nama;
  final String aktif;

  TahunAkademik({
    required this.id,
    required this.nama,
    required this.aktif,
  });

  factory TahunAkademik.fromJson(
    Map<String, dynamic> json,
  ) {
    return TahunAkademik(
      id:
          json['id_tahun_akademik'] ?? json['ID_TAHUN_AKADEMIK'] ?? 0,
      nama:
          json['nama_tahun_akademik'] ?? json['NAMA_TAHUN_AKADEMIK'] ?? json['TAHUN_AKADEMIK'] ?? '',
      aktif:
          json['aktif'] ?? json['AKTIF'] ?? '',
    );
  }
}