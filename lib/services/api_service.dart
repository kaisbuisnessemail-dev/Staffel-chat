import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://79.72.67.156:8000';

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? params}) async {
    String url = '$baseUrl/api/$endpoint';
    if (params != null && params.isNotEmpty) {
      url += '?' + params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    }
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> upload(String endpoint, Map<String, dynamic> data, Map<String, String> files) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/$endpoint'));
    data.forEach((key, value) => request.fields[key] = value.toString());
    for (var entry in files.entries) {
      request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value));
    }
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    return jsonDecode(responseBody);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
