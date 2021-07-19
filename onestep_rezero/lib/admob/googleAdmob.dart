import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onestep_rezero/admob/googleAdmobManager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoogleAdmob {
  final String iOsTestUnitid = "ca-app-pub-3940256099942544/2934735716";
  final String androidTestUnitid =
      "ca-app-pub-3940256099942544/6300978111"; //testId
  BannerAd banner;

  final BannerAd productMainBottomBanner = BannerAd(
    listener: AdListener(),
    size: AdSize.banner,
    adUnitId: BannerAd.testAdUnitId,
    // AdManager.bannerAdUnitId,
    request: AdRequest(),
  )..load();

  final BannerAd chatMainBottomBanner = BannerAd(
    listener: AdListener(),
    size: AdSize.banner,
    adUnitId: BannerAd.testAdUnitId,
    // AdManager.bannerAdUnitId,
    request: AdRequest(),
  )..load();

  final BannerAd boardBottomBanner = BannerAd(
    listener: AdListener(),
    size: AdSize.banner,
    adUnitId: BannerAd.testAdUnitId,
    // AdManager.bannerAdUnitId,
    request: AdRequest(),
  )..load();

  final BannerAd boardPostBottomBanner = BannerAd(
    listener: AdListener(),
    size: AdSize.banner,
    adUnitId: BannerAd.testAdUnitId,
    // AdManager.bannerAdUnitId,
    request: AdRequest(),
  )..load();

  getProductMainBottomBanner(double diviceWidth) {
    return Container(
      height: productMainBottomBanner == null ? 0 : 50.h,
      width: diviceWidth,
      color: Colors.white,
      child: productMainBottomBanner == null
          ? Container(
              // color: Colors.yellow,
              // width: 40,
              // height: 20,
              // child: Text("null"),
              )
          : AdWidget(
              ad: productMainBottomBanner,
            ),
    );
  }

  getChatMainBottomBanner(double diviceWidth) {
    return Container(
      height: chatMainBottomBanner == null ? 0 : 50.h,
      width: diviceWidth,
      color: Colors.white,
      child: chatMainBottomBanner == null
          ? Container()
          : AdWidget(
              ad: chatMainBottomBanner,
            ),
    );
  }

  getBoardBottomBanner(double diviceWidth) {
    return Container(
      height: boardBottomBanner == null ? 0 : 50.h,
      width: diviceWidth,
      color: Colors.white,
      child: boardBottomBanner == null
          ? Container(
              // color: Colors.yellow,
              // width: 40,
              // height: 20,
              // child: Text("null"),
              )
          : AdWidget(
              ad: boardBottomBanner,
            ),
    );
  }

  getBoardPostBottomBanner(double diviceWidth) {
    return Container(
      height: boardPostBottomBanner == null ? 0 : 50.h,
      width: diviceWidth,
      color: Colors.white,
      child: boardPostBottomBanner == null
          ? Container(
              // color: Colors.yellow,
              // width: 40,
              // height: 20,
              // child: Text("null"),
              )
          : AdWidget(
              ad: boardPostBottomBanner,
            ),
    );
  }

  InterstitialAd interstitialAd;
  RewardedAd rewardedAd;

  // Widget getBannerAd() {
  //   return Container(
  //       height: 50,
  //       color: Colors.red,
  //       child: this.banner == null
  //           ? Text("err")
  //           : AdWidget(
  //               ad: this.banner,
  //             ));
  // }

  // initBannerAd(BannerAd banners) {
  //   print("배너 초기화");
  //   banners = BannerAd(
  //     listener: AdListener(),
  //     size: AdSize.largeBanner,
  //     // adUnitId: Platform.isIOS ? iOsTestUnitid : androidTestUnitid,
  //     adUnitId: BannerAd.testAdUnitId,
  //     request: AdRequest(),
  //   )..load();
  // }

  initNativeBannerAd(NativeAd nativeAd) {
    print("배너 초기화");
    nativeAd = NativeAd(
      listener: AdListener(),
      adUnitId: NativeAd.testAdUnitId,
      factoryId: NativeAd.testAdUnitId,
      request: AdRequest(),
    )..load();
  }

  initInterstitialAd(InterstitialAd interstitialAd) {
    interstitialAd = InterstitialAd(
      listener: AdListener(onAdClosed: (ad) {
        print("Interstitial Ad 종료.");
      }),
      adUnitId: AdManager.interstitialAdUnitId,
      // InterstitialAd.testAdUnitId,
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
