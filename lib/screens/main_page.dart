import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/pembayaran/pembayaran_page.dart';
import 'package:flutter_application_1/screens/ukt/ukt_page.dart';
import 'dashboard/dashboard.dart';
import 'mahasiswa/data_ukt_mahasiswa.dart';
import 'beasiswa/beasiswa_page.dart';
import 'mahasiswa_beasiswa/penerima_beasiswa_page.dart';
import 'tagihan/tagihan_page.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() =>
      _MainPageState();
}

class _MainPageState
    extends State<MainPage> {

  int currentIndex = 0;

  final List<Widget> pages = [
  const DashboardPage(),
  const DataUktMahasiswaPage(),
  const UktPage(),
  const BeasiswaPage(),
  const PenerimaBeasiswaPage(),
  const TagihanPage(),
  const PembayaranPage()
];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: pages[currentIndex],

     bottomNavigationBar: BottomNavigationBar(
  currentIndex: currentIndex,

  onTap: (index) {
    setState(() {
      currentIndex = index;
    });
  },

  type: BottomNavigationBarType.fixed,

  selectedItemColor: const Color(0xFF096430),

  unselectedItemColor: Colors.grey,

  selectedFontSize: 10,

  unselectedFontSize: 10,

  items: const [

    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.school_outlined),
      activeIcon: Icon(Icons.school),
      label: 'Mahasiswa',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.payments_outlined),
      activeIcon: Icon(Icons.payments),
      label: 'UKT',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.auto_awesome_outlined),
      activeIcon: Icon(Icons.auto_awesome),
      label: 'Beasiswa',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.group_outlined),
      activeIcon: Icon(Icons.group),
      label: 'Penerima',
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long_outlined),
      activeIcon: Icon(Icons.receipt_long),
      label: 'Tagihan',
    ),

    BottomNavigationBarItem(
      icon: Icon(
        Icons.account_balance_wallet_outlined,
      ),
      activeIcon: Icon(
        Icons.account_balance_wallet,
      ),
      label: 'Pembayaran',
    ),
  ],
),
    );
  }
    }