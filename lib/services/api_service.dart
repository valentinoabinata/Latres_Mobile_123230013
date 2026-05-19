import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/show_model.dart';

class ApiService {
  static const String _baseUrl = 'https://api.tvmaze.com';

  static Future<List<ShowModel>> fetchShows() async {
    final response = await http.get(Uri.parse('$_baseUrl/shows'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ShowModel.fromJson(json)).toList();
    }
    throw Exception('Gagal mengambil data shows: ${response.statusCode}');
  }

  static Future<ShowModel> fetchShowDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/shows/$id'));
    if (response.statusCode == 200) {
      return ShowModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Gagal mengambil detail show: ${response.statusCode}');
  }
}
