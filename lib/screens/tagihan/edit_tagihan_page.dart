import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/tagihan_controller.dart';
import '../../controllers/status_tagihan_controller.dart';
import '../../controllers/tahun_akademik_controller.dart';
import '../../controllers/mahasiswa_controller.dart';

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

  final mahasiswaController =
      MahasiswaController();

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
      final statusRaw = await statusController.getStatusTagihan();
      final tahun = await tahunController.getTahunAkademik();

      setState(() {
        listStatus = statusRaw;
        listTahun = tahun;
      });
    } catch (_) {}

    try {
      final detail = await tagihanController.getDetailTagihan(
        widget.data.idTagihan,
      );

      if (detail != null) {
        setState(() {
          nimController.text = detail.nim;
          totalController.text = detail.totalTagihan.toStringAsFixed(0);
          selectedStatus = detail.idStatusTagihan;
          selectedTahun = detail.idTahunAkademik;
          selectedTanggal = DateTime.tryParse(detail.jatuhTempo);
        });
      }
    } catch (_) {}

    setState(() {
      isLoading = false;
    });
  }

  Future<void> cariMahasiswa() async {
    if (nimController.text.trim().isEmpty) {
      return;
    }

    try {
      final mahasiswa = await mahasiswaController.getMahasiswa(
        nimController.text.trim(),
      );

      if (mahasiswa.isNotEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Mahasiswa ditemukan: ${mahasiswa['NAMA'] ?? ''}"),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Mahasiswa tidak ditemukan"),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mahasiswa tidak ditemukan"),
        ),
      );
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
  nim: nimController.text,
  idTahunAkademik: selectedTahun,
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
              decoration:
                  InputDecoration(
                labelText:
                    "NIM Mahasiswa",
                suffixIcon:
                    IconButton(
                  icon:
                      const Icon(
                    Icons.search,
                  ),
                  onPressed:
                      cariMahasiswa,
                ),
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
              items: [
                if (selectedTahun != null && !listTahun.any((e) => e.id.toString() == selectedTahun))
                  DropdownMenuItem(
                    value: selectedTahun,
                    child: Text("Tahun #$selectedTahun"),
                  ),
                ...listTahun.map(
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
                ),
              ],
              onChanged: (v) {
                setState(() {
                  selectedTahun = v;
                });
              },
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
              items: [
                if (selectedStatus != null && !listStatus.any((e) => e.idStatusTagihan == selectedStatus))
                  DropdownMenuItem(
                    value: selectedStatus,
                    child: Text("Status #$selectedStatus"),
                  ),
                ...listStatus.map(
                  (e) {

                    return DropdownMenuItem(
                      value:
                          e.idStatusTagihan,
                      child: Text(
                        e.namaStatusTagihan,
                      ),
                    );
                  },
                ),
              ],
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
                  foregroundColor: Colors.white,
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

