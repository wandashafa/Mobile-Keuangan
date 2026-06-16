class MahasiswaBeasiswa {
  final int idMb;
  final String nim;
  final String namaMahasiswa;
  final int idBeasiswa;
  final String namaBeasiswa;
  final String idTahunAkademik;
  final String tahunAkademik;
  final double nominalPotongan;

  MahasiswaBeasiswa({
    required this.idMb,
    required this.nim,
    required this.namaMahasiswa,
    required this.idBeasiswa,
    required this.namaBeasiswa,
    required this.idTahunAkademik,
    required this.tahunAkademik,
    required this.nominalPotongan,
  });

  factory MahasiswaBeasiswa.fromJson(
    Map<String, dynamic> json,
  ) {
    return MahasiswaBeasiswa(
      idMb: json['ID_MB'] ?? 0,

      nim: json['nimMahasiswa'] ?? '',

      namaMahasiswa:
          json['namaMahasiswa'] ?? '',

      idBeasiswa:
          json['ID_BEASISWA'] ?? 0,

      namaBeasiswa:
          json['beasiswa']
                  ?['NAMA_BEASISWA'] ??
              '',

      idTahunAkademik:
          json['ID_TAHUN_AKADEMIK']
                  ?.toString() ??
              '',

      tahunAkademik:
          json['tahunAkademik'] ?? '',

      nominalPotongan:
          double.tryParse(
                json['NOMINAL_POTONGAN']
                    .toString(),
              ) ??
              0,
    );
  }
}