// kakao test
// https://eunjin3786.tistory.com/292 참고
// ios 따로 추가해야함
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
import 'package:share/share.dart';

class KakaoShareManager {
  static final KakaoShareManager _manager = KakaoShareManager._internal();

  factory KakaoShareManager() {
    return _manager;
  }

  KakaoShareManager._internal() {
    // 초기화 코드
    initializeKakaoSDK();
  }

  void initializeKakaoSDK() {
    // String kakaoAppKey = "88b99cb950dc222f10f369161182d008";
    // KakaoContext.clientId = kakaoAppKey;
  }

  Future<bool> isKakaotalkInstalled() async {
    bool installed = await isKakaoTalkInstalled();
    return installed;
  }

  void shareMyCode(Product product) async {
    try {
      var dynamicLink =
          await _getDynamicLink(product, imag: product.imagesUrl[0]);
      var template = _getTemplate(dynamicLink, product);
      var uri = await LinkClient.instance.defaultWithTalk(template);
      await LinkClient.instance.launchKakaoTalk(uri);
    } catch (error) {
      print(error.toString());
    }
  }

  void getDynamicLink(Product product) async {
    try {
      var dynamicLink =
          await _getDynamicLink(product, imag: product.imagesUrl[0]);
      print("dynamicLink = $dynamicLink");
      Share.share("$dynamicLink");
    } catch (error) {
      print(error.toString());
    }
  }

  Future<Uri> _getDynamicLink(Product product, {imag}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://onestep.page.link',
      link: Uri.parse(
          'https://onestep.page.link/${currentUserModel.university}?uploadTime=${product.uploadTime.microsecondsSinceEpoch}'),
      // 'https://onestep.page.link/university?uploadTime=${product.uploadTime.microsecondsSinceEpoch}'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.onestep_rezero',
        minimumVersion: 1,
      ),
      // iosParameters: IosParameters(
      //   bundleId: 'com.jinny.onionFamily',
      //   minimumVersion: '1.0',
      //   appStoreId: '1540106955',
      // )
    );

    Uri dynamicUrl = await parameters.buildUrl();
    return dynamicUrl;
  }

  DefaultTemplate _getTemplate(Uri dynamicLink, Product product) {
    String title = product.title;
    Uri imageLink = Uri.parse(product.imagesUrl[0]);

    Link link = Link(mobileWebUrl: dynamicLink);

    Content content = Content(title, imageLink, link, imageHeight: 300);

    FeedTemplate template =
        FeedTemplate(content, buttons: [Button("앱에서 보기", link)]);

    return template;
  }
}
