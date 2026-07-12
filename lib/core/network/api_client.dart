import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
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

  // Helper method to dynamically generate headers with the active JWT token
  static Map<String, String> _getHeaders() {
    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Grab the current active Supabase session
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      // Attach the JWT token inside the Authorization header
      headers["Authorization"] = "Bearer ${session.accessToken}";
    }

    return headers;
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final uri = Uri.parse("${AppConfig.baseUrl}$endpoint");

    try {
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

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
      final response = await http
          .post(
        uri,
        headers: _getHeaders(),
        body: jsonEncode(body),
      )
          .timeout(timeoutDuration);

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException("Request timed out. Please try again.");
    } catch (e) {
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
