import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

class FavoriteController extends GetxController {
  final RxList<Map<String, dynamic>> favorites = <Map<String, dynamic>>[].obs;
  late Box _box;
  String _username = '';

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box('favorites');
  }

  void loadForUser(String username) {
    _username = username;
    _loadFavorites();
  }

  void _loadFavorites() {
    if (_username.isEmpty) {
      favorites.clear();
      return;
    }
    final prefix = '$_username:';
    final items = _box.keys
        .where((k) => k.toString().startsWith(prefix))
        .map((k) => Map<String, dynamic>.from(jsonDecode(_box.get(k) as String)))
        .toList();
    favorites.assignAll(items);
  }

  String _key(int id) => '$_username:$id';

  bool isFavorite(int id) => favorites.any((s) => s['id'] == id);

  void toggleFavorite(Map<String, dynamic> show) {
    if (isFavorite(show['id'] as int)) {
      removeFavorite(show['id'] as int);
    } else {
      _box.put(_key(show['id'] as int), jsonEncode(show));
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
    _box.delete(_key(id));
    favorites.removeWhere((s) => s['id'] == id);
  }
}
