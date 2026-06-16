import 'package:flutter/material.dart';

import '../../controllers/mahasiswa_controller.dart';
import '../../controllers/beasiswa_controller.dart';
import '../../controllers/tahun_akademik_controller.dart';
import '../../controllers/mahasiswa_beasiswa_controller.dart';

import '../../models/beasiswa.dart';
import '../../models/tahun_akademik.dart';

class TambahPenerimaBeasiswaPage
    extends StatefulWidget {
  const TambahPenerimaBeasiswaPage({
    super.key,
  });

  @override
  State<TambahPenerimaBeasiswaPage>
      createState() =>
          _TambahPenerimaBeasiswaPageState();
}

class _TambahPenerimaBeasiswaPageState
    extends State<
        TambahPenerimaBeasiswaPage> {

  final nimController =
      TextEditingController();

  final namaController =
      TextEditingController();

  final nominalController =
      TextEditingController();

  final mahasiswaController =
      MahasiswaController();

  final beasiswaController =
      BeasiswaController();

  final tahunController =
      TahunAkademikController();

  final penerimaController =
      MahasiswaBeasiswaController();

  List<Beasiswa> listBeasiswa = [];

  List<TahunAkademik>
      listTahun = [];

  List<dynamic> listMahasiswa = [];

  int? selectedBeasiswa;

  int? selectedTahun;

  String? selectedNim;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadDropdown();
  }

  Future<void> loadDropdown() async {
    final beasiswa =
        await beasiswaController
            .getBeasiswa();

    final tahun =
    await tahunController
        .getTahunAkademik();

    final mhs =
        await mahasiswaController
            .getAllMahasiswa();

    setState(() {
      listBeasiswa =
          beasiswa;

      listTahun =
          tahun;

      listMahasiswa =
          mhs;
    });
  }

  Future<void> simpanData() async {

    if (selectedBeasiswa ==
            null ||
        selectedTahun ==
            null ||
        nimController.text
            .isEmpty ||
        nominalController.text
            .isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final success =
        await penerimaController
            .createData(
      selectedBeasiswa!,
      nimController.text,
      selectedTahun!,
      nominalController.text,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (success) {

      Navigator.pop(
          context,
          true,
      );

    } else {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Gagal menyimpan data",
          ),
        ),
      );
    }
  }

  void resetForm() {

    nimController.clear();

    namaController.clear();

    nominalController.clear();

    setState(() {

      selectedBeasiswa =
          null;

      selectedTahun =
          null;

      selectedNim =
          null;

    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      backgroundColor:
          const Color(
        0xffF8F9FF,
      ),

      appBar: AppBar(
        title: const Text(
          "Tambah Penerima Beasiswa",
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

            DropdownButtonFormField<String>(
              initialValue: selectedNim,
              decoration: const InputDecoration(
                labelText: "NIM Mahasiswa",
              ),
              items: listMahasiswa.map((e) {
                final nim = e['NIM']?.toString() ?? "";
                final nama = e['NAMA']?.toString() ?? "";
                return DropdownMenuItem(
                  value: nim,
                  child: Text("$nim - $nama"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedNim = value;
                  nimController.text = value ?? "";
                  final found = listMahasiswa.firstWhere(
                    (e) => (e['NIM'] ?? '').toString() == (value ?? ''),
                    orElse: () => null,
                  );
                  if (found != null) {
                    namaController.text = found['NAMA']?.toString() ?? "";
                  } else {
                    namaController.clear();
                  }
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  namaController,
              readOnly: true,
              decoration:
                  const InputDecoration(
                labelText:
                    "Nama Mahasiswa",
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            DropdownButtonFormField<
                int>(
              initialValue:
                  selectedBeasiswa,
              decoration:
                  const InputDecoration(
                labelText:
                    "Program Beasiswa",
              ),
              items:
                  listBeasiswa.map(
                (e) {
                  return DropdownMenuItem(
                    value:
                        e.idBeasiswa,
                    child: Text(
                      e.namaBeasiswa,
                    ),
                  );
                },
              ).toList(),
              onChanged:
                  (value) {
                setState(() {
                  selectedBeasiswa =
                      value;
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            DropdownButtonFormField<
                int>(
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
                        e.id,
                    child: Text(
                      e.nama,
                    ),
                  );
                },
              ).toList(),
              onChanged:
                  (value) {
                setState(() {
                  selectedTahun =
                      value;
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  nominalController,
              keyboardType:
                  TextInputType
                      .number,
              decoration:
                  const InputDecoration(
                labelText:
                    "Nominal Potongan",
                prefixText:
                    "Rp ",
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            Row(

              children: [

                Expanded(
                  child:
                      OutlinedButton(
                    onPressed:
                        resetForm,
                    child:
                        const Text(
                      "Reset",
                    ),
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child:
                      ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : simpanData,
                    child:
                        isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                "Simpan Data",
                              ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}