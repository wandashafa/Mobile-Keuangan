import 'package:flutter/material.dart';
import '../../controllers/beasiswa_controller.dart';

class TambahBeasiswaPage extends StatefulWidget {
  const TambahBeasiswaPage({super.key});

  @override
  State<TambahBeasiswaPage> createState() =>
      _TambahBeasiswaPageState();
}

class _TambahBeasiswaPageState
    extends State<TambahBeasiswaPage> {

  final namaController =
      TextEditingController();

  final ketController =
      TextEditingController();

  bool isLoading = false;

  Future<void> simpan() async {
    setState(() => isLoading = true);

    final success =
        await BeasiswaController()
            .tambahBeasiswa(
      namaBeasiswa: namaController.text,
      keterangan: ketController.text,
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
            const Text("Tambah Beasiswa"),
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
              child: ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : simpan,
                child: Text(
                  isLoading
                      ? "Loading..."
                      : "Simpan Data",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}