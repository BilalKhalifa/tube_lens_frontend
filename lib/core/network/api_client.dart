import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../app_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return message;
  }
}

class ApiClient {
  static const Duration timeoutDuration = Duration(seconds: 20);

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final uri = Uri.parse("${AppConfig.baseUrl}$endpoint");

    try {
      print("🌍 GET Calling: $uri");

      final response = await http
          .get(uri)
          .timeout(timeoutDuration);

      print("✅ GET Status: ${response.statusCode}");
      print("📥 GET Response: ${response.body}");

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException("Request timed out. Please try again.");
    } catch (e) {
      throw ApiException("Network error: $e");
    }
  }

  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {

    final uri = Uri.parse("${AppConfig.baseUrl}$endpoint");

    try {
      print("🔥 POST Calling: $uri");
      print("📦 POST Body: $body");

      final response = await http
          .post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      )
          .timeout(timeoutDuration);

      print("✅ POST Status: ${response.statusCode}");
      print("📥 POST Response: ${response.body}");

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException("Request timed out. Please try again.");
    } catch (e) {
      print("❌ Network Error: $e");
      throw ApiException("Network error: $e");
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else {
      throw ApiException(
        decoded["message"] ?? "Something went wrong",
        statusCode: response.statusCode,
      );
    }
  }
}
