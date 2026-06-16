import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/mahasiswa_beasiswa_controller.dart';
import '../../models/mahasiswa_beasiswa.dart';

class EditPenerimaBeasiswaPage
    extends StatefulWidget {

  final MahasiswaBeasiswa data;

  const EditPenerimaBeasiswaPage({
    super.key,
    required this.data,
  });

  @override
  State<EditPenerimaBeasiswaPage>
      createState() =>
          _EditPenerimaBeasiswaPageState();
}

class _EditPenerimaBeasiswaPageState
    extends State<
        EditPenerimaBeasiswaPage> {

  final controller =
      MahasiswaBeasiswaController();

  late TextEditingController
      nimController;

  late TextEditingController
      namaController;

  late TextEditingController
      beasiswaController;

  late TextEditingController
      tahunController;

  late TextEditingController
      nominalController;

  bool isLoading = false;

  @override
  void initState() {

    super.initState();

    nimController =
        TextEditingController(
      text: widget.data.nim,
    );

    namaController =
        TextEditingController(
      text:
          widget.data.namaMahasiswa,
    );

    beasiswaController =
        TextEditingController(
      text:
          widget.data.namaBeasiswa,
    );

    tahunController =
        TextEditingController(
      text:
          widget.data.tahunAkademik,
    );

    nominalController =
        TextEditingController(
      text: widget
          .data.nominalPotongan
          .toInt()
          .toString(),
    );
  }

  Future<void> updateData() async {

    if (nominalController.text
        .trim()
        .isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result =
        await controller
            .updateData(
      widget.data.idMb,
      nominalController.text
          .replaceAll(".", ""),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (result) {

      Navigator.pop(
        context,
        true,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Data berhasil diupdate",
          ),
        ),
      );

    } else {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Gagal update data",
          ),
        ),
      );
    }
  }

  void resetForm() {

    nominalController.text =
        widget.data
            .nominalPotongan
            .toInt()
            .toString();
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      backgroundColor:
          const Color(
        0xFFF8F9FF,
      ),

      appBar: AppBar(
        title: const Text(
          "Edit Penerima Beasiswa",
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(
          16,
        ),

        child: Column(

          children: [

            TextField(
              controller:
                  nimController,
              readOnly: true,
              decoration:
                  const InputDecoration(
                labelText:
                    "NIM Mahasiswa",
                prefixIcon:
                    Icon(
                  Icons.badge,
                ),
              ),
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

            TextField(
              controller:
                  beasiswaController,
              readOnly: true,
              decoration:
                  const InputDecoration(
                labelText:
                    "Program Beasiswa",
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  tahunController,
              readOnly: true,
              decoration:
                  const InputDecoration(
                labelText:
                    "Tahun Akademik",
              ),
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
              onChanged:
                  (value) {

                value = value
                    .replaceAll(
                  ".",
                  "",
                );

                if (value.isEmpty) {
                  return;
                }

                final format =
                    NumberFormat(
                  "#,###",
                  "id_ID",
                );

                final result =
                    format.format(
                  int.parse(
                    value,
                  ),
                );

                nominalController
                    .value =
                    TextEditingValue(
                  text: result,
                  selection:
                      TextSelection.collapsed(
                    offset:
                        result.length,
                  ),
                );
              },
            ),

            const SizedBox(
              height: 30,
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
                            : updateData,
                    child:
                        isLoading
                            ? const SizedBox(
                                height:
                                    20,
                                width:
                                    20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      2,
                                ),
                              )
                            : const Text(
                                "Simpan Perubahan",
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