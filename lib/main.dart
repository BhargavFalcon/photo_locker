import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gdpr_dialog_flutter/gdpr_dialog_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_locker/adService/ad_service.dart';
import 'package:photo_locker/constants/app_module.dart';
import 'package:get_it/get_it.dart';
import 'app/routes/app_pages.dart';

AdService adService = AdService();
GetStorage box = GetStorage();
final getIt = GetIt.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await GdprDialogFlutter.instance
      .showDialog(isForTest: false, testDeviceId: '')
      .then((onValue) {
    print('result === $onValue');
  });
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
      testDeviceIds: kDebugMode
          ? [
              "ad7a368b8ae5583321da7534d9066c2d",
            ]
          : [],
    ),
  );
  setUp();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    ),
  );
}
