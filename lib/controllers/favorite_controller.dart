import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/favorite_show_model.dart';
import '../models/show_model.dart';

class FavoriteController extends GetxController {
  final RxList<FavoriteShowModel> favorites = <FavoriteShowModel>[].obs;
  late Box<FavoriteShowModel> _box;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box<FavoriteShowModel>('favorites');
  }

  void loadFavorites() {
    final items = _box.values.toList();
    favorites.assignAll(items);
  }

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

      _box.put(show.id, favModel);
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
    _box.delete(id);
    favorites.removeWhere((s) => s.id == id);
  }
}
