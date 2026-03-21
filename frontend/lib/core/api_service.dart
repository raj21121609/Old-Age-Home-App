import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiService {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:5000/api';
    return 'http://localhost:5000/api';
  }

  // HELPER: Handle HTTP Responses consistently
  static Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    try {
      final decoded = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
      } else {
        return {'error': decoded['error'] ?? 'Server Error: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'Failed to parse server response'};
    }
  }

  // HELPER: Handle Exceptions safely
  static Map<String, dynamic> _handleError(dynamic e) {
    return {'error': 'Network connection failed. Check server.'};
  }

  // --- AUTH --- //

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> register(String name, String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password, 'role': role}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // --- CARETAKER --- //

  static Future<Map<String, dynamic>> getAssignedElderly(int caretakerId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/caretaker/$caretakerId/elderly'));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> updateElderlyHealth(int elderlyId, String healthStatus, {String? report}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/caretaker/elderly/$elderlyId/health'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'health_status': healthStatus, 'health_report': report}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> addElderly(String name, int age, String healthStatus, int caretakerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/caretaker/elderly'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'age': age, 'health_status': healthStatus, 'caretaker_id': caretakerId}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // --- GOVERNMENT --- //

  static Future<Map<String, dynamic>> getAllElderly() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/government/elderly'));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> getReports() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/government/reports'));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> updateHomeStatus(int homeId, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/government/homes/$homeId/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // --- ADMIN --- //

  static Future<Map<String, dynamic>> getAllData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin/all'));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> deleteUser(int userId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/admin/users/$userId'));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }
}
