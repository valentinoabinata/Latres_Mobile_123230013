import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_routes.dart';
import 'favorite_controller.dart';

class AuthController extends GetxController {
  final RxString username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? '';
    // Load favorit jika sudah login
    if (username.value.isNotEmpty) {
      Get.find<FavoriteController>().loadForUser(username.value);
    }
  }

  Future<bool> login(String inputUsername, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // Simpan sesi login
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', inputUsername);
    username.value = inputUsername;
    Get.find<FavoriteController>().loadForUser(inputUsername);
    Get.offAllNamed(Routes.MAIN);
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Hapus sesi & bersihkan data
    await prefs.remove('isLoggedIn');
    await prefs.remove('username');
    Get.find<FavoriteController>().loadForUser('');
    username.value = '';
    Get.offAllNamed(Routes.LOGIN);
  }
}
