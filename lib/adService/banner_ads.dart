import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/main.dart';

class BannerAdsWidget extends StatefulWidget {
  @override
  State<BannerAdsWidget> createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  BannerAd? bannerAd;
  bool isBannerAdLoaded = false;
  bool doYouWantSmallNativeAd = false;
  bool isAdRemoved = false;

  @override
  void initState() {
    super.initState();
    isAdRemoved = box.read(ArgumentConstants.isAdRemoved) ?? false;
    box.listenKey(
      ArgumentConstants.isAdRemoved,
      (value) {
        if (mounted) {
          setState(() {
            isAdRemoved = value ?? false;
            print("isAdRemoved : $isAdRemoved");
          });
        }
      },
    );
    loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: isBannerAdLoaded && !isAdRemoved
          ? SizedBox(
              width: bannerAd!.size.width.toDouble(),
              height: bannerAd!.size.height.toDouble(),
              child: AdWidget(
                ad: bannerAd!,
              ),
            )
          : SizedBox(
              height: (isAdRemoved) ? 0 : 60,
            ),
    );
  }

  void loadBannerAd() async {
    var size = await anchoredAdaptiveBannerAdSize();
    if (!mounted) return;

    bannerAd = BannerAd(
      adUnitId: (Platform.isIOS)
          ? "ca-app-pub-3113322998231310/4653279933"
          : "ca-app-pub-3940256099942544/9214589741",
      size: size ?? AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return; // Ensure widget is still in the tree
          print("Banner Ad Loaded");
          setState(() {
            isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print("Banner Failed to Load : ${error.message}");
          ad.dispose();
          Future.delayed(Duration(seconds: 5), () {
            if (mounted) {
              loadBannerAd(); // Retry only if widget is still mounted
            }
          });
        },
      ),
      request: AdRequest(),
    );
    bannerAd!.load();
  }

  @override
  void dispose() {
    bannerAd?.dispose(); // Ensure null safety
    super.dispose();
  }
}

Future<AnchoredAdaptiveBannerAdSize?> anchoredAdaptiveBannerAdSize() async {
  return await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(Get.context!).size.width.toInt());
}
