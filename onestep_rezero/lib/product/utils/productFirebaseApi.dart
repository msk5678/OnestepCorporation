import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep_rezero/loggedInWidget.dart';

class ProductFirebaseApi {
  static Future<QuerySnapshot> getAllProducts(
    // 장터 메인 모든상품 불러오기
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;

    refProducts = FirebaseFirestore.instance
        .collection("university")
        .doc(currentUserModel.university)
        .collection('product')
        .where("deleted", isEqualTo: false)
        .where("hide", isEqualTo: false)
        .orderBy("bumpTime", descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }
}
