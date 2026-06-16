import 'package:flutter/material.dart';
import '../../services/presensi_service.dart';
import '../../services/token_storage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() =>
      _DashboardPageState();
}

class _DashboardPageState
    extends State<DashboardPage> {
  String jamMasuk = "-";
  String jamPulang = "-";
  String status = "-";

  bool loadingMasuk = false;
  bool loadingKeluar = false;
  bool sudahAbsenMasuk = false;
  bool sudahAbsenPulang = false;


  Future<void> absenMasuk() async {
    setState(() {
      loadingMasuk = true;
    });

    final result =
        await PresensiService.absenMasuk();

    if (!mounted) return;

    setState(() {
      loadingMasuk = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result["message"] ??
              "Absen berhasil",
        ),
      ),
    );

    if (result["success"] == true) {
  setState(() {
    jamMasuk = TimeOfDay.now().format(context);
    status = "Hadir";
    sudahAbsenMasuk = true;
  });
}
  }

  Future<void> absenKeluar() async {
    setState(() {
      loadingKeluar = true;
    });

    final result =
        await PresensiService.absenKeluar();

    if (!mounted) return;

    setState(() {
      loadingKeluar = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result["message"] ??
              "Absen berhasil",
        ),
      ),
    );

    if (result["success"] == true &&
    result["data"] != null) {

  final presensi =
      result["data"]["data"];

  setState(() {
    jamPulang =
        presensi["waktu_keluar"] ?? "-";

    status =
        presensi["status_presensi"] == "H"
        ? "Hadir"
        : "-";

    sudahAbsenPulang = true;
  });
}
  }


void _showProfileDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Admin",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Administrator Sistem Keuangan SIMPADU",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Akhiri Sesi",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
  final navigator = Navigator.of(context);

  navigator.pop();

  await TokenStorage.clear();

  if (!mounted) return;

  navigator.pushNamedAndRemoveUntil(
    '/login',
    (route) => false,
  );
},
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF8F9FF),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "SIMPADU",
          style: TextStyle(
            color: Color(0xff096430),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
  IconButton(
    icon: const Icon(
      Icons.account_circle,
      color: Color(0xff096430),
    ),
    onPressed: () {
      _showProfileDialog();
    },
  ),
],
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [

            /// PRESENSI
            Container(
              padding:
                  const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Column(
                children: [

                  const Row(
                    children: [
                      Icon(
                        Icons.event_available,
                        color:
                            Color(0xff096430),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Presensi Hari Ini",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _item(
                    "Tanggal",
                    DateTime.now()
                        .toString()
                        .substring(0, 10),
                  ),

                  _item(
                    "Jam Masuk",
                    jamMasuk,
                  ),

                  _item(
                    "Jam Pulang",
                    jamPulang,
                  ),

                  _item(
                    "Status",
                    status,
                  ),

                  const SizedBox(height: 16),

                 SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: sudahAbsenPulang
        ? null
        : (sudahAbsenMasuk
            ? absenKeluar
            : absenMasuk),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff096430),
      foregroundColor: Colors.white,
    ),
    child: Text(
      sudahAbsenPulang
          ? "Sudah Presensi"
          : (sudahAbsenMasuk
              ? "Absen Pulang"
              : "Absen Masuk"),
    ),
  ),
),

                ],
              ),
            ),
            const SizedBox(height: 20),

            const Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                "Selamat datang kembali!",
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            const Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                "Silakan lakukan presensi untuk hari ini.",
              ),
            ),

            const SizedBox(height: 20),

            
          ],
        ),
      ),
    );
  }

  Widget _item(
      String title,
      String value,
      ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }            
  }
