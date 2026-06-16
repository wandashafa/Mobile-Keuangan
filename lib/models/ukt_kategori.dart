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
      idUktKategori: int.tryParse((json['ID_UKT_KATEGORI'] ?? json['id_ukt_kategori']).toString()) ?? 0,
      idJurusan: int.tryParse((json['ID_JURUSAN'] ?? json['id_jurusan']).toString()) ?? 0,
      idTahunAkademik: int.tryParse((json['ID_TAHUN_AKADEMIK'] ?? json['id_tahun_akademik']).toString()) ?? 0,
      namaKategori:
          json['NAMA_KATEGORI'] ?? json['nama_kategori'] ?? '',
      nominal: double.tryParse((json['NOMINAL'] ?? json['nominal']).toString()) ?? 0.0,
    );
  }
}