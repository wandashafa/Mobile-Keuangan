import 'package:flutter/material.dart';

import '../../controllers/pembayaran_controller.dart';
import '../../controllers/metode_controller.dart';

import '../../models/pembayaran.dart';
import '../../models/metode.dart';

class EditPembayaranPage
    extends StatefulWidget {

  final int idPembayaran;

  const EditPembayaranPage({
    super.key,
    required this.idPembayaran,
  });

  @override
  State<EditPembayaranPage>
      createState() =>
          _EditPembayaranPageState();
}

class _EditPembayaranPageState
    extends State<
        EditPembayaranPage> {

  final pembayaranController =
      PembayaranController();

  final metodeController =
      MetodeController();

  final jumlahController =
      TextEditingController();

  List<Metode> listMetode = [];

  Pembayaran? pembayaran;

  int? selectedMetode;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    try {

      final detail =
          await pembayaranController
              .getDetailPembayaran(
        widget.idPembayaran,
      );

      final metode =
          await metodeController
              .getMetode();

      setState(() {

        pembayaran =
            detail;

        listMetode =
            metode;

        jumlahController.text =
            detail.jumlahBayar
                .toStringAsFixed(
          0,
        );

        selectedMetode =
            detail.idMetode;

        isLoading = false;

      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> simpan() async {

    if (selectedMetode ==
        null) {
      return;
    }

    final result =
        await pembayaranController
            .updatePembayaran(
      idPembayaran:
          widget.idPembayaran,
      jumlahBayar:
          double.parse(
        jumlahController.text,
      ),
      idMetode:
          selectedMetode!,
    );

    if (!mounted) return;

    if (result) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Pembayaran berhasil diupdate",
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
            "Gagal update pembayaran",
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {

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
          "Edit Pembayaran",
        ),
      ),

      body:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          children: [

            TextFormField(
              initialValue:
                  pembayaran
                          ?.idTagihan
                          .toString() ??
                      "",
              readOnly: true,
              decoration:
                  const InputDecoration(
                labelText:
                    "ID Tagihan",
              ),
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
                  "Update Pembayaran",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}