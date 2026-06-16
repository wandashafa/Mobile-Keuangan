class Mahasiswa {
  final String nim;
  final String nama;
  final String kodeProdi;
  final int status;
  final int penghasilanAyah;
  final int penghasilanIbu;

  Mahasiswa({
    required this.nim,
    required this.nama,
    required this.kodeProdi,
    required this.status,
    required this.penghasilanAyah,
    required this.penghasilanIbu,
  });

  factory Mahasiswa.fromJson(
    Map<String, dynamic> json,
  ) {
    return Mahasiswa(
      nim: json['NIM'] ?? '',
      nama: json['NAMA'] ?? '',
      kodeProdi: json['KODE_PRODI'] ?? '',
      status: json['ID_STATUS_MHS'] ?? 0,
      penghasilanAyah:
          json['PENGHASILAN_AYAH'] ?? 0,
      penghasilanIbu:
          json['PENGHASILAN_IBU'] ?? 0,
    );
  }
}