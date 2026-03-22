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
      // Fetching all data provides the necessary foundation for advanced analytics requested
      final response = await ApiService.getAllData();
      if (response.containsKey('error')) {
        _error = response['error'];
      } else {
        final users = response['users'] ?? [];
        final elderly = response['elderly'] ?? [];
        
        _homes = users.where((u) => u['role'] == 'caretaker').toList();
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

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Add locally to the state
    _homes.add({
      'name': homeData['name'],
      'location': homeData['location'],
      'city': homeData['district'], // Map district to city or keeping it
      'status': 'pending',
      'email': '',
      'role': 'caretaker',
      'residents_count': int.tryParse(homeData['residents'] ?? '0') ?? 0,
      'pending_count': 0,
      'alerts_count': 0,
    });
    
    _isLoading = false;
    notifyListeners();
  }
}
