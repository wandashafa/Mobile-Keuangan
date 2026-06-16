class Pembayaran {
  final int idPembayaran;
  final int idTagihan;
  final int idMetode;
  final double jumlahBayar;
  final String tanggalBayar;
  final int cicilanKe;
  final int? verifiedBy;

  Pembayaran({
    required this.idPembayaran,
    required this.idTagihan,
    required this.idMetode,
    required this.jumlahBayar,
    required this.tanggalBayar,
    required this.cicilanKe,
    this.verifiedBy,
  });

  factory Pembayaran.fromJson(
    Map<String, dynamic> json,
  ) {
    return Pembayaran(
      idPembayaran:
          json["ID_PEMBAYARAN"] ?? 0,

      idTagihan:
          json["ID_TAGIHAN"] ?? 0,

      idMetode:
          json["ID_METODE"] ?? 0,

      jumlahBayar:
          double.tryParse(
                json["JUMLAH_BAYAR"]
                    .toString(),
              ) ??
              0,

      tanggalBayar:
          json["TANGGAL_BAYAR"] ?? '',

      cicilanKe:
          json["CICILAN_KE"] ?? 1,

      verifiedBy:
          json["VERIFIED_BY"],
    );
  }
}