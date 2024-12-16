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
      "Keep secure your photos & videos with Photo Locker,Download now ${(Platform.isAndroid) ? "https://play.google.com/store/apps/details?id=com.falconapps.loveshayari" : "https://itunes.apple.com/us/app/id1343665010?ls=1&mt=8"}";
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
  static const String settings = "assets/Settings/";

  static const String Splash = "${splashPath}Splash_X.png";
  static const String bg = "${assetsPath}Bg.png";
  static const String appLogo = "${assetsPath}App_Logo.png";
  static const String albumDemo = "${homePath}Album_Demo.png";
  static const String minus = "${homePath}Minus.png";
  static const String photoTab = "${detailsScreenPath}Tab_Photo.png";
  static const String videoTab = "${detailsScreenPath}Tab_Video.png";
  static const String back = "${detailsScreenPath}Back.png";
  static const String premium = "${settings}Premium.png";
  static const String passcode = "${settings}Passcode.png";
  static const String contacts = "${settings}Contacts.png";
  static const String help = "${settings}Help.png";
  static const String facebook = "${settings}Facebook.png";
  static const String twitter = "${settings}Twitter.png";
  static const String share = "${settings}Share_Settings.png";
  static const String addGallery = "${detailsScreenPath}Add_Photo.png";
  static const String addCamera = "${detailsScreenPath}Add_Video.png";

}
