import 'package:flutter/material.dart';
import '../core/api_service.dart';

class AdminProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _error = '';
  List<dynamic> _users = [];
  int _caretakerCount = 0;

  bool get isLoading => _isLoading;
  String get error => _error;
  List<dynamic> get users => _users;
  int get caretakerCount => _caretakerCount;

  Future<void> fetchSystemOverview() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await ApiService.getAllData();
      if (response.containsKey('error')) {
        _error = response['error'];
      } else {
        _users = response['users'] ?? [];
        _caretakerCount = _users.where((u) => u['role'] == 'caretaker').length;
      }
    } catch (e) {
      _error = 'Failed to load system overview';
    }

    _isLoading = false;
    notifyListeners();
  }
}
