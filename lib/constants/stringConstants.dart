import 'dart:io';

class PrefConstant {
  static const isAdRemoved = "isAdRemoved";
  static const isDarkTheme = "isDarkTheme";
  static const isNotificationOn = "isNotificationOn";
  static const notificationPage = "notificationPage";
  static const day = "day";
  static const month = "month";
  static const year = "year";
  static const notificationDate = "notificationDate";
  static const adCount = "adCount";
  static String bannerId = (Platform.isAndroid)
      ? "ca-app-pub-3510832308267643/1315376312"
      : "ca-app-pub-3510832308267643/7866097010";
  static String interAdId = (Platform.isAndroid)
      ? "ca-app-pub-3510832308267643/9515733294"
      : "ca-app-pub-3510832308267643/6553015344";

  static String shareText =
      "Find & Share the most beautiful and romantic Love Shayaris. Download Love Shayri app now: ${(Platform.isAndroid) ? "https://play.google.com/store/apps/details?id=com.falconapps.loveshayari" : "https://itunes.apple.com/us/app/id1644894456?ls=1&mt=8"}";
}

class ArgumentConstants {
  static const isLockSet = "isLockSet";
  static const setLock = "setLock";
  static const previewType = "previewType";
  static const currentIndex = "currentIndex";
  static const bioMetricTypeList = "bioMetricTypeList";
  static const albumList = "albumList";
  static const albumModel = "albumModel";
}

class ImageConstant {
  static const splashPath = "assets/Splash/";
  static const assetsPath = "assets/";
  static const String homePath = "assets/Home/";
  static const String detailsScreenPath = "assets/Detail Screen/";

  static const String Splash = "${splashPath}Splash_X.png";
  static const String bg = "${assetsPath}Bg.png";
  static const String appLogo = "${assetsPath}App_Logo.png";
  static const String albumDemo = "${homePath}Album_Demo.png";
  static const String minus = "${homePath}Minus.png";
  static const String photoTab = "${detailsScreenPath}Tab_Photo.png";
  static const String videoTab = "${detailsScreenPath}Tab_Video.png";
  static const String back = "${detailsScreenPath}Back.png";
}
