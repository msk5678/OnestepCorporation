import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobListPage extends StatefulWidget {
  @override
  _AdmobListState createState() => _AdmobListState();
}

class _AdmobListState extends State<AdmobListPage> {
  BannerAd smainBanner;

  @override
  void initState() {
    super.initState();
    // GoogleAdmob().initBannerAd(smainBanner);

    smainBanner = BannerAd(
      listener: AdListener(),
      size: AdSize.banner, //현재 상태, 작은 사이즈
      // size: AdSize.getAnchoredAdaptiveBannerAdSize(context, 500),
      // size: AdSize.smartBanner, //스마트배너 가로폭 디바이스에 맞게
      // AdSize(height: 50, width: 550),
      // AdSize.largeBanner,
      // AdSize.fullBanner, //현재 상태, 작은 사이즈
      // adUnitId: Platform.isIOS ? iOsTestUnitid : androidTestUnitid,
      adUnitId: BannerAd.testAdUnitId,
      request: AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _admobList(),
    );
  }

  Widget _admobList() {
    return CustomScrollView(
      shrinkWrap: false,
      // anchor: 0.5,
      // dragStartBehavior: DragStartBehavior.down,
      slivers: <Widget>[
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0)
                return Container(
                  height: 50,
                  // width: 320,
                  color: Colors.red,
                  child: smainBanner == null
                      ? Text("esrr")
                      : AdWidget(
                          ad: smainBanner,
                        ),
                );
              else
                return ListTile(
                    title: Column(
                      children: [
                        // Container(
                        //   color: Colors.amber,
                        //   height: 40,
                        // ),
                        // Divider(),
                        Container(
                            color: Colors.pink, child: Text('Item #$index')),
                      ],
                    ),
                    onTap: () {
                      print("ge");
                    });
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }
}
