import 'package:get/get.dart';

import '../modules/change_passcode_screen/bindings/change_passcode_screen_binding.dart';
import '../modules/change_passcode_screen/views/change_passcode_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/lock_screen/bindings/lock_screen_binding.dart';
import '../modules/lock_screen/views/lock_screen_view.dart';
import '../modules/setting_screen/bindings/setting_screen_binding.dart';
import '../modules/setting_screen/views/setting_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOCK_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOCK_SCREEN,
      page: () => const LockScreenView(),
      binding: LockScreenBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_SCREEN,
      page: () => const SettingScreenView(),
      binding: SettingScreenBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSCODE_SCREEN,
      page: () => const ChangePasscodeScreenView(),
      binding: ChangePasscodeScreenBinding(),
    ),
  ];
}
