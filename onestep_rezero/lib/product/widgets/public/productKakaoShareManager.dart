// // kakao test
// // https://eunjin3786.tistory.com/292 참고
// // ios 따로 추가해야함
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:kakao_flutter_sdk/link.dart';
// import 'package:onestep_rezero/product/models/product.dart';
// import 'package:share/share.dart';

// class KakaoShareManager {
//   static final KakaoShareManager _manager = KakaoShareManager._internal();

//   factory KakaoShareManager() {
//     return _manager;
//   }

//   KakaoShareManager._internal() {
//     // 초기화 코드
//     initializeKakaoSDK();
//   }

//   void initializeKakaoSDK() {
//     // String kakaoAppKey = "c9095cdfce8884adb0b88729a7e95aba";
//     // KakaoContext.clientId = kakaoAppKey;
//   }

//   Future<bool> isKakaotalkInstalled() async {
//     bool installed = await isKakaoTalkInstalled();
//     return installed;
//   }

//   void shareMyCode(Product product) async {
//     try {
//       var dynamicLink = await _getDynamicLink(product.images[0]);
//       print("dynamicLink = $dynamicLink");
//       var template = _getTemplate(dynamicLink, product);
//       var uri = await LinkClient.instance.defaultWithTalk(template);
//       await LinkClient.instance.launchKakaoTalk(uri);
//     } catch (error) {
//       print(error.toString());
//     }
//   }

//   void getDynamicLink(Product product) async {
//     try {
//       var dynamicLink = await _getDynamicLink(product.images[0]);
//       print("dynamicLink = $dynamicLink");
//       Share.share("더보기 test $dynamicLink");
//     } catch (error) {
//       print(error.toString());
//     }
//   }

//   Future<Uri> _getDynamicLink(imag) async {
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: 'https://onestep.page.link',
//       // link: Uri.parse('https://onestep.page.link/join_onestep?code=$docId'),
//       link: Uri.parse('https://onestep.page.link/join_family?code=test'),
//       androidParameters: AndroidParameters(
//         packageName: 'com.example.onestep',
//         minimumVersion: 1,
//       ),
//       // iosParameters: IosParameters(
//       //   bundleId: 'com.jinny.onionFamily',
//       //   minimumVersion: '1.0',
//       //   appStoreId: '1540106955',
//       // )
//     );

//     Uri dynamicUrl = await parameters.buildUrl();
//     return dynamicUrl;
//   }

//   DefaultTemplate _getTemplate(Uri dynamicLink, Product product) {
//     // title에 내용, image 넘겨받아야함
//     String title = product.title;
//     Uri imageLink = Uri.parse(product.images[0]);

//     // Uri imageLink = Uri.parse(
//     //     "http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png");
//     // Uri imageLink = Uri.parse("http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png");

//     Link link = Link(mobileWebUrl: dynamicLink);

//     Content content = Content(title, imageLink, link, imageHeight: 300);

//     FeedTemplate template =
//         FeedTemplate(content, buttons: [Button("자세히 보기", link)]);

//     return template;
//   }
// }
