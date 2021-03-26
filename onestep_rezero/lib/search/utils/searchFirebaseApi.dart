import 'package:cloud_firestore/cloud_firestore.dart';

class SearchFirebaseApi {
  static Future<QuerySnapshot> getSearchProducts(
    // 장터 상품 검색

    int limit,
    String search, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;
    refProducts = FirebaseFirestore.instance
        .collection('products')
        .where("deleted", isEqualTo: false)
        .where("hide", isEqualTo: false)
        .orderBy('title')
        .startAt([search]).endAt([search + '\uf8ff']).limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }
}
