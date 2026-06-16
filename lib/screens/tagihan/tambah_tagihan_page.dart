import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/mahasiswa_controller.dart';
import '../../controllers/tahun_akademik_controller.dart';
import '../../controllers/mahasiswa_beasiswa_controller.dart';

import '../../controllers/tagihan_controller.dart';

import '../../services/ukt_service.dart';
import '../../services/status_tagihan_service.dart';

import '../../models/tahun_akademik.dart';
import '../../models/ukt_kategori.dart';
import '../../models/status_tagihan.dart';

class TambahTagihanPage
    extends StatefulWidget {

  const TambahTagihanPage({
    super.key,
  });

  @override
  State<TambahTagihanPage>
      createState() =>
          _TambahTagihanPageState();
}

class _TambahTagihanPageState
    extends State<
        TambahTagihanPage> {

  final formKey =
      GlobalKey<FormState>();

  final nimController =
      TextEditingController();

  final namaController =
      TextEditingController();

  final totalController =
      TextEditingController();

  final mahasiswaController =
      MahasiswaController();

  final tahunController =
      TahunAkademikController();

  final beasiswaController =
      MahasiswaBeasiswaController();

  final tagihanController =
      TagihanController();

  final kategoriService =
      UktService();

  final statusService =
      StatusTagihanService();

  List<TahunAkademik>
      listTahun = [];

  List<UktKategori>
      listKategori = [];

  List<StatusTagihan>
      listStatus = [];

  bool isLoading = true;

  bool isPenerimaBeasiswa =
      false;

  int? idMb;

  String? selectedTahun;

  int? selectedKategori;

  int? selectedStatus;

  DateTime? jatuhTempo;

    @override
  void initState() {
    super.initState();
    loadData();
  }
  Future<void> loadData() async {

  final tahun =
      await tahunController
          .getTahunAkademik();

  final kategoriRaw =
    await kategoriService
        .getUktKategori();

  final kategori =
    kategoriRaw
        .map<UktKategori>(
          (e) =>
              UktKategori
                  .fromJson(e),
        )
        .toList();

  final statusRaw =
    await statusService
        .getStatusTagihan();

final status =
    statusRaw
        .map<StatusTagihan>(
          (e) => StatusTagihan.fromJson(e),
        )
        .toList();

  setState(() {

    listTahun = tahun;

    listKategori = kategori;

    listStatus = status;

    isLoading = false;

  });
}

Future<void> cariMahasiswa() async {

  if (nimController.text
      .trim()
      .isEmpty) {
    return;
  }

  try {

    final mahasiswa =
        await mahasiswaController
            .getMahasiswa(
      nimController.text,
    );

    namaController.text =
        mahasiswa["NAMA"] ?? "";

    final penerima =
        await beasiswaController
            .getData();

    final dataBeasiswa =
        penerima.where(
      (e) =>
          e["NIM"] ==
          nimController.text,
    ).toList();

    if (dataBeasiswa
        .isNotEmpty) {

      isPenerimaBeasiswa =
          true;

      idMb =
          dataBeasiswa.first[
              "ID_MB"];

      totalController.text =
          "0";

      selectedStatus = 2;

    } else {

      isPenerimaBeasiswa =
          false;

      idMb = null;
    }

    if (mounted) {
      setState(() {});
    }

  } catch (_) {

    namaController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          "Mahasiswa tidak ditemukan",
        ),
      ),
    );
  }
}

Future<void> simpan() async {

  if (!formKey.currentState!
      .validate()) {
    return;
  }

  final result =
      await tagihanController
          .createTagihan(

    nim:
        nimController.text,

    idTahunAkademik:
        selectedTahun!,

    idUktKategori:
        selectedKategori!,

    idStatusTagihan:
        selectedStatus!,

    idMb: idMb,

    jatuhTempo:
        DateFormat(
      'yyyy-MM-dd',
    ).format(
      jatuhTempo!,
    ),
  );

  if (!mounted) return;

  if (result) {

    Navigator.pop(
      context,
      true,
    );

  } else {

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content: Text(
          "Gagal menyimpan",
        ),
      ),
    );
  }
}

@override
Widget build(
  BuildContext context,
) {

  if (isLoading) {
    return const Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(),
      ),
    );
  }

  return Scaffold(
    appBar: AppBar(
  title: const Text(
    "Tambah Tagihan",
  ),
),

body: Form(
  key: formKey,

  child:
      SingleChildScrollView(

    padding:
        const EdgeInsets.all(
      16,
    ),

    child: Column(
      children: [
        TextFormField(
  controller:
      nimController,

  decoration:
      InputDecoration(
    labelText:
        "NIM Mahasiswa",

    suffixIcon:
        IconButton(
      icon:
          const Icon(
        Icons.search,
      ),
      onPressed:
          cariMahasiswa,
    ),
  ),
),

const SizedBox(height: 16),

TextFormField(
  controller:
      namaController,

  readOnly: true,

  decoration:
      const InputDecoration(
    labelText:
        "Nama Mahasiswa",
  ),
),

if (isPenerimaBeasiswa)

Container(
  margin:
      const EdgeInsets.only(
    top: 16,
  ),

  padding:
      const EdgeInsets.all(
    12,
  ),

  decoration:
      BoxDecoration(
    color:
        Colors.green.shade50,
    borderRadius:
        BorderRadius.circular(
      12,
    ),
  ),

  child: const Row(
    children: [

      Icon(
        Icons.info,
        color: Colors.green,
      ),

      SizedBox(width: 8),

      Expanded(
        child: Text(
          "Mahasiswa penerima beasiswa. Tagihan otomatis Rp 0",
        ),
      ),
    ],
  ),
),

DropdownButtonFormField<
    String>(
  initialValue:
      selectedTahun,

  decoration:
      const InputDecoration(
    labelText:
        "Tahun Akademik",
  ),

  items:
      listTahun.map(
    (e) {

      return DropdownMenuItem(
        value:
            e.id.toString(),

        child:
            Text(e.nama),
      );
    },
  ).toList(),

  onChanged: (v) {

    setState(() {
      selectedTahun = v;
    });

  },
),

DropdownButtonFormField<
    int>(
  initialValue:
      selectedKategori,

  decoration:
      const InputDecoration(
    labelText:
        "Kategori UKT",
  ),

  items:
      listKategori.map(
    (e) {

      return DropdownMenuItem(
        value: e.idUktKategori,

        child: Text(
          e.namaKategori,
        ),
      );
    },
  ).toList(),

  onChanged: (v) {

    selectedKategori = v;

    final kategori =
        listKategori.firstWhere(
      (e) => e.idUktKategori == v,
    );

    if (!isPenerimaBeasiswa) {

      totalController.text =
          kategori.nominal
              .toStringAsFixed(
        0,
      );
    }

    setState(() {});
  },
),
TextFormField(
  controller:
      totalController,

  readOnly: true,

  decoration:
      const InputDecoration(
    labelText:
        "Total Tagihan",
    prefixText: "Rp ",
  ),
),

ListTile(
  title: Text(
    jatuhTempo == null
        ? "Pilih Jatuh Tempo"
        : DateFormat(
            'dd MMM yyyy',
          ).format(
            jatuhTempo!,
          ),
  ),

  trailing:
      const Icon(
    Icons.calendar_today,
  ),

  onTap: () async {

    final date =
        await showDatePicker(
      context: context,

      firstDate:
          DateTime.now(),

      lastDate:
          DateTime(2030),

      initialDate:
          DateTime.now(),
    );

    if (date != null) {

      setState(() {
        jatuhTempo = date;
      });
    }
  },
),

DropdownButtonFormField<
    int>(
  initialValue:
      selectedStatus,

  decoration:
      const InputDecoration(
    labelText:
        "Status Tagihan",
  ),

  items:
      listStatus.map(
    (e) {

      return DropdownMenuItem(
        value:
            e.idStatusTagihan,

        child:
            Text(
          e.namaStatusTagihan,
        ),
      );
    },
  ).toList(),

  onChanged: (v) {

    setState(() {
      selectedStatus = v;
    });

  },
),

const SizedBox(height: 24),

SizedBox(
  width: double.infinity,

  height: 50,

  child:
      ElevatedButton(

    onPressed: simpan,

    child: const Text(
      "Simpan Tagihan",
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