import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';
class CategoryFirebaseApi {
  static Future<QuerySnapshot> getAllProducts(
    // 장터 메인 모든상품 불러오기
    int limit, {
    String category,
    String detailCategory,
    DocumentSnapshot startAfter,
  }) async {
    Query refProducts;

    refProducts = FirebaseFirestore.instance
        .collection("university")
        .doc(currentUserModel.university)
        .collection('product')
        .where("deleted", isEqualTo: false)
        .where("hide", isEqualTo: false)
        .where("category", isEqualTo: category)
        .orderBy("bumpTime", descending: true)
        .limit(limit);

    if (detailCategory != null)
      refProducts =
          refProducts.where("detailCategory", isEqualTo: detailCategory);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }
}
