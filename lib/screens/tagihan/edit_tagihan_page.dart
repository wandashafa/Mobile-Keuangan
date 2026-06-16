import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/tagihan_controller.dart';
import '../../controllers/status_tagihan_controller.dart';
import '../../controllers/tahun_akademik_controller.dart';

import '../../models/tagihan.dart';
import '../../models/status_tagihan.dart';
import '../../models/tahun_akademik.dart';

class EditTagihanPage extends StatefulWidget {
  final Tagihan data;

  const EditTagihanPage({
    super.key,
    required this.data,
  });

  @override
  State<EditTagihanPage> createState() =>
      _EditTagihanPageState();
}

class _EditTagihanPageState
    extends State<EditTagihanPage> {

  final tagihanController =
      TagihanController();

  final statusController =
      StatusTagihanController();

  final tahunController =
      TahunAkademikController();

  final nimController =
      TextEditingController();

  final totalController =
      TextEditingController();

  final namaController =
      TextEditingController();

  List<StatusTagihan>
      listStatus = [];

  List<TahunAkademik>
      listTahun = [];

  int? selectedStatus;

  String? selectedTahun;

  DateTime?
      selectedTanggal;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    try {

      final detail =
    await tagihanController
        .getDetailTagihan(
  widget.data.idTagihan,
);

if (detail == null) {
  if (!mounted) return;

  ScaffoldMessenger.of(context)
      .showSnackBar(
    const SnackBar(
      content: Text(
        "Data tagihan tidak ditemukan",
      ),
    ),
  );

  Navigator.pop(context);
  return;
}

      final statusRaw =
          await statusController
              .getStatusTagihan();

      final tahun =
          await tahunController
              .getTahunAkademik();

      setState(() {

        listStatus =
            statusRaw;

        listTahun =
            tahun;

        nimController.text =
            detail.nim;

        totalController.text =
            detail.totalTagihan
                .toStringAsFixed(0);

        selectedStatus =
            detail.idStatusTagihan;

        selectedTahun =
            detail.idTahunAkademik;

        selectedTanggal =
            DateTime.parse(
          detail.jatuhTempo,
        );

        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pilihTanggal()
      async {

    final picked =
        await showDatePicker(
      context: context,
      initialDate:
          selectedTanggal ??
              DateTime.now(),
      firstDate:
          DateTime(2024),
      lastDate:
          DateTime(2035),
    );

    if (picked != null) {

      setState(() {

        selectedTanggal =
            picked;

      });
    }
  }

  Future<void> simpan() async {

    if (selectedStatus ==
            null ||
        selectedTanggal ==
            null) {
      return;
    }

    final result =
    await tagihanController
        .updateTagihan(
  idTagihan:
      widget.data.idTagihan,
  idStatusTagihan:
      selectedStatus!,
  totalTagihan:
      double.parse(
    totalController.text,
  ),
  jatuhTempo:
      DateFormat(
    'yyyy-MM-dd',
  ).format(
    selectedTanggal!,
  ),
);

    if (!mounted) return;

    if (result) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Tagihan berhasil diperbarui",
          ),
        ),
      );

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
            "Gagal memperbarui tagihan",
          ),
        ),
      );
    }
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
          "Edit Tagihan",
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

            TextFormField(
              controller:
                  nimController,
              readOnly: true,
              decoration:
                  const InputDecoration(
                labelText:
                    "NIM Mahasiswa",
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextFormField(
              controller:
                  totalController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText:
                    "Total Tagihan",
              ),
            ),

            const SizedBox(
              height: 16,
            ),

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
              onChanged: null,
            ),

            const SizedBox(
              height: 16,
            ),

            DropdownButtonFormField<
                int>(
              initialValue:
                  selectedStatus,
              decoration:
                  const InputDecoration(
                labelText:
                    "Status Tagihan",
              ),
              items:
                  listStatus.map(
                (e) {

                  return DropdownMenuItem(
                    value:
                        e.idStatusTagihan,
                    child: Text(
                      e.namaStatusTagihan,
                    ),
                  );
                },
              ).toList(),
              onChanged: (v) {

                setState(() {

                  selectedStatus =
                      v;

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
                selectedTanggal ==
                        null
                    ? "Pilih Jatuh Tempo"
                    : DateFormat(
                        "dd MMM yyyy",
                      ).format(
                        selectedTanggal!,
                      ),
              ),
              trailing:
                  const Icon(
                Icons.calendar_month,
              ),
              onTap:
                  pilihTanggal,
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width:
                  double.infinity,
              height: 55,
              child:
                  ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF096430,
                  ),
                ),
                onPressed:
                    simpan,
                child:
                    const Text(
                  "Simpan Perubahan",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

