import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/tagihan_controller.dart';
import '../../controllers/mahasiswa_controller.dart';

import '../../models/tagihan.dart';

import 'tambah_tagihan_page.dart';
import 'edit_tagihan_page.dart';
import 'tagihan_massal_page.dart';

class TagihanPage extends StatefulWidget {
  const TagihanPage({super.key});

  @override
  State<TagihanPage> createState() =>
      _TagihanPageState();
}

class _TagihanPageState
    extends State<TagihanPage> {

  final controller =
      TagihanController();

  final searchController =
      TextEditingController();

  List<Tagihan> data = [];

  List<Tagihan> filteredData = [];

  Map<String, String>
      namaMahasiswa = {};

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

      final result =
          await controller
              .getTagihan();

      for (var item in result) {

        try {

          final mahasiswa =
              await MahasiswaController()
                  .getMahasiswa(
            item.nim,
          );

          namaMahasiswa[item.nim] =
              mahasiswa["NAMA"] ?? "";

        } catch (_) {

          namaMahasiswa[item.nim] =
              "-";

        }
      }

      setState(() {

        data = result;
        filteredData = result;

      });

    } catch (_) {}

    setState(() {
      isLoading = false;
    });
  }

    void searchData(
    String keyword,
  ) {

    setState(() {

      filteredData =
          data.where((e) {

        final nama =
            namaMahasiswa[e.nim] ?? '';

        return nama
                .toLowerCase()
                .contains(
                  keyword
                      .toLowerCase(),
                ) ||
            e.nim.contains(
              keyword,
            );

      }).toList();

    });
  }

    void filterData(
    String status,
  ) {

    setState(() {

      selectedFilter =
          status;

      if (status == "Semua") {

        filteredData = data;

      } else {

        filteredData =
            data.where((e) {

          return e.namaStatus
                  .toLowerCase() ==
              status
                  .toLowerCase();

        }).toList();
      }
    });
  }

    double get totalTagihan =>
      data.fold(
        0,
        (sum, item) =>
            sum +
            item.totalTagihan,
      );

  double get totalTerbayar =>
      data
          .where(
            (e) =>
                e.namaStatus
                    .toLowerCase() ==
                "lunas",
          )
          .fold(
            0,
            (sum, item) =>
                sum +
                item.totalTagihan,
          );

  double get totalBelumLunas =>
      totalTagihan -
      totalTerbayar;

  int get totalCicilan =>
      data
          .where(
            (e) =>
                e.namaStatus
                    .toLowerCase() ==
                "cicil",
          )
          .length;

    Future<void> deleteData(
    int id,
  ) async {

    final result =
        await controller
            .deleteTagihan(id);

    if (result) {

      loadData();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            "Tagihan berhasil dihapus",
          ),
        ),
      );
    }
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

            floatingActionButton:
          FloatingActionButton.extended(

        backgroundColor:
            const Color(
          0xFF096430,
        ),

        onPressed: () async {

          final result =
              await Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) =>
                      const TambahTagihanPage(),
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
          "Tambah Tagihan",
        ),
      ),
            appBar: AppBar(
        title: const Text(
          "Pengelolaan Tagihan",
        ),
        backgroundColor:
            Colors.white,
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
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                  GridView.count(
  shrinkWrap: true,
  physics:
      const NeverScrollableScrollPhysics(),

  crossAxisCount: 2,

  crossAxisSpacing: 12,

  mainAxisSpacing: 12,

  childAspectRatio: 1.5,

  children: [

    buildStatCard(
      "Total Tagihan",
      NumberFormat.currency(
        locale: "id",
        symbol: "Rp ",
        decimalDigits: 0,
      ).format(totalTagihan),
    ),

    buildStatCard(
      "Terbayar",
      NumberFormat.currency(
        locale: "id",
        symbol: "Rp ",
        decimalDigits: 0,
      ).format(totalTerbayar),
    ),

    buildStatCard(
      "Belum Lunas",
      NumberFormat.currency(
        locale: "id",
        symbol: "Rp ",
        decimalDigits: 0,
      ).format(totalBelumLunas),
    ),

    buildStatCard(
      "Cicilan",
      totalCicilan.toString(),
    ),
  ],
),
const SizedBox(height: 20),

TextField(
  controller: searchController,
  onChanged: searchData,
  decoration: InputDecoration(
    prefixIcon: const Icon(
      Icons.search,
    ),
    hintText: "Cari NIM / Nama",
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(
        12,
      ),
    ),
  ),
),

const SizedBox(height: 12),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor:
          const Color(0xFF096430),
      foregroundColor:
          Colors.white,
      minimumSize:
          const Size.fromHeight(55),
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          12,
        ),
      ),
    ),
    onPressed: () async {

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const GenerateTagihanMassalPage(),
        ),
      );

      loadData();
    },
    icon: const Icon(
      Icons.receipt_long,
    ),
    label: const Text(
      "Generate Tagihan Massal",
    ),
  ),
),

const SizedBox(height: 16),

SingleChildScrollView(
  scrollDirection:
      Axis.horizontal,

  child: Row(
    children: [

      buildFilterChip(
        "Semua",
      ),

      buildFilterChip(
        "Lunas",
      ),

      buildFilterChip(
        "Cicil",
      ),

      buildFilterChip(
        "Belum Bayar",
      ),
    ],
  ),
),
const SizedBox(height: 16),

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

    return buildTagihanCard(
      item,
    );
  },
),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildStatCard(
  String title,
  String value,
) {
  return Container(
    padding:
        const EdgeInsets.all(16),

    decoration:
        BoxDecoration(
      color: Colors.white,

      borderRadius:
          BorderRadius.circular(
        16,
      ),
    ),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(title),

        const Spacer(),

        Text(
          value,
          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    ),
  );
}

Widget buildFilterChip(
  String label,
) {
  return Padding(
    padding:
        const EdgeInsets.only(
      right: 8,
    ),

    child: ChoiceChip(
      label: Text(label),

      selected:
          selectedFilter ==
              label,

      onSelected: (_) {
        filterData(label);
      },
    ),
  );
}

Widget buildTagihanCard(
  Tagihan item,
) {
  return Card(
    margin:
        const EdgeInsets.only(
      bottom: 12,
    ),

    child: ListTile(

      title: Text(
        namaMahasiswa[
                item.nim] ??
            "-",
      ),

      subtitle: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [

          Text(
            item.nim,
          ),

          Text(
            item.namaKategori,
          ),

          Text(
            NumberFormat.currency(
              locale: 'id',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(
              item.totalTagihan,
            ),
          ),
        ],
      ),

      trailing: Column(
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
    builder: (_) =>
        EditTagihanPage(
      data: item,
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

            onPressed: () {
              deleteData(
                item.idTagihan,
              );
            },
          ),
        ],
      ),
    ),
  );
}
    }