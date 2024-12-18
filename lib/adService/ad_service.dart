import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/main.dart';

class AdService {
  InterstitialAd? interstitialAds;
  void showInterstitialAd({VoidCallback? onAdDismissed}) {
    interstitialAds?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) =>
          print('Ad showed fullscreen content.'),
      onAdDismissedFullScreenContent: (ad) {
        onAdDismissed?.call();
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
        interstitialAds?.dispose();
        loadInterstitialAd();
        print('Ad dismissed fullscreen content.');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('Ad failed to show fullscreen content: $error');
      },
    );
    if (box.read(ArgumentConstants.isAdRemoved) ?? false) {
      onAdDismissed?.call();
      return;
    }

    interstitialAds?.show().then((value) =>
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []));
    if (interstitialAds == null) {
      loadInterstitialAd();
      onAdDismissed?.call();
    }
  }

  loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: (Platform.isIOS)
          ? "ca-app-pub-3113322998231310/1205733447"
          : "ca-app-pub-3510832308267643/4279349063",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAds = ad;
          print("InterstitialAd loaded.");
        },
        onAdFailedToLoad: (error) {
          print('InterstitialAd failed to load: $error');
          Future.delayed(Duration(seconds: 5), () {
            loadInterstitialAd();
          });
        },
      ),
    );
  }
}
