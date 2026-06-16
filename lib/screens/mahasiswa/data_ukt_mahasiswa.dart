import 'package:flutter/material.dart';
import '../../services/data_ukt_service.dart';
import 'edit_ukt_mahasiswa.dart';

class DataUktMahasiswaPage extends StatefulWidget {
  const DataUktMahasiswaPage({super.key});

  @override
  State<DataUktMahasiswaPage> createState() =>
      _DataUktMahasiswaPageState();
}

class _DataUktMahasiswaPageState
    extends State<DataUktMahasiswaPage> {
  List mahasiswa = [];
  List tagihan = [];

  List tahunAkademik = [];
  List prodi = [];
  List kategoriUkt = [];
  List statusTagihan = [];
  List statusMahasiswa = [];

  bool isLoading = true;

  String? selectedTahun;
  String? selectedProdi;
  String? selectedKategori;
  String? selectedStatus;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      errorMessage = null;
    });

    try {
      final tahun =
          await DataUktService.getTahun();

      final prodiData =
          await DataUktService.getProdi();

      final mahasiswaData =
          await DataUktService
              .getMahasiswa();

      final tagihanData =
          await DataUktService
              .getTagihan();

      final kategoriData =
          await DataUktService
              .getKategoriUkt();

      final statusData =
          await DataUktService
              .getStatusTagihan();
      
      final statusMhs =
    await DataUktService
        .getStatusMahasiswa();

      setState(() {
        tahunAkademik = tahun;
        prodi = prodiData;
        mahasiswa = mahasiswaData;
        tagihan = tagihanData;
        kategoriUkt = kategoriData;
        statusTagihan = statusData;
        statusMahasiswa = statusMhs;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loadData data_ukt_mahasiswa: $e");
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'lunas':
        return Colors.green;
      case 'belum bayar':
        return Colors.red;
      case 'cicil':
        return Colors.orange;
      case 'beasiswa':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void showFilterSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            DropdownButtonFormField<String>(
              initialValue: selectedTahun,
              decoration: const InputDecoration(
                labelText: 'Tahun Akademik',
                border: OutlineInputBorder(),
              ),
              items: tahunAkademik.map((e) {
                return DropdownMenuItem(
                  value:
                      e['id_tahun_akademik']
                          .toString(),
                  child: Text(
                    e['nama_tahun_akademik'],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTahun = value;
                });
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: selectedProdi,
              decoration: const InputDecoration(
                labelText: 'Program Studi',
                border: OutlineInputBorder(),
              ),
              items: prodi.map((e) {
                return DropdownMenuItem(
                  value:
                      e['id_prodi']
                          .toString(),
                  child: Text(
                    e['nama_prodi'],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProdi = value;
                });
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: selectedKategori,
              decoration: const InputDecoration(
                labelText: 'Kategori UKT',
                border: OutlineInputBorder(),
              ),
              items: kategoriUkt.map((e) {
                return DropdownMenuItem(
                  value:
                      e['ID_UKT_KATEGORI']
                          .toString(),
                  child: Text(
                    e['NAMA_KATEGORI'],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedKategori = value;
                });
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status Tagihan',
                border: OutlineInputBorder(),
              ),
              items: statusTagihan.map((e) {
                return DropdownMenuItem(
                  value:
                      e['ID_STATUS_TAGIHAN']
                          .toString(),
                  child: Text(
                    e['NAMA_STATUS_TAGIHAN'],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Terapkan Filter',
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF8F9FF),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Data UKT Mahasiswa',
          style: TextStyle(
            color: Color(0xff096430),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: loadData,
              child: ListView(
                padding:
                    const EdgeInsets.all(16),
                children: [
                  Container(
  padding: const EdgeInsets.all(20),
  margin: const EdgeInsets.only(
    bottom: 20,
  ),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius:
        BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,
    children: [

      const Text(
        'Data UKT Mahasiswa',
        style: TextStyle(
          fontSize: 28,
          fontWeight:
              FontWeight.bold,
          color: Color(0xff0A2A5E),
        ),
      ),

      const SizedBox(height: 8),

      const Text(
        'Kelola data UKT mahasiswa berdasarkan tahun akademik dan program studi.',
        style: TextStyle(
          color: Colors.black54,
        ),
      ),

      const SizedBox(height: 20),

      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [

          ElevatedButton.icon(
            onPressed:
                showFilterSheet,
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(
                      0xffE8F5EE),
              foregroundColor:
                  const Color(
                      0xff096430),
              elevation: 0,
            ),
            icon: const Icon(
              Icons.filter_list,
              size: 18,
            ),
            label:
                const Text('Filter'),
          ),

          if (selectedTahun != null)
            Chip(
              label: Text(
                selectedTahun!,
              ),
            ),

          if (selectedProdi != null)
            Chip(
              label: Text(
                selectedProdi!,
              ),
            ),
        ],
      ),
                    ],
                  ),
                ),
                if (errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      "Error: $errorMessage",
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                /// CARD MAHASISWA
                  ...mahasiswa.where((mhs) {
                    // Filter by prodi
                    if (selectedProdi != null &&
                        mhs['prodi']?['id_prodi']?.toString() != selectedProdi) {
                      return false;
                    }
                    
                    final dataTagihan = tagihan.firstWhere(
                      (e) => e['NIM'] == mhs['nim'],
                      orElse: () => {},
                    );

                    // Filter by tahun akademik
                    if (selectedTahun != null) {
                      final uktCatId = dataTagihan['ukt_kategori']?['ID_UKT_KATEGORI'];
                      final foundCat = kategoriUkt.firstWhere(
                        (c) => c['ID_UKT_KATEGORI']?.toString() == uktCatId?.toString(),
                        orElse: () => null,
                      );
                      if (foundCat == null ||
                          foundCat['ID_TAHUN_AKADEMIK']?.toString() != selectedTahun) {
                        return false;
                      }
                    }

                    // Filter by kategori ukt
                    if (selectedKategori != null &&
                        dataTagihan['ukt_kategori']?['ID_UKT_KATEGORI']?.toString() != selectedKategori) {
                      return false;
                    }

                    // Filter by status tagihan
                    if (selectedStatus != null &&
                        dataTagihan['status_tagihan']?['ID_STATUS_TAGIHAN']?.toString() != selectedStatus) {
                      return false;
                    }

                    return true;
                  }).map(
                    (mhs) {
                      final dataTagihan =
                          tagihan.firstWhere(
                        (e) =>
                            e['NIM'] ==
                            mhs['nim'],
                        orElse:
                            () => {},
                      );

                      final kategori =
                          dataTagihan[
                                      'ukt_kategori']
                                  ?[
                                  'NAMA_KATEGORI'] ??
                              '-';

                      final nominal =
                          dataTagihan[
                                      'ukt_kategori']
                                  ?[
                                  'NOMINAL'] ??
                              '0';

                      final status =
                          dataTagihan[
                                      'status_tagihan']
                                  ?[
                                  'NAMA_STATUS_TAGIHAN'] ??
                              '-';

                      final dataStatus =
    statusMahasiswa.firstWhere(
  (e) =>
      e['ID_STATUS_MHS'] ==
      mhs['id_status_mhs'],
  orElse: () => {},
);

                      return Container(
                        margin:
                            const EdgeInsets.only(
                          bottom: 16,
                        ),
                        padding:
                            const EdgeInsets
                                .all(
                          16,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            16,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black12,
                              blurRadius:
                                  6,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              mhs['nama'] ??
                                  '-',
                              style:
                                  const TextStyle(
                                fontSize:
                                    18,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            Text(
  'NIM : ${mhs['nim']}',
),

Text(
  'Program Studi : '
  '${mhs['prodi']?['nama_prodi'] ?? '-'}',
),

Text(
  'Jenis Kelamin : '
  '${mhs['jenis_kelamin']?['nama_jk'] ?? '-'}',
),

                          Text(
  'Status Mahasiswa : '
  '${dataStatus['NAMA_STATUS_MHS'] ?? '-'}',
),  

                            const SizedBox(
                              height:
                                  4,
                            ),

                            Text(
                              'NIM : ${mhs['nim']}',
                            ),

                            Text(
                              'Jenis Kelamin : ${mhs['jenis_kelamin']?['nama_jk'] ?? '-'}',
                            ),

                            const Divider(),

                            Text(
                              'Kategori UKT : $kategori',
                            ),

                            Text(
                              'Nominal : Rp $nominal',
                            ),

                            const SizedBox(
                              height:
                                  8,
                            ),

                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal:
                                    12,
                                vertical:
                                    6,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: statusColor(
                                        status)
                                    .withValues(alpha: 0.15),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  20,
                                ),
                              ),
                              child: Text(
                                status,
                                style:
                                    TextStyle(
                                  color:
                                      statusColor(
                                          status),
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height:
                                  12,
                            ),

                            Align(
                              alignment:
                                  Alignment
                                      .centerRight,
                              child:
                                  ElevatedButton
                                      .icon(
                                onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EditUktMahasiswaPage(
        mahasiswa: mhs,
      ),
    ),
  );
},
                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      const Color(
                                          0xff096430),
                                  foregroundColor:
                                      Colors
                                          .white,
                                ),
                                icon:
                                    const Icon(
                                  Icons.edit,
                                ),
                                label:
                                    const Text(
                                  'Edit Data',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}