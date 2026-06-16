import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/pembayaran_controller.dart';
import '../../controllers/tagihan_controller.dart';
import '../../controllers/metode_controller.dart';

import '../../models/tagihan.dart';
import '../../models/metode.dart';

class TambahPembayaranPage
    extends StatefulWidget {
  const TambahPembayaranPage({
    super.key,
  });

  @override
  State<TambahPembayaranPage>
      createState() =>
          _TambahPembayaranPageState();
}

class _TambahPembayaranPageState
    extends State<
        TambahPembayaranPage> {
  final pembayaranController =
      PembayaranController();

  final tagihanController =
      TagihanController();

  final metodeController =
      MetodeController();

  final jumlahController =
      TextEditingController();

  List<Tagihan> listTagihan = [];

  List<Metode> listMetode = [];

  int? selectedTagihan;

  int? selectedMetode;

  int cicilanKe = 1;

  DateTime tanggalBayar =
      DateTime.now();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final tagihan =
          await tagihanController
              .getTagihan();

      final metode =
          await metodeController
              .getMetode();

      setState(() {
        listTagihan = tagihan;
        listMetode = metode;
        isLoading = false;
      });
    } catch (_) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> simpan() async {
    if (selectedTagihan == null ||
        selectedMetode == null ||
        jumlahController
            .text.isEmpty) {
      return;
    }

    final result =
        await pembayaranController
            .createPembayaran(
      idTagihan:
          selectedTagihan!,
      idMetode:
          selectedMetode!,
      jumlahBayar:
          double.parse(
        jumlahController.text,
      ),
      tanggalBayar:
          DateFormat(
        "yyyy-MM-dd HH:mm:ss",
      ).format(
        tanggalBayar,
      ),
      cicilanKe: cicilanKe,
    );

    if (!mounted) return;

    if (result) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Pembayaran berhasil disimpan",
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
            "Gagal menyimpan pembayaran",
          ),
        ),
      );
    }
  }

  Future<void>
      pilihTanggal() async {
    final picked =
        await showDatePicker(
      context: context,
      initialDate:
          tanggalBayar,
      firstDate:
          DateTime(2024),
      lastDate:
          DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        tanggalBayar =
            picked;
      });
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
          "Tambah Pembayaran",
        ),
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          children: [

            DropdownButtonFormField<
                int>(
              initialValue:
                  selectedTagihan,
              decoration:
                  const InputDecoration(
                labelText:
                    "Tagihan",
              ),
              items:
                  listTagihan.map(
                (e) {
                  return DropdownMenuItem(
                    value:
                        e.idTagihan,
                    child: Text(
                      "${e.nim} - ${e.namaKategori}",
                    ),
                  );
                },
              ).toList(),
              onChanged: (v) {
                setState(() {
                  selectedTagihan =
                      v;
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  jumlahController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText:
                    "Jumlah Bayar",
                prefixText:
                    "Rp ",
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            DropdownButtonFormField<
                int>(
              initialValue:
                  selectedMetode,
              decoration:
                  const InputDecoration(
                labelText:
                    "Metode Pembayaran",
              ),
              items:
                  listMetode.map(
                (e) {
                  return DropdownMenuItem(
                    value:
                        e.idMetode,
                    child: Text(
                      e.namaMetode,
                    ),
                  );
                },
              ).toList(),
              onChanged: (v) {
                setState(() {
                  selectedMetode =
                      v;
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            DropdownButtonFormField<
                int>(
              initialValue:
                  cicilanKe,
              decoration:
                  const InputDecoration(
                labelText:
                    "Cicilan Ke",
              ),
              items: [
                1,
                2,
                3,
                4,
                5,
              ]
                  .map(
                    (e) =>
                        DropdownMenuItem(
                      value: e,
                      child: Text(
                        e.toString(),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() {
                  cicilanKe =
                      v ?? 1;
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
                DateFormat(
                  "dd MMM yyyy",
                ).format(
                  tanggalBayar,
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
                  "Simpan Pembayaran",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}