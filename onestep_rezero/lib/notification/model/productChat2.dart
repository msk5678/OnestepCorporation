import 'package:firebase_database/firebase_database.dart';

class ProductChat2 {
  final String chatId;
  final String postId;
  final String title;
  final String boardType;
  final String users;
  final String user1;
  final String user2;
  final String productImage;
  final String recentText;
  final String timeStamp;

  //List<String> users;

  ProductChat2({
    this.chatId,
    this.postId,
    this.title,
    this.boardType,
    this.users,
    this.user1,
    this.user2,
    this.productImage,
    this.recentText,
    this.timeStamp,
  });

  DatabaseReference databasereference =
      FirebaseDatabase.instance.reference().child("path");

  factory ProductChat2.fromJson(Map<String, dynamic> json) {
    final consolidatedProductChat = json['경로'][0];

    return ProductChat2(
      chatId: consolidatedProductChat[''],
      postId: consolidatedProductChat[''],
      title: consolidatedProductChat[''],
      boardType: consolidatedProductChat[''],
      users: consolidatedProductChat[''],
      user1: consolidatedProductChat[''],
      user2: consolidatedProductChat[''],
      productImage: consolidatedProductChat[''],
      recentText: consolidatedProductChat[''],
      timeStamp: consolidatedProductChat[''],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "chatId": chatId,
      "postId": postId,
      "title": title,
      "boardtype": boardType,
      "users": [user1, user2],
      "user1": user1,
      "user2": user2,
      "productImage": productImage,
      "recentText": recentText,
      "timestamp": timeStamp,
    };
  }

  // ProductChat2.forMapSnapshot(dynamic snapshot) {
  //   chatId = snapshot["chatId"];
  //   boardType = snapshot["boardtype"];
  //   title = snapshot["title"];
  //   postId = snapshot["postId"];
  //   productImage = snapshot["productImage"];
  //   recentText = snapshot["recentText"];
  //   timeStamp = snapshot["timestamp"];
  //   users = snapshot["users"].toString();
  //   user1 = snapshot['users'].keys.toList()[0];
  //   user2 = snapshot['users'].keys.toList()[1];
  // }
}
