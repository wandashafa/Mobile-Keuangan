import '../services/dashboard_service.dart';

class DashboardController {
  final DashboardService _service =
      DashboardService();

  Future<Map<String, dynamic>> getData() async {
    try {
      return await _service.getDashboardData();
    } catch (e) {
      throw Exception(
        'Gagal mengambil data dashboard: $e',
      );
    }
  }
}