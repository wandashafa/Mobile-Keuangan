class Metode {
  final int idMetode;
  final String namaMetode;

  Metode({
    required this.idMetode,
    required this.namaMetode,
  });

  factory Metode.fromJson(
    Map<String, dynamic> json,
  ) {
    return Metode(
      idMetode:
          json["ID_METODE"] ?? 0,

      namaMetode:
          json["NAMA_METODE"] ?? '',
    );
  }
}