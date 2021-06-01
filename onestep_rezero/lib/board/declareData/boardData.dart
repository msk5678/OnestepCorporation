import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onestep_rezero/board/declareData/categoryManageClass.dart';

class BoardData {
  final boardName;
  final boardExplain;
  final boardId;
  final boardCategory;
  BoardData(
      {this.boardName, this.boardExplain, this.boardId, this.boardCategory});
//  BoardCategory boardCategory =
//
  factory BoardData.fromFireStore(DocumentSnapshot snapshot) {
    Map boardData = snapshot.data();
    return BoardData(
      boardId: snapshot.id,
      boardName: boardData["boardName"],
      boardExplain: boardData["boardExplain"] ?? '',
      boardCategory: BoardCategory.values.firstWhere((element) =>
          element.toString() == 'BoardCategory.' + boardData["boardCategory"]),
    );
  }
}

class BoardInitData {
  final icons;
  final explain;
  BoardInitData({this.icons, this.explain});
}
//                 leading: Icon(
//                   Icons.library_books_outlined,
//                   color: Colors.green[100],
//                 ),
//                 title: Text("나의 글"),
//               ),
//               ListTile(
//                 leading: Icon(
//                   Icons.mode_comment_rounded,
//                   color: Colors.green[100],
//                 ),
//                 title: Text("나의 댓글"),
//               ),
//               ListTile(
//                 leading: Icon(
//                   Icons.book_rounded,
//                   color: Colors.yellow[600],
//                 ),
//                 title: Text("나의 스크랩"),
//               ),
//               ListTile(
//                 leading: Icon(
//                   Icons.favorite,
//                   color: Colors.redAccent[100],
//                 ),
//                 title: Text("인기글"),
//               ),
