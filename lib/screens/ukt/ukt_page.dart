import 'package:flutter/material.dart';

import '../../controllers/ukt_controller.dart';
import '../../models/ukt_kategori.dart';
import '../../services/data_ukt_service.dart';
import 'ukt_tambah_kategori.dart';
import 'ukt_edit_kategori.dart';

class UktPage extends StatefulWidget {
  const UktPage({super.key});

  @override
  State<UktPage> createState() => _UktPageState();
}

class _UktPageState extends State<UktPage> {
  final UktController controller = UktController();

  final TextEditingController searchController =
      TextEditingController();

  List<UktKategori> kategoriList = [];
  List<UktKategori> filteredList = [];
  List tahunAkademik = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final result =
    await controller.getKategori();

final tahun =
    await DataUktService.getTahun();

setState(() {
  kategoriList = result;
  filteredList = result;
  tahunAkademik = tahun;
  isLoading = false;
});
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchKategori(String keyword) {
    setState(() {
      filteredList = kategoriList
          .where(
            (item) => item.namaKategori
                .toLowerCase()
                .contains(
                  keyword.toLowerCase(),
                ),
          )
          .toList();
    });
  }

  String formatRupiah(double nominal) {
    return "Rp ${nominal.toInt()}";
  }

  String getNamaTahun(int id) {
  final data = tahunAkademik.firstWhere(
    (e) =>
        e['id_tahun_akademik']
            .toString() ==
        id.toString(),
    orElse: () => {},
  );

  return data[
          'nama_tahun_akademik'] ??
      '-';
}

  Future<void> hapusKategori(
      UktKategori kategori) async {
    final result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Data"),
        content: Text(
          "Hapus ${kategori.namaKategori} ?",
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

    if (result == true) {
      await controller.deleteKategori(
        kategori.idUktKategori,
      );

      loadData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Kategori berhasil dihapus"),
        ),
      );
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
        centerTitle: false,
        title: const Text(
          "SIMPADU",
          style: TextStyle(
            color: Color(0xff096430),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    "Total Kategori",
                    kategoriList.length.toString(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
  "Tahun Akademik",
  kategoriList.isEmpty
      ? "-"
      : getNamaTahun(
          kategoriList.first
              .idTahunAkademik,
        ),
),
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: searchController,
              onChanged: searchKategori,
              decoration: InputDecoration(
                hintText:
                    "Cari kategori UKT...",
                prefixIcon:
                    const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xff096430,
                  ),
                  foregroundColor:
                      Colors.white,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text(
                  "Tambah UKT Baru",
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const UktTambahKategoriPage(),
                    ),
                  );

                  loadData();
                },
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Daftar Kategori UKT",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (isLoading)
              const Padding(
                padding:
                    EdgeInsets.all(40),
                child: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              )
            else if (filteredList.isEmpty)
              const Center(
                child: Padding(
                  padding:
                      EdgeInsets.all(24),
                  child: Text(
                    "Data tidak ditemukan",
                  ),
                ),
              )
            else
              ...filteredList.map(
                (item) =>
                    _buildCard(item),
              ),
          ],
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
          Text(
            title,
            style:
                const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style:
                const TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      UktKategori item) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration:
                BoxDecoration(
              color: Colors.green
                  .shade100,
              shape:
                  BoxShape.circle,
            ),
            child: const Icon(
              Icons.payments,
              color: Colors.green,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  "ID : ${item.idUktKategori}",
                  style:
                      const TextStyle(
                    color:
                        Colors.grey,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(
                    height: 4),

                Text(
                  "Jurusan : ${item.idJurusan}",
                  style:
                      const TextStyle(
                    color: Color(
                        0xff096430),
                    fontSize: 12,
                  ),
                ),

                const SizedBox(
                    height: 4),

                Text(
                  item.namaKategori,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight
                            .bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                    height: 4),

                Text(
                  formatRupiah(
                    item.nominal,
                  ),
                  style:
                      const TextStyle(
                    color: Color(
                        0xff096430),
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Color(
                    0xff096430,
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          UktEditKategoriPage(
                        kategori: item,
                      ),
                    ),
                  );

                  loadData();
                },
              ),

              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () =>
                    hapusKategori(
                  item,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}