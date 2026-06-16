import 'package:flutter/material.dart';
import '../../controllers/ukt_controller.dart';
import '../../models/ukt_kategori.dart';

class UktEditKategoriPage extends StatefulWidget {
  final UktKategori kategori;

  const UktEditKategoriPage({
    super.key,
    required this.kategori,
  });

  @override
  State<UktEditKategoriPage> createState() =>
      _UktEditKategoriPageState();
}

class _UktEditKategoriPageState
    extends State<UktEditKategoriPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController nominalController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(
      text: widget.kategori.namaKategori,
    );

    nominalController = TextEditingController(
      text: widget.kategori.nominal.toInt().toString(),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    nominalController.dispose();
    super.dispose();
  }

  Future<void> simpanPerubahan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await UktController().updateKategori(
        id: widget.kategori.idUktKategori,
        namaKategori: namaController.text,
        nominal: int.parse(nominalController.text),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Kategori berhasil diperbarui',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal update: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xff096430);

    return Scaffold(
      backgroundColor: const Color(0xffF8F9FF),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Edit Kategori UKT',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme:
            const IconThemeData(color: Colors.black),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                  side: const BorderSide(
                    color: Color(0xffE2E8F0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue:
                            widget.kategori.idJurusan
                                .toString(),
                        enabled: false,
                        decoration:
                            const InputDecoration(
                          labelText: 'ID Jurusan',
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        initialValue: widget
                            .kategori.idTahunAkademik
                            .toString(),
                        enabled: false,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Tahun Akademik',
                          border:
                              OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: namaController,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Nama Kategori',
                          border:
                              OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Nama kategori wajib diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: nominalController,
                        keyboardType:
                            TextInputType.number,
                        decoration:
                            const InputDecoration(
                          prefixText: 'Rp ',
                          labelText: 'Nominal',
                          border:
                              OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Nominal wajib diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                namaController.text =
                                    widget.kategori
                                        .namaKategori;

                                nominalController
                                    .text = widget
                                        .kategori
                                        .nominal
                                        .toInt()
                                        .toString();
                              },
                              child:
                                  const Text('Reset'),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: ElevatedButton(
                              style:
                                  ElevatedButton
                                      .styleFrom(
                                backgroundColor:
                                    primaryColor,
                                foregroundColor:
                                    Colors.white,
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical: 14,
                                ),
                              ),
                              onPressed:
                                  isLoading
                                      ? null
                                      : simpanPerubahan,
                              child:
                                  isLoading
                                      ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth:
                                              2,
                                          color:
                                              Colors.white,
                                        ),
                                      )
                                      : const Text(
                                        'Simpan Perubahan',
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}