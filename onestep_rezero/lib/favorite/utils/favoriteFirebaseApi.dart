import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep_rezero/main.dart';

class FavoriteFirebaseApi {
  static Future<QuerySnapshot> getProducts(
    // 찜한 상품 불러오기
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;

    refProducts = FirebaseFirestore.instance
        .collection("university")
        .doc(currentUserModel.university)
        .collection("product")
        .orderBy("favoriteUserList." + googleSignIn.currentUser.id,
            descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }

  static void insertFavorite(String docId) {
    var time = DateTime.now().millisecondsSinceEpoch;

    FirebaseFirestore.instance
        .collection("university")
        .doc(currentUserModel.university)
        .collection("product")
        .doc(docId)
        .update({
      "favoriteUserList." + googleSignIn.currentUser.id: time,
    });
  }

  static void deleteFavorite(String docId) {
    FirebaseFirestore.instance
        .collection("university")
        .doc(currentUserModel.university)
        .collection("product")
        .doc(docId)
        .update({
      "favoriteUserList." + googleSignIn.currentUser.id: FieldValue.delete()
    });
  }
}
