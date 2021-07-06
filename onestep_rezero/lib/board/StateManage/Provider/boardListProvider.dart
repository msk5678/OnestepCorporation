import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestep_rezero/board/declareData/boardData.dart';
import 'package:onestep_rezero/signIn/loggedInWidget.dart';

// final futureBoardProvider = FutureProvider<Map<String, String>>((ref) async {
//   Map<String, String> boardList = {};
//   QuerySnapshot querySnapshot =
//       await FirebaseFirestore.instance.collection("Board").get();
//   querySnapshot.docs.forEach((element) {
//     boardList.addAll({element.id: element.data()["boardName"]});
//   });
//   return boardList;
// });

class BoardListProvider with ChangeNotifier {
  // final boardName;
  final _boardsSnapshot = <DocumentSnapshot>[];
  String _errorMessage = "Board Provider RuntimeError";
  int documentLimit = 15;
  bool _hasNext = true;
  bool _isFetching = false;
  List<BoardData> boardData = [];
  bool get isFetch => _isFetching;

  String get errorMessage => _errorMessage;
  bool get hasNext => _hasNext;

  List<BoardData> get boards => _boardsSnapshot.map((snap) {
        return BoardData.fromFireStore(snap);
      }).toList();

  fetchNextProducts() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      final snap = await BoardFirebaseApi.getAllPost(
        documentLimit,
        startAfter: _boardsSnapshot.isNotEmpty ? _boardsSnapshot.last : null,
      );
      _boardsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      print("error is " + error.toString());
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetching = false;
  }

  Future fetchBoards() async {
    if (_isFetching) return;
    _isFetching = true;
    _hasNext = true;

    _boardsSnapshot.clear();
    try {
      print("In try ");
      final snap =
          await BoardFirebaseApi.getAllPost(documentLimit, startAfter: null);
      _boardsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
    } catch (error) {}
    _isFetching = false;
    notifyListeners();
  }

  static Future<QuerySnapshot> getBoardCategory(
      // Get Board Category List
      ) async {
    return FirebaseFirestore.instance.collection('board').get();
  }
}

class BoardFirebaseApi {
  static Future<QuerySnapshot> getAllPost(
    int limit, {
    DocumentSnapshot startAfter,
  }) async {
    var refProducts;
    refProducts = FirebaseFirestore.instance
        .collection('university')
        .doc(currentUserModel.university)
        .collection('board')
        .limit(limit);

    if (startAfter == null) {
      return refProducts.get();
    } else {
      return refProducts.startAfterDocument(startAfter).get();
    }
  }
}
