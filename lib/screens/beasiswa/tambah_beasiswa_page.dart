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
    if (namaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama Beasiswa tidak boleh kosong")),
      );
      return;
    }

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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menambahkan beasiswa")),
      );
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