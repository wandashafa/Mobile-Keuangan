import 'package:flutter/material.dart';
import '../../services/data_ukt_service.dart';

class EditUktMahasiswaPage extends StatefulWidget {
  final Map mahasiswa;

  const EditUktMahasiswaPage({
    super.key,
    required this.mahasiswa,
  });

  @override
  State<EditUktMahasiswaPage> createState() =>
      _EditUktMahasiswaPageState();
}

class _EditUktMahasiswaPageState
    extends State<EditUktMahasiswaPage> {
  List tahunAkademik = [];
  List kategoriUkt = [];
  List statusMahasiswa = [];

  String? selectedTahun;
  String? selectedKategori;
  String? selectedStatus;

  bool isLoading = true;
bool isSaving = false;

  @override
  void initState() {
    super.initState();
    loadMasterData();
  }

  Future<void> loadMasterData() async {
    try {
      final tahun =
          await DataUktService.getTahun();

      final kategori =
          await DataUktService
              .getKategoriUkt();

      final status =
          await DataUktService
              .getStatusMahasiswa();

      setState(() {
        tahunAkademik = tahun;
        kategoriUkt = kategori;
        statusMahasiswa = status;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateData() async {
  if (selectedStatus == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Pilih status mahasiswa',
        ),
      ),
    );
    return;
  }

  setState(() {
    isSaving = true;
  });

  final result =
      await DataUktService
          .updateStatusMahasiswa(
    nim: widget.mahasiswa['nim'],
    idStatus:
        int.parse(selectedStatus!),
  );

  if (!mounted) return;

  setState(() {
    isSaving = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        result['message'] ??
            'Berhasil',
      ),
    ),
  );

  if (result['success'] == true) {
    Navigator.pop(context, true);
  }
}

  @override
  Widget build(BuildContext context) {
    final mhs = widget.mahasiswa;

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Edit UKT Mahasiswa'),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.all(16),
              child: Column(
                children: [

                  TextFormField(
                    initialValue:
                        mhs['nim'],
                    enabled: false,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'NIM',
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  TextFormField(
                    initialValue:
                        mhs['nama'],
                    enabled: false,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Nama',
                      border:
                          OutlineInputBorder(),
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
                          'Tahun Akademik',
                      border:
                          OutlineInputBorder(),
                    ),
                    items:
                        tahunAkademik
                            .map((e) {
                      return DropdownMenuItem(
                        value: e[
                                'id_tahun_akademik']
                            .toString(),
                        child: Text(
                          e[
                              'nama_tahun_akademik'],
                        ),
                      );
                    }).toList(),
                    onChanged:
                        (value) {
                      setState(() {
                        selectedTahun =
                            value;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  DropdownButtonFormField<
                      String>(
                    initialValue:
                        selectedKategori,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Kategori UKT',
                      border:
                          OutlineInputBorder(),
                    ),
                    items:
                        kategoriUkt
                            .map((e) {
                      return DropdownMenuItem(
                        value: e[
                                'ID_UKT_KATEGORI']
                            .toString(),
                        child: Text(
                          e[
                              'NAMA_KATEGORI'],
                        ),
                      );
                    }).toList(),
                    onChanged:
                        (value) {
                      setState(() {
                        selectedKategori =
                            value;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  DropdownButtonFormField<
                      String>(
                    initialValue:
                        selectedStatus,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Status Mahasiswa',
                      border:
                          OutlineInputBorder(),
                    ),
                    items:
                        statusMahasiswa
                            .map((e) {
                      return DropdownMenuItem(
                        value: e[
                                'ID_STATUS_MHS']
                            .toString(),
                        child: Text(
                          e[
                              'NAMA_STATUS_MHS'],
                        ),
                      );
                    }).toList(),
                    onChanged:
                        (value) {
                      setState(() {
                        selectedStatus =
                            value;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 32,
                  ),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 50,
                    child:
                        ElevatedButton(
                      onPressed:
    isSaving
        ? null
        : updateData,
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            const Color(
                          0xff096430,
                        ),
                        foregroundColor:
                            Colors.white,
                      ),
                      child: isSaving
    ? const SizedBox(
        width: 24,
        height: 24,
        child:
            CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
    : const Text(
        'Update Data',
      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}