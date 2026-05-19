import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/show_controller.dart';
import '../models/show_model.dart';
import '../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ShowController _showController = Get.put(ShowController());
  final FavoriteController _favController = Get.find<FavoriteController>();
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skuy Nonton!'),
        actions: [
          Obx(() => _showController.isLoading.value
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _showController.fetchShows,
                  tooltip: 'Refresh',
                )),
        ],
      ),
      body: Obx(() {
        if (_showController.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.red),
                SizedBox(height: 16),
                Text('Memuat data...', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        if (_showController.shows.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.tv_off, color: Colors.grey, size: 60),
                const SizedBox(height: 16),
                const Text('Tidak ada data', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _showController.fetchShows,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Obx(() => RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16),
                      children: [
                        const TextSpan(text: 'Halo, ', style: TextStyle(color: Colors.white70)),
                        TextSpan(
                          text: _authController.username.value.isNotEmpty
                              ? _authController.username.value
                              : 'User',
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' 👋', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  )),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.58,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _showController.shows.length,
                itemBuilder: (context, index) {
                  final show = _showController.shows[index];
                  return _ShowCard(show: show, favController: _favController);
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ShowCard extends StatelessWidget {
  final ShowModel show;
  final FavoriteController favController;

  const _ShowCard({required this.show, required this.favController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.DETAIL, arguments: show.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: show.imageUrl != null
                    ? Image.network(
                        show.imageUrl!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: Colors.grey[850],
                            child: const Center(
                              child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[850],
                          child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                        ),
                      )
                    : Container(
                        color: Colors.grey[850],
                        child: const Icon(Icons.tv, color: Colors.grey, size: 50),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            show.rating != null ? show.rating.toString() : 'N/A',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      Obx(() => GestureDetector(
                            onTap: () => favController.toggleFavorite(show),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                favController.isFavorite(show.id) ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}