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
  static const aboutImagePath = "assets/images/About";
  static const homeImagePath = "assets/images/Home";
  static const otherImagePath = "assets/images/Other";
  static const quoteImagePath = "assets/images/Quote";
  static const shareImagePath = "assets/images/share";
  static const shayriBgImagePath = "assets/images/shayari_bg";
  static const allInOne = '$shayriBgImagePath/All In One.png';
  static const attitude = '$shayriBgImagePath/Attitude.png';
  static const bewafa = '$shayriBgImagePath/Bewafa.png';
  static const birthday = '$shayriBgImagePath/Birthday.png';
  static const twoLines = '$shayriBgImagePath/2 Lines.png';
  static const bestWishes = '$shayriBgImagePath/Best Wishes.png';
  static const christmas = '$shayriBgImagePath/Christmas.png';
  static const diwali = '$shayriBgImagePath/Diwali.png';
  static const friend = '$shayriBgImagePath/Friend.png';
  static const funny = '$shayriBgImagePath/Funny.png';
  static const ganesha = '$shayriBgImagePath/Ganesha.png';
  static const god = '$shayriBgImagePath/God.png';
  static const holi = '$shayriBgImagePath/Holi.png';
  static const independence = '$shayriBgImagePath/Independence.png';
  static const janmashtami = '$shayriBgImagePath/Janmashtami.png';
  static const sankranti = '$shayriBgImagePath/Sankranti.png';
  static const love = '$shayriBgImagePath/Love.png';
  static const morning = '$shayriBgImagePath/Morning.png';
  static const navratri = '$shayriBgImagePath/Navratri.png';
  static const newYear = '$shayriBgImagePath/New Year.png';
  static const night = '$shayriBgImagePath/Night.png';
  static const other = '$shayriBgImagePath/Other.png';
  static const republic = '$shayriBgImagePath/Republic.png';
  static const romantic = '$shayriBgImagePath/Romantic.png';
  static const royal = '$shayriBgImagePath/Royal.png';
  static const sad = '$shayriBgImagePath/Sad.png';
  static const valentine = '$shayriBgImagePath/Valentine.png';
  static const yaad = '$shayriBgImagePath/Yaad.png';
  static const arrowBackDark = '$otherImagePath/Back.png';
  static const arrowBackLight = '$otherImagePath/Back_White.png';
  static const arrowDownDark = '$otherImagePath/Down.png';
  static const baseColorLight = '$otherImagePath/baseColorLight.png';
  static const baseColorDark = '$otherImagePath/baseColorsDark.png';
  static const bgImageDark = '$otherImagePath/bgImageDark.png';
  static const bgImageLight = '$otherImagePath/bgImageLight.png';
  static const textColorDark = '$otherImagePath/textColorDark.png';
  static const textColorLight = '$otherImagePath/textColorLight.png';
  static const textSizeDark = '$otherImagePath/textSizeDark.png';
  static const textSizeLight = '$otherImagePath/textSizeLight.png';
  static const arrowDark = '$otherImagePath/arrowDark.png';
  static const arrowLight = '$otherImagePath/arrowLight.png';
  static const lightModeBg = '$homeImagePath/lightModeBg.png';
  static const darkModeBg = '$homeImagePath/darkModeBg.png';
  static const moreDark = '$homeImagePath/darkMore.png';
  static const moreLight = '$homeImagePath/lightMore.png';
  static const starDark = '$homeImagePath/starDark.png';
  static const starLight = '$homeImagePath/starLight.png';
  static const copy = '$quoteImagePath/Copy.png';
  static const copyWhite = '$quoteImagePath/Copy_White.png';
  static const favoriteLight = '$quoteImagePath/Favorite.png';
  static const favoriteLightFill = '$quoteImagePath/Favorite_Sel.png';
  static const favoriteDarkFill = '$quoteImagePath/Favorite_Sel_White.png';
  static const favoriteDark = '$quoteImagePath/Favorite_White.png';
  static const share = '$quoteImagePath/Share.png';
  static const nextLight = '$quoteImagePath/Next.png';
  static const nextDark = '$quoteImagePath/Next_White.png';
  static const shareWhite = '$quoteImagePath/Share_White.png';
  static const prevLight = '$quoteImagePath/Prev.png';
  static const prevDark = '$quoteImagePath/Prev_White.png';
  static const whatsAppLight = '$shareImagePath/whatsAppLight.png';
  static const whatsAppDark = '$shareImagePath/whatsAppDark.png';
  static const twitterLight = '$shareImagePath/twitterLight.png';
  static const twitterDark = '$shareImagePath/twitterDark.png';
  static const sharePostLight = '$shareImagePath/sharePostLight.png';
  static const sharePostDark = '$shareImagePath/sharePostDark.png';
  static const instaLight = '$shareImagePath/instaLight.png';
  static const instaDark = '$shareImagePath/instaDark.png';
  static const homeDark = '$shareImagePath/homeDark.png';
  static const homeLight = '$shareImagePath/homeLight.png';
  static const facebookLight = '$shareImagePath/facebookLight.png';
  static const facebookDark = '$shareImagePath/facebookDark.png';
  static const appIcon = '$homeImagePath/App_Icon.png';
  static const linkedinDark = '$aboutImagePath/linkedinDark.png';
  static const linkedinLight = '$aboutImagePath/linkedinLight.png';
  static const fbDark = '$aboutImagePath/fbDark.png';
  static const fbLight = '$aboutImagePath/fbLight.png';
  static const instagramDark = '$aboutImagePath/instagramDark.png';
  static const instagramLight = '$aboutImagePath/instagramLight.png';
  static const xDark = '$aboutImagePath/xDark.png';
  static const xLight = '$aboutImagePath/xLight.png';
}
