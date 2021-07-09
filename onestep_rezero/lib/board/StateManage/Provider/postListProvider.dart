import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestep_rezero/board/StateManage/Provider/userProvider.dart';
import 'package:onestep_rezero/board/declareData/postData.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

class PostListProvider with ChangeNotifier {
  // final boardName;
  final _productsSnapshot = <DocumentSnapshot>[];
  String _errorMessage = "Board Provider RuntimeError";
  int documentLimit = 15;
  bool _hasNext = true;
  bool _isFetching = false;
  bool _isNextListFetching = false;

  List<PostData> boardData = [];

  String get errorMessage => _errorMessage;
  bool get hasNext => _hasNext;
  bool get isFetch => _isFetching;
  bool get nextFetching => _isNextListFetching;

  List<PostData> get posts => _productsSnapshot.map((snap) {
        return PostData.fromFireStore(snap);
      }).toList();

  fetchNextProducts(String boardId) async {
    if (_isFetching) return;
    _isNextListFetching = true;

    try {
      final snap = await PostFirebaseApi.getAllPost(
        boardId,
        documentLimit,
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
      _isNextListFetching = false;
    }

    _isNextListFetching = false;
  }

  Future fetchPosts(String boardId) async {
    if (_isFetching) return;
    _isFetching = true;
    _hasNext = true;

    _productsSnapshot.clear();
    try {
      final snap = await PostFirebaseApi.getAllPost(
        boardId,
        documentLimit,
        startAfter: null,
      );
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
    } catch (error) {}
    _isFetching = false;
    notifyListeners();
  }

  Future fetchUserPosting(String currentUid) async {
    if (_isFetching) return;
    _isFetching = true;
    _hasNext = true;

    _productsSnapshot.clear();

    try {
      QuerySnapshot boardList = await FirebaseFirestore.instance
          .collection('university')
          .doc(currentUserModel.university)
          .collection("board")
          .get();

      await Future.forEach(boardList.docs,
          (DocumentSnapshot documentSnapshot) async {
        String boardId = documentSnapshot.id;
        QuerySnapshot postQuerySnapshot = await FirebaseFirestore.instance
            .collection('university')
            .doc(currentUserModel.university)
            .collection("board")
            .doc(boardId)
            .collection(boardId)
            .where(
              "uid",
              isEqualTo: currentUid,
            )
            .orderBy("uploadTime", descending: true)
            .get();

        // return userAllPosting.addAll(postQuerySnapshot.docs);
        _productsSnapshot.addAll(postQuerySnapshot.docs);
        notifyListeners();
      });
    } catch (error) {}
    _isFetching = false;
    notifyListeners();
  }

  Future fetchTopFavoritePost() async {
    if (_isFetching) return;
    _isFetching = true;
    _hasNext = true;

    _productsSnapshot.clear();
    try {
      QuerySnapshot boardList = await FirebaseFirestore.instance
          .collection('university')
          .doc(currentUserModel.university)
          .collection("board")
          .get();
      await Future.forEach(boardList.docs,
          (DocumentSnapshot documentSnapshot) async {
        String boardId = documentSnapshot.id;
        QuerySnapshot postQuerySnapshot = await FirebaseFirestore.instance
            .collection('university')
            .doc(currentUserModel.university)
            .collection("board")
            .doc(boardId)
            .collection(boardId)
            .where("favoriteCount", isGreaterThanOrEqualTo: 10)
            .get();
        _productsSnapshot.addAll(postQuerySnapshot.docs);
        notifyListeners();
      });
    } catch (error) {}
    _isFetching = false;
    notifyListeners();
  }

  Future fetchTopCommentPost() async {
    if (_isFetching) return;
    _isFetching = true;
    _hasNext = true;

    _productsSnapshot.clear();
    try {
      QuerySnapshot boardList = await FirebaseFirestore.instance
          .collection('university')
          .doc(currentUserModel.university)
          .collection("board")
          .get();
      await Future.forEach(boardList.docs,
          (DocumentSnapshot documentSnapshot) async {
        String boardId = documentSnapshot.id;
        QuerySnapshot postQuerySnapshot = await FirebaseFirestore.instance
            .collection('university')
            .doc(currentUserModel.university)
            .collection("board")
            .doc(boardId)
            .collection(boardId)
            .where("commentCount", isGreaterThanOrEqualTo: 10)
            .get();
        _productsSnapshot.addAll(postQuerySnapshot.docs);
        notifyListeners();
      });
    } catch (error) {}
    _isFetching = false;
    notifyListeners();
  }

  Future fetchPostDataFromPostId(List<UserData> postIdList) async {
    if (_isFetching) return;

    _isFetching = true;

    _productsSnapshot.clear();
    try {
      await Future.forEach(postIdList, (UserData userFavoriteData) async {
        String boardId = userFavoriteData.boardId;
        String postId = userFavoriteData.postId;
        _productsSnapshot.add(await FirebaseFirestore.instance
            .collection('university')
            .doc(currentUserModel.university)
            .collection("board")
            .doc(boardId)
            .collection(boardId)
            .doc(postId)
            .get());
        notifyListeners();
      });
    } catch (e) {
      _isFetching = false;
    }
    _isFetching = false;
    notifyListeners();
  }
}

class PostFirebaseApi {
  static Future<QuerySnapshot> getAllPost(
    String boardId,
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;
    refProducts = FirebaseFirestore.instance
        .collection('university')
        .doc(currentUserModel.university)
        .collection("board")
        .doc(boardId)
        .collection(boardId)
        .orderBy("uploadTime", descending: true)
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }

  static Future<List<DocumentSnapshot>> getAllUserPostingList(
    String uid,
  ) async {
    List<DocumentSnapshot> userAllPosting = [];

    QuerySnapshot boardList = await FirebaseFirestore.instance
        .collection('university')
        .doc(currentUserModel.university)
        .collection("board")
        .get();

    await Future.forEach(boardList.docs, (DocumentSnapshot element) async {
      String boardId = element.id;
      QuerySnapshot postQuerySnapshot = await FirebaseFirestore.instance
          .collection('university')
          .doc(currentUserModel.university)
          .collection("board")
          .doc(boardId)
          .collection(boardId)
          .where("uid", isEqualTo: uid)
          .get();

      // return userAllPosting.addAll(postQuerySnapshot.docs);
      userAllPosting.addAll(postQuerySnapshot.docs);
    });

    return userAllPosting;
  }
}
