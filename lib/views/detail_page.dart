import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/favorite_controller.dart';
import '../models/show_model.dart';
import '../services/api_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  ShowModel? _show;
  bool _isLoading = true;
  String? _errorMessage;

  late final int _showId = Get.arguments as int;
  final FavoriteController _favController = Get.find<FavoriteController>();

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await ApiService.fetchShowDetail(_showId);
      setState(() {
        _show = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat detail show';
        _isLoading = false;
      });
    }
  }

  String _stripHtml(String html) => html.replaceAll(RegExp(r'<[^>]*>'), '').trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 60),
                      const SizedBox(height: 12),
                      Text(_errorMessage!, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadDetail,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final show = _show!;
    final summary = show.summary != null ? _stripHtml(show.summary!) : 'Tidak ada deskripsi.';
    final genresString = show.genres.isNotEmpty ? show.genres.join(', ') : '-';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              show.imageUrl != null
                  ? Image.network(
                      show.imageUrl!,
                      width: double.infinity,
                      height: 380,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          height: 380,
                          color: Colors.grey[850],
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.red),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        height: 280,
                        color: Colors.grey[850],
                        child: const Icon(Icons.broken_image, color: Colors.grey, size: 80),
                      ),
                    )
                  : Container(
                      height: 280,
                      color: Colors.grey[850],
                      child: const Icon(Icons.tv, color: Colors.grey, size: 80),
                    ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  show.name,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _infoChip(Icons.star, Colors.amber, show.rating != null ? '${show.rating} / 10' : 'N/A'),
                    if (show.status != null)
                      _infoChip(
                        show.status == 'Running' ? Icons.fiber_manual_record : Icons.stop_circle_outlined,
                        show.status == 'Running' ? Colors.green : Colors.grey,
                        show.status!,
                      ),
                    if (show.premiered != null)
                      _infoChip(Icons.calendar_today, Colors.red, show.premiered!),
                    if (show.network != null)
                      _infoChip(Icons.tv, Colors.blue, show.network!),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.category_outlined, color: Colors.red, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(genresString, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (show.url != null) {
                            final uri = Uri.parse(show.url!);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            } else {
                              Get.snackbar('Error', 'Tidak bisa membuka URL',
                                  backgroundColor: const Color(0xFF1A1A1A), colorText: Colors.white);
                            }
                          }
                        },
                        icon: const Icon(Icons.play_circle_outline),
                        label: const Text('Tonton'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Obx(() {
                      final isFav = _favController.isFavorite(show.id);
                      return ElevatedButton.icon(
                        onPressed: () => _favController.toggleFavorite(show),
                        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                        label: Text(isFav ? 'Disimpan' : 'Favorit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFav ? Colors.red[800] : Colors.grey[800],
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ringkasan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                const SizedBox(height: 10),
                Text(
                  summary,
                  style: const TextStyle(color: Colors.white70, height: 1.6, fontSize: 14),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}