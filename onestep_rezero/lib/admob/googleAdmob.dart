import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdmob {
  final String iOsTestUnitid = "ca-app-pub-3940256099942544/2934735716";
  final String androidTestUnitid =
      "ca-app-pub-3940256099942544/6300978111"; //testId
  BannerAd banner;
  InterstitialAd interstitialAd;
  RewardedAd rewardedAd;

  Widget getBannerAd() {
    return Container(
        height: 50,
        color: Colors.red,
        child: this.banner == null
            ? Text("err")
            : AdWidget(
                ad: this.banner,
              ));
  }

  // initAdmob() {
  //   initBannerAd();
  //   initInterstitialAd();
  //   initRewardedAd();
  // }

  initBannerAd(BannerAd banners) {
    banners = BannerAd(
      listener: AdListener(),
      size: AdSize.banner,
      adUnitId: Platform.isIOS ? iOsTestUnitid : androidTestUnitid,
//      adUnitId: androidTestUnitid,
      request: AdRequest(),
    )..load();
  }

  initInterstitialAd(InterstitialAd interstitialAd) {
    interstitialAd = InterstitialAd(
      listener: AdListener(onAdClosed: (ad) {
        print("Interstitial Ad 종료.");
      }),
      adUnitId: InterstitialAd.testAdUnitId,
      request: AdRequest(),
    )..load();
  }

  initRewardedAd(RewardedAd rewardedAd) {
    rewardedAd = RewardedAd(
      listener: AdListener(onAdClosed: (ad) {
        print("Rewarded Ad 종료");
      }, onRewardedAdUserEarnedReward: (ad, item) {
        print("Rewarded Ad 보상 획득");
      }),
      adUnitId: RewardedAd.testAdUnitId,
      request: AdRequest(),
    )..load();
  }
}
