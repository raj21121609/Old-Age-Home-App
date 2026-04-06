import 'package:flutter/material.dart';
import '../core/api_service.dart';

class GovernmentProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _error = '';
  List<dynamic> _homes = [];
  int _totalResidents = 0;
  int _highRiskCount = 0;

  bool get isLoading => _isLoading;
  String get error => _error;
  List<dynamic> get homes => _homes;
  int get totalResidents => _totalResidents;
  int get highRiskCount => _highRiskCount;

  Future<void> fetchDashboardAnalytics() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await ApiService.getAllData();
      if (response.containsKey('error')) {
        _error = response['error'];
      } else {
        final elderly = response['elderly'] ?? [];
        _homes = response['homes'] ?? [];
        _totalResidents = elderly.length;
        _highRiskCount = elderly.where((e) => e['health_status']?.toLowerCase() == 'critical').length;
      }
    } catch (e) {
      _error = 'Failed to load analytics';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHome(Map<String, dynamic> homeData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.addHome({
        'name': homeData['name'],
        'location': homeData['location'],
        'district': homeData['district'],
        'residents': int.tryParse(homeData['residents'] ?? '0') ?? 0,
      });

      if (response.containsKey('error')) {
        _error = response['error'];
      } else {
        // Refresh the list
        await fetchDashboardAnalytics();
      }
    } catch (e) {
      _error = 'Failed to add home';
    }
    
    _isLoading = false;
    notifyListeners();
  }
}
