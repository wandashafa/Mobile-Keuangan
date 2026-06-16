import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/pembayaran_controller.dart';
import '../../controllers/tagihan_controller.dart';
import '../../controllers/mahasiswa_controller.dart';

import '../../models/pembayaran.dart';
import '../../models/tagihan.dart';

import 'tambah_pembayaran_page.dart';
import 'edit_pembayaran_page.dart';

class PembayaranPage extends StatefulWidget {
  const PembayaranPage({super.key});

  @override
  State<PembayaranPage> createState() =>
      _PembayaranPageState();
}

class _PembayaranPageState
    extends State<PembayaranPage> {

  final pembayaranController =
      PembayaranController();

  final tagihanController =
      TagihanController();

  final searchController =
      TextEditingController();

  List<Pembayaran> data = [];

  List<Pembayaran> filtered = [];

  List<Tagihan> tagihanList = [];

  Map<int, Tagihan> tagihanMap = {};

  Map<String, String> namaMhs = {};

  bool isLoading = true;

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

      final pembayaran =
          await pembayaranController
              .getPembayaran();

      final tagihan =
          await tagihanController
              .getTagihan();

      tagihanMap = {
        for (var t in tagihan)
          t.idTagihan: t
      };

      // Fetch all mahasiswa once to resolve names instantly
      final allMhsList = await MahasiswaController().getAllMahasiswa();
      for (var m in allMhsList) {
        final nim = m['NIM']?.toString() ?? "";
        final nama = m['NAMA']?.toString() ?? "";
        if (nim.isNotEmpty) {
          namaMhs[nim] = nama;
        }
      }

      for (var item in tagihan) {
        if (!namaMhs.containsKey(item.nim)) {
          try {
            final mhs =
                await MahasiswaController()
                    .getMahasiswa(
              item.nim,
            );
            namaMhs[item.nim] =
                mhs["NAMA"] ?? "-";
          } catch (_) {
            namaMhs[item.nim] = "-";
          }
        }
      }

      setState(() {

        data = pembayaran;

        filtered = pembayaran;

        tagihanList = tagihan;

      });

    } catch (_) {}

    setState(() {
      isLoading = false;
    });
  }

  void search(String value) {

    setState(() {

      filtered =
          data.where((item) {

        final tagihan =
            tagihanMap[
                item.idTagihan];

        final nama =
            namaMhs[
                    tagihan?.nim ??
                        ""]
                ?.toLowerCase() ??
            "";

        return nama.contains(
              value.toLowerCase(),
            ) ||
            item.idPembayaran
                .toString()
                .contains(
                  value,
                );

      }).toList();
    });
  }

  Future<void> hapus(
    int id,
  ) async {

    final result =
        await pembayaranController
            .deletePembayaran(
      id,
    );

    if (result) {

      loadData();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Pembayaran berhasil dihapus",
          ),
        ),
      );
    }
  }

  double get totalPembayaran =>
      data.fold(
        0,
        (a, b) =>
            a +
            b.jumlahBayar,
      );

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(

      backgroundColor:
          const Color(
        0xFFF8F9FF,
      ),

      appBar: AppBar(
        title: const Text(
          "Manajemen Pembayaran",
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(

        backgroundColor:
            const Color(
          0xFF096430,
        ),
        foregroundColor: Colors.white,

        onPressed: () async {

          final result =
              await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) =>
                      const TambahPembayaranPage(),
            ),
          );

          if (result == true) {
            loadData();
          }
        },

        icon:
            const Icon(Icons.add),

        label:
            const Text(
          "Pembayaran",
        ),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh:
                  loadData,
              child:
                  SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.all(
                  16,
                ),
                child: Column(
                  children: [

                    Container(
                      padding:
                          const EdgeInsets.all(
                        16,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                      child: Column(
                        children: [

                          const Text(
                            "Total Pembayaran",
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            NumberFormat.currency(
                              locale: 'id',
                              symbol: 'Rp ',
                              decimalDigits:
                                  0,
                            ).format(
                              totalPembayaran,
                            ),
                            style:
                                const TextStyle(
                              fontSize:
                                  22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    TextField(
                      controller:
                          searchController,
                      onChanged:
                          search,
                      decoration:
                          InputDecoration(
                        hintText:
                            "Cari pembayaran",
                        prefixIcon:
                            const Icon(
                          Icons.search,
                        ),
                        filled: true,
                        fillColor:
                            Colors.white,
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    ListView.builder(
                      shrinkWrap:
                          true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount:
                          filtered.length,
                      itemBuilder:
                          (
                        context,
                        index,
                      ) {

                        final item =
                            filtered[
                                index];

                        final tagihan =
                            tagihanMap[
                                item.idTagihan];

                        final nama =
                            namaMhs[
                                    tagihan
                                            ?.nim ??
                                        ""]
                                ??
                                "-";

                        return Card(
                          child:
                              ListTile(

                            title:
                                Text(
                              nama,
                            ),

                            subtitle:
                                Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [

                                Text(
                                  "Pembayaran #${item.idPembayaran}",
                                ),

                                Text(
                                  NumberFormat.currency(
                                    locale:
                                        'id',
                                    symbol:
                                        'Rp ',
                                    decimalDigits:
                                        0,
                                  ).format(
                                    item.jumlahBayar,
                                  ),
                                ),
                              ],
                            ),

                            trailing:
                                Row(
                              mainAxisSize: MainAxisSize.min,
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
                                                EditPembayaranPage(
                                          idPembayaran:
                                              item.idPembayaran,
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
                                    hapus(
                                      item.idPembayaran,
                                    );
                                  },
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
    );
  }
}