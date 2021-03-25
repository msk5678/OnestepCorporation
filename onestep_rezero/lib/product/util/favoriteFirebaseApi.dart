import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteFirbaseApi {
  static void insertFavorite(String docId) {
    var time = DateTime.now().millisecondsSinceEpoch;

    FirebaseFirestore.instance.collection("products").doc(docId).update({
      "favoriteuserlist.EQ0UIt2ujMd642TxMzrZ0zJZTzB3": time,
    });
  }

  static void deleteFavorite(String docId) {
    FirebaseFirestore.instance.collection("products").doc(docId).update(
        {"favoriteuserlist.EQ0UIt2ujMd642TxMzrZ0zJZTzB3": FieldValue.delete()});
  }
}
