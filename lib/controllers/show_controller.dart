import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/show_model.dart';
import '../services/api_service.dart';

class ShowController extends GetxController {
  final RxList<ShowModel> shows = <ShowModel>[].obs;
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
      // Gagal ambil data API
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
