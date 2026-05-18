import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

class FavoriteController extends GetxController {
  final RxList<Map<String, dynamic>> favorites = <Map<String, dynamic>>[].obs;
  late Box _box;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box('favorites');
    _loadFavorites();
  }

  void _loadFavorites() {
    final items = _box.values
        .map((e) => Map<String, dynamic>.from(jsonDecode(e as String)))
        .toList();
    favorites.assignAll(items);
  }

  bool isFavorite(int id) => favorites.any((s) => s['id'] == id);

  void toggleFavorite(Map<String, dynamic> show) {
    if (isFavorite(show['id'] as int)) {
      removeFavorite(show['id'] as int);
    } else {
      _box.put(show['id'].toString(), jsonEncode(show));
      favorites.add(show);
      Get.snackbar(
        'Favorit',
        '${show['name']} ditambahkan ke favorit',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  void removeFavorite(int id) {
    _box.delete(id.toString());
    favorites.removeWhere((s) => s['id'] == id);
  }
}
