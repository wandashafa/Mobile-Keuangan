import 'package:flutter/material.dart';
import 'screens/auth/login.dart';
import 'screens/main_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/constants/api_constants.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await ApiConstants.checkVpsStatus();

  runApp(const SimpaduApp());
}

class SimpaduApp extends StatelessWidget {
  const SimpaduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIMPADU',

      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const MainPage(),
      },
    );
  }
}