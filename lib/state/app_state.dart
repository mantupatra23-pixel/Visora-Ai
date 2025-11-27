// lib/state/app_state.dart
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  final ApiService apiService;

  // Allow injecting ApiService (useful for tests or different envs)
  AppState({ApiService? apiService})
      : apiService = apiService ?? ApiService(baseUrl: 'https://visora-backend-v2.onrender.com');

  // Example state fields
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  // Example function that calls backend
  Future<void> pingServer() async {
    try {
      setLoading(true);
      final resp = await apiService.get('/health'); // adjust path as your backend exposes
      // handle resp (status, body)
    } catch (e) {
      // handle error
    } finally {
      setLoading(false);
    }
  }
}
