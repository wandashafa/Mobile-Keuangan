class Tagihan {
  final int idTagihan;
  final String nim;
  final String idTahunAkademik;

  final int idStatusTagihan;
  final String namaStatus;

  final int idUktKategori;
  final String namaKategori;

  final double totalTagihan;
  final String jatuhTempo;

  Tagihan({
    required this.idTagihan,
    required this.nim,
    required this.idTahunAkademik,
    required this.idStatusTagihan,
    required this.namaStatus,
    required this.idUktKategori,
    required this.namaKategori,
    required this.totalTagihan,
    required this.jatuhTempo,
  });

  factory Tagihan.fromJson(
    Map<String, dynamic> json,
  ) {
    return Tagihan(
      idTagihan:
          json["ID_TAGIHAN"] ?? json["id_tagihan"] ?? 0,

      nim: json["NIM"] ?? json["nim"] ?? '',

      idTahunAkademik:
          json["ID_TAHUN_AKADEMIK"]
                  ?.toString() ??
              json["id_tahun_akademik"]
                  ?.toString() ??
              '',

      idStatusTagihan:
          json["ID_STATUS_TAGIHAN"] ?? json["id_status_tagihan"] ?? 0,

      namaStatus:
          json["status_tagihan"]
                  ?["NAMA_STATUS_TAGIHAN"] ??
              json["status_tagihan"]
                  ?["nama_status_tagihan"] ??
              json["nama_status"] ??
              json["NAMA_STATUS"] ??
              '',

      idUktKategori:
          json["ID_UKT_KATEGORI"] ?? json["id_ukt_kategori"] ?? 0,

      namaKategori:
          json["ukt_kategori"]
                  ?["NAMA_KATEGORI"] ??
              json["ukt_kategori"]
                  ?["nama_kategori"] ??
              json["nama_kategori"] ??
              json["NAMA_KATEGORI"] ??
              '',

      totalTagihan:
          double.tryParse(
                json["TOTAL_TAGIHAN"]
                    .toString(),
              ) ??
              double.tryParse(
                json["total_tagihan"]
                    .toString(),
              ) ??
              0,

      jatuhTempo:
          json["JATUH_TEMPO"] ?? json["jatuh_tempo"] ?? '',
    );
  }
}