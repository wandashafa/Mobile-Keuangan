class UktKategori {
  final int idUktKategori;
  final int idJurusan;
  final int idTahunAkademik;
  final String namaKategori;
  final double nominal;

  UktKategori({
    required this.idUktKategori,
    required this.idJurusan,
    required this.idTahunAkademik,
    required this.namaKategori,
    required this.nominal,
  });

  factory UktKategori.fromJson(
  Map<String, dynamic> json,
) {
  return UktKategori(
    idUktKategori: int.parse(
      json['ID_UKT_KATEGORI']
          .toString(),
    ),
    idJurusan: int.parse(
      json['ID_JURUSAN']
          .toString(),
    ),
    idTahunAkademik: int.parse(
      json['ID_TAHUN_AKADEMIK']
          .toString(),
    ),
    namaKategori:
        json['NAMA_KATEGORI'] ?? '',
    nominal: double.parse(
      json['NOMINAL'].toString(),
    ),
  );
}
}