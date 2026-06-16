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
          json["ID_PEMBAYARAN"] ?? json["id_pembayaran"] ?? 0,

      idTagihan:
          json["ID_TAGIHAN"] ?? json["id_tagihan"] ?? 0,

      idMetode:
          json["ID_METODE"] ?? json["id_metode"] ?? 0,

      jumlahBayar:
          double.tryParse(
                (json["JUMLAH_BAYAR"] ?? json["jumlah_bayar"])
                    .toString(),
              ) ??
              0,

      tanggalBayar:
          json["TANGGAL_BAYAR"] ?? json["tanggal_bayar"] ?? '',

      cicilanKe:
          json["CICILAN_KE"] ?? json["cicilan_ke"] ?? 1,

      verifiedBy:
          json["VERIFIED_BY"] ?? json["verified_by"],
    );
  }
}