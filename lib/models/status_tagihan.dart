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
          json["ID_STATUS_TAGIHAN"] ?? json["id_status_tagihan"] ?? 0,

      namaStatusTagihan:
          json["NAMA_STATUS_TAGIHAN"] ?? json["nama_status_tagihan"] ?? '',
    );
  }
}