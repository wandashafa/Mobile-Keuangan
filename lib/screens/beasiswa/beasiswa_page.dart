import 'package:flutter/material.dart';

import '../../controllers/beasiswa_controller.dart';
import '../../models/beasiswa.dart';
import 'tambah_beasiswa_page.dart';
import 'edit_beasiswa_page.dart';

class BeasiswaPage extends StatefulWidget {
  const BeasiswaPage({super.key});

  @override
  State<BeasiswaPage> createState() => _BeasiswaPageState();
}

class _BeasiswaPageState extends State<BeasiswaPage> {
  final BeasiswaController controller = BeasiswaController();

  final TextEditingController searchController =
      TextEditingController();

  List<Beasiswa> allData = [];
  List<Beasiswa> filteredData = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();

    searchController.addListener(() {
      filterData(searchController.text);
    });
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);

    try {
      final result = await controller.getBeasiswa();

      setState(() {
        allData = result;
        filteredData = result;
      });
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => isLoading = false);
  }

  void filterData(String keyword) {
    setState(() {
      filteredData = allData.where((item) {
        return item.namaBeasiswa
            .toLowerCase()
            .contains(keyword.toLowerCase());
      }).toList();
    });
  }

  Future<void> hapusData(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text(
          "Yakin ingin menghapus beasiswa ini?",
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await controller.deleteBeasiswa(id);
      loadData();
    }
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
          "Manajemen Beasiswa",
          style: TextStyle(
            color: Color(0xff096430),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: loadData,
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding:
              const EdgeInsets.all(16),
          child: Column(
            children: [

              /// Statistik
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      "Total Beasiswa",
                      "${allData.length}",
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _statCard(
                      "Beasiswa Aktif",
                      "${allData.length}",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Search
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText:
                      "Cari nama beasiswa...",
                  prefixIcon:
                      const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                            14),
                    borderSide:
                        BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Tombol Tambah
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(
                            0xff096430),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final result =
                        await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const TambahBeasiswaPage(),
                      ),
                    );

                    if (result == true) {
                      loadData();
                    }
                  },
                  icon:
                      const Icon(Icons.add),
                  label: const Text(
                    "Tambah Beasiswa Baru",
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Align(
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  "Daftar Beasiswa",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),
              ),

              const SizedBox(height: 12),

              if (isLoading)
                const Padding(
                  padding:
                      EdgeInsets.all(30),
                  child:
                      CircularProgressIndicator(),
                )
              else if (filteredData.isEmpty)
                const Padding(
                  padding:
                      EdgeInsets.all(30),
                  child: Text(
                    "Data tidak ditemukan",
                  ),
                )
              else
                ListView.builder(
                  itemCount:
                      filteredData.length,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemBuilder:
                      (context, index) {
                    final item =
                        filteredData[index];

                    return Container(
                      margin:
                          const EdgeInsets.only(
                              bottom: 12),
                      padding:
                          const EdgeInsets.all(
                              16),
                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius
                                .circular(16),
                        border: Border.all(
                          color: Colors.grey
                              .shade200,
                        ),
                      ),
                      child: Row(
                        children: [

                          Container(
                            width: 50,
                            height: 50,
                            decoration:
                                BoxDecoration(
                              color: Colors
                                  .green
                                  .shade50,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          12),
                            ),
                            child: const Icon(
                              Icons
                                  .workspace_premium,
                              color: Colors
                                  .green,
                            ),
                          ),

                          const SizedBox(
                              width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  "ID : ${item.idBeasiswa}",
                                  style:
                                      const TextStyle(
                                    fontSize:
                                        11,
                                    color:
                                        Colors
                                            .grey,
                                  ),
                                ),

                                const SizedBox(
                                    height: 4),

                                Text(
                                  item
                                      .namaBeasiswa,
                                  style:
                                      const TextStyle(
                                    fontSize:
                                        16,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                    height: 4),

                                Text(
                                  item.keterangan,
                                  maxLines: 2,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: [

                              IconButton(
                                onPressed:
                                    () async {
                                  final result =
                                      await Navigator
                                          .push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                              EditBeasiswaPage(
                                        beasiswa:
                                            item,
                                      ),
                                    ),
                                  );

                                  if (result ==
                                      true) {
                                    loadData();
                                  }
                                },
                                icon:
                                    const Icon(
                                  Icons.edit,
                                  color: Color(
                                      0xff096430),
                                ),
                              ),

                              IconButton(
                                onPressed:
                                    () =>
                                        hapusData(
                                  item.idBeasiswa,
                                ),
                                icon:
                                    const Icon(
                                  Icons.delete,
                                  color:
                                      Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(
    String title,
    String value,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(
            0xffEFF4FF),
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}