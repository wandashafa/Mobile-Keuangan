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
          json["ID_TAGIHAN"] ?? 0,

      nim: json["NIM"] ?? '',

      idTahunAkademik:
          json["ID_TAHUN_AKADEMIK"]
                  ?.toString() ??
              '',

      idStatusTagihan:
          json["ID_STATUS_TAGIHAN"] ??
              0,

      namaStatus:
          json["status_tagihan"]
                  ?[
                  "NAMA_STATUS_TAGIHAN"] ??
              '',

      idUktKategori:
          json["ID_UKT_KATEGORI"] ??
              0,

      namaKategori:
          json["ukt_kategori"]
                  ?["NAMA_KATEGORI"] ??
              '',

      totalTagihan:
          double.tryParse(
                json["TOTAL_TAGIHAN"]
                    .toString(),
              ) ??
              0,

      jatuhTempo:
          json["JATUH_TEMPO"] ?? '',
    );
  }
}