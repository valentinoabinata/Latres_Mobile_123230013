// flutter pub run build_runner build
// dart run build_runner build --delete-conflicting-outputs

import 'package:hive/hive.dart';

part 'favorite_show_model.g.dart';

@HiveType(typeId: 0)
class FavoriteShowModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? imageUrl;

  @HiveField(3)
  final double? rating;

  FavoriteShowModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.rating,
  });
}