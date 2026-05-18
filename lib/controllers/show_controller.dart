import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';

class ShowController extends GetxController {
  final RxList<Map<String, dynamic>> shows = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShows();
  }

  Future<void> fetchShows() async {
    isLoading.value = true;
    try {
      final data = await ApiService.fetchShows();
      shows.assignAll(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data. Cek koneksi internet.',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
