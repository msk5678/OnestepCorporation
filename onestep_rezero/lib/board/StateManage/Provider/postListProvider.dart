import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';

class PostListProvider with ChangeNotifier {
  // final boardName;
  final _productsSnapshot = <DocumentSnapshot>[];
  String _errorMessage = "Board Provider RuntimeError";
  int documentLimit = 15;
  bool _hasNext = true;

  bool _isFetching = false;
  List<BoardData> boardData = [];

  String get errorMessage => _errorMessage;
  bool get hasNext => _hasNext;

  List<BoardData> get boards => _productsSnapshot.map((snap) {
        return BoardData.fromFireStore(snap);
      }).toList();

  fetchNextProducts(String boardName) async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final snap = await PostFirebaseApi.getAllPost(
        documentLimit,
        boardName: boardName,
        startAfter:
            _productsSnapshot.isNotEmpty ? _productsSnapshot.last : null,
      );
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      print("error is " + error.toString());
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetching = false;
  }

  Future fetchPosts(String boardName) async {
    if (_isFetching) return;
    _isFetching = true;
    _hasNext = true;

    _productsSnapshot.clear();
    try {
      print("In try ");
      final snap = await PostFirebaseApi.getAllPost(documentLimit,
          startAfter: null, boardName: boardName);
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
    } catch (error) {}
    _isFetching = false;
    notifyListeners();
  }

  static Future<QuerySnapshot> getBoardCategory(
      // Get Board Category List
      ) async {
    return FirebaseFirestore.instance.collection('Board').get();
  }
}

class PostFirebaseApi {
  static Future<QuerySnapshot> getAllPost(
      // 장터 메인 모든상품 불러오기
      int limit,
      {DocumentSnapshot startAfter,
      String boardName}) async {
    var refProducts;

    refProducts = FirebaseFirestore.instance
        .collection('Board')
        .doc(boardName)
        .collection(boardName)
        .orderBy("createDate", descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }
}
