import 'package:get/get.dart';

import '../views/detail_page.dart';
import '../views/favorite_page.dart';
import '../views/home_page.dart';
import '../views/login_page.dart';
import '../views/main_page.dart';
import '../views/profile_page.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => const MainPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.FAVORITE,
      page: () => const FavoritePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfilePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.DETAIL,
      page: () => const DetailPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
