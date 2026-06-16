class StatusTagihan {

  final int idStatusTagihan;
  final String namaStatusTagihan;

  StatusTagihan({
    required this.idStatusTagihan,
    required this.namaStatusTagihan,
  });

  factory StatusTagihan.fromJson(
    Map<String, dynamic> json,
  ) {
    return StatusTagihan(
      idStatusTagihan:
          json["ID_STATUS_TAGIHAN"] ?? 0,

      namaStatusTagihan:
          json["NAMA_STATUS_TAGIHAN"] ?? '',
    );
  }
}