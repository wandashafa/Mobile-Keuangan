import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/tagihan_controller.dart';
import '../../controllers/tahun_akademik_controller.dart';
import '../../controllers/mahasiswa_controller.dart';

import '../../services/ukt_service.dart';

import '../../models/tahun_akademik.dart';
import '../../models/ukt_kategori.dart';

class GenerateTagihanMassalPage
    extends StatefulWidget {
  const GenerateTagihanMassalPage({
    super.key,
  });

  @override
  State<GenerateTagihanMassalPage>
      createState() =>
          _GenerateTagihanMassalPageState();
}

class _GenerateTagihanMassalPageState
    extends State<
        GenerateTagihanMassalPage> {

  final tagihanController =
      TagihanController();

  final tahunController =
      TahunAkademikController();

  final uktService =
      UktService();

  List<TahunAkademik>
      listTahun = [];

  List<UktKategori>
      listKategori = [];

  String? selectedTahun;

  int? selectedKategori;

  DateTime? jatuhTempo;

  bool applyBeasiswa = true;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    final tahun =
        await tahunController
            .getTahunAkademik();

    final kategoriRaw =
        await uktService
            .getUktKategori();

    final kategori =
        kategoriRaw
            .map<UktKategori>(
              (e) =>
                  UktKategori
                      .fromJson(e),
            )
            .toList();

    setState(() {

      listTahun = tahun;

      listKategori = kategori;

      if (tahun.isNotEmpty) {
        selectedTahun =
            tahun.first.id
                .toString();
      }

      isLoading = false;
    });
  }

  Future<void> pilihTanggal()
      async {

    final picked =
        await showDatePicker(
      context: context,
      firstDate:
          DateTime.now(),
      lastDate:
          DateTime(2035),
      initialDate:
          DateTime.now(),
    );

    if (picked != null) {

      setState(() {

        jatuhTempo = picked;

      });
    }
  }

  Future<void> generate() async {
    if (selectedTahun == null ||
        selectedKategori == null ||
        jatuhTempo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi data")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final mhsList = await MahasiswaController().getAllMahasiswa();
      final statusId = 3; // Belum Bayar by default

      int generatedCount = 0;
      for (var m in mhsList) {
        final nim = m['NIM']?.toString() ?? "";
        if (nim.isEmpty) continue;

        await tagihanController.createTagihan(
          nim: nim,
          idTahunAkademik: selectedTahun!,
          idUktKategori: selectedKategori!,
          idStatusTagihan: statusId,
          jatuhTempo: DateFormat('yyyy-MM-dd').format(jatuhTempo!),
        );
        generatedCount++;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Berhasil membuat $generatedCount tagihan")),
      );
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal melakukan generate tagihan")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(
      BuildContext context) {

    if (isLoading) {

      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(

      backgroundColor:
          const Color(
        0xFFF8F9FF,
      ),

      appBar: AppBar(
        title: const Text(
          "Generate Tagihan",
        ),
        backgroundColor:
            Colors.white,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          children: [

            DropdownButtonFormField<
                String>(
              initialValue:
                  selectedTahun,
              decoration:
                  const InputDecoration(
                labelText:
                    "Tahun Akademik",
              ),
              items:
                  listTahun.map(
                (e) {

                  return DropdownMenuItem(
                    value:
                        e.id
                            .toString(),
                    child: Text(
                      e.nama,
                    ),
                  );
                },
              ).toList(),
              onChanged: (v) {

                selectedTahun = v;

              },
            ),

            const SizedBox(
              height: 16,
            ),

            DropdownButtonFormField<
                int>(
              decoration:
                  const InputDecoration(
                labelText:
                    "Kategori UKT",
              ),
              items:
                  listKategori.map(
                (e) {

                  return DropdownMenuItem(
                    value:
                        e.idUktKategori,
                    child: Text(
                      e.namaKategori,
                    ),
                  );
                },
              ).toList(),
              onChanged: (v) {

                selectedKategori =
                    v;

              },
            ),

            const SizedBox(
              height: 16,
            ),

            SwitchListTile(
              title: const Text("Terapkan Potongan Beasiswa"),
              subtitle: const Text("Potong nominal tagihan secara otomatis untuk penerima beasiswa"),
              value: applyBeasiswa,
              activeThumbColor: const Color(0xFF096430),
              onChanged: (v) {
                setState(() {
                  applyBeasiswa = v;
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            ListTile(
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
                side:
                    const BorderSide(
                  color:
                      Colors.grey,
                ),
              ),
              title: Text(
                jatuhTempo == null
                    ? "Pilih Jatuh Tempo"
                    : "${jatuhTempo!.day}/${jatuhTempo!.month}/${jatuhTempo!.year}",
              ),
              trailing:
                  const Icon(
                Icons.calendar_month,
              ),
              onTap:
                  pilihTanggal,
            ),

            const SizedBox(
              height: 24,
            ),

            Container(
              padding:
                  const EdgeInsets.all(
                16,
              ),
              decoration:
                  BoxDecoration(
                color:
                    Colors.green
                        .shade50,
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: const Row(
                children: [

                  Icon(
                    Icons.info,
                    color:
                        Color(
                      0xFF096430,
                    ),
                  ),

                  SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: Text(
                      "Sistem akan membuat tagihan seluruh mahasiswa berdasarkan kategori UKT yang dipilih.",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width:
                  double.infinity,
              height: 55,
              child:
                  ElevatedButton.icon(
                icon:
                    const Icon(
                  Icons.bolt,
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF096430,
                  ),
                  foregroundColor: Colors.white,
                ),
                onPressed:
                    generate,
                label:
                    const Text(
                  "Buat Tagihan Baru",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}