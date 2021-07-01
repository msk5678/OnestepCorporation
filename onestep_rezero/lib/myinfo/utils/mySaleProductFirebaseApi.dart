import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

class MySaleProductFirebaseApi {
  static Future<QuerySnapshot> getProducts(
    // 내 판매상품 불러오기
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;

    refProducts = FirebaseFirestore.instance
        .collection("university")
        .doc(currentUserModel.university)
        .collection("product")
        .where("uid", isEqualTo: currentUserModel.uid)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }
}
