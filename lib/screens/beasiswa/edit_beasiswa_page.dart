import 'package:flutter/material.dart';

import '../../controllers/beasiswa_controller.dart';
import '../../models/beasiswa.dart';

class EditBeasiswaPage
    extends StatefulWidget {

  final Beasiswa beasiswa;

  const EditBeasiswaPage({
    super.key,
    required this.beasiswa,
  });

  @override
  State<EditBeasiswaPage> createState() =>
      _EditBeasiswaPageState();
}

class _EditBeasiswaPageState
    extends State<EditBeasiswaPage> {

  late TextEditingController
      namaController;

  late TextEditingController
      ketController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    namaController =
        TextEditingController(
      text:
          widget.beasiswa.namaBeasiswa,
    );

    ketController =
        TextEditingController(
      text:
          widget.beasiswa.keterangan,
    );
  }

  Future<void> update() async {
    setState(() => isLoading = true);

    final success =
        await BeasiswaController()
            .updateBeasiswa(
      id: widget.beasiswa.idBeasiswa,
      namaBeasiswa:
          namaController.text,
      keterangan:
          ketController.text,
    );

    if (!mounted) return;


    setState(() => isLoading = false);

    if (success) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF8F9FF),

      appBar: AppBar(
        title:
            const Text("Edit Beasiswa"),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller:
                  namaController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Nama Beasiswa",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  ketController,
              maxLines: 5,
              decoration:
                  const InputDecoration(
                labelText:
                    "Keterangan",
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF096430),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                    isLoading
                        ? null
                        : update,
                child: Text(
                  isLoading
                      ? "Loading..."
                      : "Simpan Perubahan",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}