import 'package:http/http.dart' as http;
import 'dart:async';

class ApiConstants {
  static const String _mainVpsUrl = 'https://keuangan4c06.vps-poliban.my.id/api';
  static const String _adminBackupUrl = 'https://api-admin-4c.rifkiaja.my.id:9002/api';
  static const String _mahasiswaBackupUrl = 'https://api-mahasiswa-4c.rifkiaja.my.id:9003/api';

  static bool isVpsDown = false;

  static Future<void> checkVpsStatus() async {
    try {
      // Fast timeout ping to the main VPS
      final response = await http.get(Uri.parse('$_mainVpsUrl/ping')).timeout(const Duration(seconds: 3));
      // If we get a 502 Bad Gateway or 503, the VPS is down
      if (response.statusCode >= 500) {
        isVpsDown = true;
      } else {
        isVpsDown = false;
      }
    } catch (e) {
      // SocketException or TimeoutException implies VPS is down
      isVpsDown = true;
    }
  }

  static String get adminBaseUrl => isVpsDown ? _adminBackupUrl : _mainVpsUrl;
  static String get mahasiswaBaseUrl => isVpsDown ? _mahasiswaBackupUrl : _mainVpsUrl;
  
  // Login specifically routes to admin
  static String get login => '$adminBaseUrl/auth/login';
}