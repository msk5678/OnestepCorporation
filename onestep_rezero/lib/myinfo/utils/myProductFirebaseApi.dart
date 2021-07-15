import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

class MyProductFirebaseApi {
  static Future<QuerySnapshot> getMySaleProducts(
    // 내 판매중 상품 불러오기
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;

    refProducts = FirebaseFirestore.instance
        .collection("university")
        .doc(currentUserModel.university)
        .collection("product")
        .where("uid", isEqualTo: currentUserModel.uid)
        .where("deleted", isEqualTo: false)
        .where("hold", isEqualTo: false)
        .where("completed", isEqualTo: false)
        .where("trading", isEqualTo: false)
        .where("reported", isEqualTo: false)
        .orderBy("bumpTime", descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }

  static Future<QuerySnapshot> getMyTradingProducts(
    // 내 예약중 상품 불러오기
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;

    refProducts = FirebaseFirestore.instance
        .collection("university")
        .doc(currentUserModel.university)
        .collection("product")
        .where("uid", isEqualTo: currentUserModel.uid)
        .where("deleted", isEqualTo: false)
        .where("hold", isEqualTo: false)
        .where("completed", isEqualTo: false)
        .where("trading", isEqualTo: true)
        .where("reported", isEqualTo: false)
        .orderBy("bumpTime", descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }

  static Future<QuerySnapshot> getMyCompletedProducts(
    // 내 판매완료 상품 불러오기
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;

    refProducts = FirebaseFirestore.instance
        .collection("university")
        .doc(currentUserModel.university)
        .collection("product")
        .where("uid", isEqualTo: currentUserModel.uid)
        .where("deleted", isEqualTo: false)
        .where("hold", isEqualTo: false)
        .where("completed", isEqualTo: true)
        .where("trading", isEqualTo: false)
        .where("reported", isEqualTo: false)
        .orderBy("bumpTime", descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }

  static Future<QuerySnapshot> getMyHoldProducts(
    // 내 판매보류 상품 불러오기
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;

    refProducts = FirebaseFirestore.instance
        .collection("university")
        .doc(currentUserModel.university)
        .collection("product")
        .where("uid", isEqualTo: currentUserModel.uid)
        .where("deleted", isEqualTo: false)
        .where("hold", isEqualTo: true)
        .where("completed", isEqualTo: false)
        .where("trading", isEqualTo: false)
        .where("reported", isEqualTo: false)
        .orderBy("bumpTime", descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }
}
