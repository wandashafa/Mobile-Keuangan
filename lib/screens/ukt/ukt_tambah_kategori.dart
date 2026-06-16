import 'package:flutter/material.dart';
import '../../controllers/ukt_controller.dart';

class UktTambahKategoriPage extends StatefulWidget {
  const UktTambahKategoriPage({super.key});

  @override
  State<UktTambahKategoriPage> createState() =>
      _UktTambahKategoriPageState();
}

class _UktTambahKategoriPageState
    extends State<UktTambahKategoriPage> {
  final _formKey = GlobalKey<FormState>();

  final UktController controller = UktController();

  final namaKategoriController =
      TextEditingController();

  final nominalController =
      TextEditingController();

  int? selectedJurusan;
  int? selectedTahun;

  bool loading = false;

  /// sementara dummy
  /// ganti dengan API kelompok 1
  final jurusanList = [
    {
      "id_jurusan": 1,
      "nama_jurusan": "Teknik Informatika",
    },
    {
      "id_jurusan": 2,
      "nama_jurusan": "Teknik Sipil",
    },
  ];

  final tahunList = [
    {
      "ID_TAHUN_AKADEMIK": 20251,
      "NAMA_TAHUN_AKADEMIK": "2024/2025 Ganjil",
    },
    {
      "ID_TAHUN_AKADEMIK": 20252,
      "NAMA_TAHUN_AKADEMIK": "2024/2025 Genap",
    },
  ];

  Future<void> simpan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedJurusan == null ||
        selectedTahun == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pilih jurusan dan tahun akademik',
          ),
        ),
      );
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      final success = await controller.tambahKategori(
        idJurusan: selectedJurusan!,
        idTahunAkademik: selectedTahun!,
        namaKategori:
            namaKategoriController.text.trim(),
        nominal: int.parse(
          nominalController.text
              .replaceAll('.', ''),
        ),
      );

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Kategori berhasil ditambahkan'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menambahkan kategori'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() {
      loading = false;
    });
  }

  void resetForm() {
    namaKategoriController.clear();
    nominalController.clear();

    setState(() {
      selectedJurusan = null;
      selectedTahun = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F9FF),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Tambah Kategori UKT",
          style: TextStyle(
            color: Color(0xff096430),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xff096430),
        ),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            /// JURUSAN
            const Text(
              "ID JURUSAN",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
  initialValue: selectedJurusan,
  decoration: inputDecoration(),
  hint: const Text("Pilih Jurusan"),
  items: jurusanList.map((item) {
    return DropdownMenuItem<int>(
      value: item["id_jurusan"] as int,
      child: Text(
        item["nama_jurusan"].toString(),
      ),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedJurusan = value;
    });
  },
  ),

            const SizedBox(height: 16),

            /// TAHUN AKADEMIK

            const Text(
              "ID TAHUN AKADEMIK",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              initialValue: selectedTahun,
              decoration: inputDecoration(),
              hint:
                  const Text("Pilih Tahun Akademik"),
              items: tahunList.map((item) {
                return DropdownMenuItem(
                  value:
                      item["ID_TAHUN_AKADEMIK"] as int,
                  child: Text(
                    item["NAMA_TAHUN_AKADEMIK"]
                        .toString(),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTahun = value;
                });
              },
            ),

            const SizedBox(height: 16),

            /// NAMA KATEGORI

            const Text(
              "NAMA KATEGORI",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextFormField(
              controller:
                  namaKategoriController,
              decoration: inputDecoration(
                hint: "Masukkan nama kategori",
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Wajib diisi";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            /// NOMINAL

            const Text(
              "NOMINAL",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextFormField(
              controller: nominalController,
              keyboardType:
                  TextInputType.number,
              decoration: inputDecoration(
                hint: "0",
                prefixText: "Rp ",
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty) {
                  return "Wajib diisi";
                }
                return null;
              },
            ),

            const SizedBox(height: 30),

            Row(
              children: [

                Expanded(
                  child: OutlinedButton(
                    onPressed: resetForm,
                    style:
                        OutlinedButton.styleFrom(
                      minimumSize:
                          const Size(0, 52),
                    ),
                    child: const Text("Reset"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        loading ? null : simpan,
                    style:
                        ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(0, 52),
                      backgroundColor:
                          const Color(
                              0xff096430),
                    ),
                    child: loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child:
                                CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Tambah Kategori",
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

  InputDecoration inputDecoration({
    String? hint,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixText: prefixText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}