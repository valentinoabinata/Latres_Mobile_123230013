import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.tvmaze.com';

  static Future<List<Map<String, dynamic>>> fetchShows() async {
    final response = await http.get(Uri.parse('$_baseUrl/shows'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Gagal mengambil data shows: ${response.statusCode}');
  }

  static Future<Map<String, dynamic>> fetchShowDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/shows/$id'));
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(response.body));
    }
    throw Exception('Gagal mengambil detail show: ${response.statusCode}');
  }
}
