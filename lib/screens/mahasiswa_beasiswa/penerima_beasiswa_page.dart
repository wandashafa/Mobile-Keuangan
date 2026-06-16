import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/mahasiswa_beasiswa_controller.dart';
import '../../controllers/mahasiswa_controller.dart';

import '../../models/mahasiswa_beasiswa.dart';

import 'tambah_penerima_beasiswa_page.dart';
import 'edit_penerima_beasiswa_page.dart';

class PenerimaBeasiswaPage extends StatefulWidget {
  const PenerimaBeasiswaPage({super.key});

  @override
  State<PenerimaBeasiswaPage> createState() =>
      _PenerimaBeasiswaPageState();
}

class _PenerimaBeasiswaPageState
    extends State<PenerimaBeasiswaPage> {
  final controller =
      MahasiswaBeasiswaController();

  final searchController =
      TextEditingController();

  List<MahasiswaBeasiswa> data = [];
  List<MahasiswaBeasiswa> filteredData =
      [];

  bool isLoading = true;

  String selectedFilter =
      "Semua";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await controller.getData();

      // Fetch all mahasiswa once to resolve names instantly
      final allMhsList = await MahasiswaController().getAllMahasiswa();
      final Map<String, String> namaMap = {};
      for (var m in allMhsList) {
        final nim = m['NIM']?.toString() ?? "";
        final nama = m['NAMA']?.toString() ?? "";
        if (nim.isNotEmpty) {
          namaMap[nim] = nama;
        }
      }

      List<MahasiswaBeasiswa> temp = [];

      for (var item in result) {
        final nim = (item['NIM'] ?? item['nim'])?.toString() ?? "";
        String nama = namaMap[nim] ?? '';

        // Fallback if not found in bulk list
        if (nama.isEmpty && nim.isNotEmpty) {
          try {
            final mahasiswa = await MahasiswaController().getMahasiswa(nim);
            nama = (mahasiswa['NAMA'] ?? mahasiswa['nama']) ?? '';
          } catch (_) {}
        }

        final bName = item['beasiswa']?['NAMA_BEASISWA'] ?? item['beasiswa']?['nama_beasiswa'] ?? '';
        final tAkademik = item['tahunAkademik']?['TAHUN_AKADEMIK'] ?? item['tahun_akademik']?['nama'] ?? item['id_tahun_akademik'] ?? item['ID_TAHUN_AKADEMIK'];

        temp.add(
          MahasiswaBeasiswa(
            idMb: item['ID_MB'] ?? item['id_mb'] ?? 0,
            nim: nim,
            namaMahasiswa: nama.isNotEmpty ? nama : "-",
            idBeasiswa: item['ID_BEASISWA'] ?? item['id_beasiswa'] ?? 0,
            namaBeasiswa: bName,
            idTahunAkademik: (item['ID_TAHUN_AKADEMIK'] ?? item['id_tahun_akademik'])?.toString() ?? '',
            tahunAkademik: tAkademik?.toString() ?? '',
            nominalPotongan: double.tryParse((item['NOMINAL_POTONGAN'] ?? item['nominal_potongan'])?.toString() ?? '') ?? 0,
          ),
        );
      }

      setState(() {
        data = temp;
        filteredData = temp;
      });
    } catch (_) {}

    setState(() {
      isLoading = false;
    });
  }

void searchData(String value) {
  setState(() {
    filteredData =
        data.where((e) {
      return e.namaMahasiswa
              .toLowerCase()
              .contains(
                value.toLowerCase(),
              ) ||
          e.nim.contains(value);
    }).toList();
  });
}

void filterData(String filter) {
  setState(() {
    selectedFilter = filter;

    if (filter == "Semua") {
      filteredData = data;
    } else {
      filteredData =
          data.where((e) {
        return e.namaBeasiswa
            .toLowerCase()
            .contains(
              filter.toLowerCase(),
            );
      }).toList();
    }
  });
}

Future<void> deleteData(
  int id,
) async {
  final result =
      await controller
          .deleteData(id);

  if (result) {
    loadData();
  }
}

Widget statCard(
  String title,
  String value,
) {
  return Container(
    padding:
        const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(
        12,
      ),
    ),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

@override
Widget build(
  BuildContext context,
) {
  return Scaffold(
    backgroundColor:
        const Color(
      0xFFF8F9FF,
    ),

    body: SafeArea(
      child: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh:
                  loadData,
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets
                        .all(16),
                child: Column(
                  children: [

                GridView.count(
  shrinkWrap: true,
  physics:
      const NeverScrollableScrollPhysics(),
  crossAxisCount: 2,
  childAspectRatio: 1.5,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  children: [
    statCard(
      "Total Penerima",
      data.length.toString(),
    ),
    statCard(
      "Prestasi",
      data
          .where(
            (e) => e
                .namaBeasiswa
                .toLowerCase()
                .contains(
                  "prestasi",
                ),
          )
          .length
          .toString(),
    ),
    statCard(
      "KIP-K",
      data
          .where(
            (e) =>
                e.namaBeasiswa
                    .toLowerCase()
                    .contains(
                      "kip",
                    ) ||
                e.namaBeasiswa
                    .toLowerCase()
                    .contains(
                      "bidik",
                    ),
          )
          .length
          .toString(),
    ),
    statCard(
      "Perusahaan",
      data
          .where(
            (e) => e
                .namaBeasiswa
                .toLowerCase()
                .contains(
                  "perusahaan",
                ),
          )
          .length
          .toString(),
    ),
  ],
),

const SizedBox(height: 20),

TextField(
  controller:
      searchController,
  onChanged:
      searchData,
  decoration:
      InputDecoration(
    hintText:
        "Cari nama penerima...",
    prefixIcon:
        const Icon(
      Icons.search,
    ),
    filled: true,
    fillColor: Colors.white,
    border:
        OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(
        12,
      ),
    ),
  ),
),

const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  height: 55,
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF096430),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    icon: const Icon(
      Icons.add_circle,
    ),
    label: const Text(
      "Tambah Penerima Baru",
    ),
    onPressed: () async {
      final result =
          await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) =>
                  const TambahPenerimaBeasiswaPage(),
        ),
      );

      if (result == true) {
        loadData();
      }
    },
  ),
),

const SizedBox(height: 20),

SingleChildScrollView(
  scrollDirection:
      Axis.horizontal,
  child: Row(
    children: [
      "Semua",
      "Prestasi",
      "KIP",
      "Perusahaan",
    ].map((e) {
      return Padding(
        padding:
            const EdgeInsets.only(
          right: 8,
        ),
        child: ChoiceChip(
          label: Text(e),
          selected:
              selectedFilter ==
                  e,
          onSelected: (_) =>
              filterData(e),
        ),
      );
    }).toList(),
  ),
),

const SizedBox(height: 20),

ListView.builder(
  shrinkWrap: true,
  physics:
      const NeverScrollableScrollPhysics(),
  itemCount:
      filteredData.length,
  itemBuilder:
      (context, index) {

    final item =
        filteredData[index];

    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(
          14,
        ),
        child: Row(
          children: [

            Container(
              width: 48,
              height: 48,
              decoration:
                  BoxDecoration(
                color: Colors
                    .green
                    .shade100,
                borderRadius:
                    BorderRadius
                        .circular(
                  12,
                ),
              ),
              child: const Icon(
                Icons.person,
                color:
                    Colors.green,
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [

                  Text(
                    "NIM : ${item.nim}",
                    style:
                        const TextStyle(
                      fontSize: 11,
                    ),
                  ),

                  Text(
                    item.namaMahasiswa,
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight
                              .bold,
                      fontSize:
                          16,
                    ),
                  ),

                  Text(
                    "TA : ${item.tahunAkademik}",
                  ),

                  Text(
                    "${item.namaBeasiswa} • ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0).format(item.nominalPotongan)}",
                  ),
                ],
              ),
            ),

            Column(
              children: [

                IconButton(
                  icon:
                      const Icon(
                    Icons.edit,
                    color:
                        Colors.green,
                  ),
                  onPressed:
                      () async {

                    final result =
                        await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                EditPenerimaBeasiswaPage(
                          data:
                              item,
                        ),
                      ),
                    );

                    if (result ==
                        true) {
                      loadData();
                    }
                  },
                ),

                IconButton(
                  icon:
                      const Icon(
                    Icons.delete,
                    color:
                        Colors.red,
                  ),
                  onPressed:
                      () {
                    deleteData(
                      item.idMb,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  },
),

                  ],
                ),
              ),
            ),
    ),
  );
}
}