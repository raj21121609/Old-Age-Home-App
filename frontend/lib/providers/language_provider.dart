import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  bool _isHindi = false;
  
  bool get isHindi => _isHindi;

  void setHindi(bool value) {
    if (_isHindi != value) {
      _isHindi = value;
      notifyListeners();
    }
  }

  // Simple string translation helper taking the English and Hindi exact match
  String t(String en, String hi) => _isHindi ? hi : en;
}
