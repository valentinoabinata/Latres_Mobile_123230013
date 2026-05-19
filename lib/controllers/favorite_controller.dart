import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/favorite_show_model.dart';
import '../models/show_model.dart';

class FavoriteController extends GetxController {
  final RxList<FavoriteShowModel> favorites = <FavoriteShowModel>[].obs;
  late Box<FavoriteShowModel> _box;
  String _username = '';

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box<FavoriteShowModel>('favorites');
  }

  void loadForUser(String username) {
    _username = username;
    _loadFavorites();
  }

  void _loadFavorites() {
    // Kosongkan jika belum login
    if (_username.isEmpty) {
      favorites.clear();
      return;
    }
    // Filter favorit milik user ini
    final prefix = '$_username:';
    final items = _box.keys
        .where((k) => k.toString().startsWith(prefix))
        .map((k) => _box.get(k)!)
        .toList();
    favorites.assignAll(items);
  }

  // Key unik per user & show
  String _key(int id) => '$_username:$id';

  bool isFavorite(int id) => favorites.any((s) => s.id == id);

  void toggleFavorite(ShowModel show) {
    if (isFavorite(show.id)) {
      removeFavorite(show.id);
    } else {
      final favModel = FavoriteShowModel(
        id: show.id,
        name: show.name,
        imageUrl: show.imageUrl,
        rating: show.rating,
      );

      _box.put(_key(show.id), favModel);
      favorites.add(favModel);
      Get.snackbar(
        'Favorit',
        '${show.name} ditambahkan ke favorit',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: const Color(0xFFFFFFFF),
      );
    }
  }

  void removeFavorite(int id) {
    _box.delete(_key(id));
    favorites.removeWhere((s) => s.id == id);
  }
}
