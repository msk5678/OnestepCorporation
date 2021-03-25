import 'package:firebase_database/firebase_database.dart';

class ProductChat {
  String boardType;
  String title;
  String postId;
  String user1;
  String user2;
  String productImage;
  String recentText;
  String timeStamp;
  String chatId;
  String users;
  //List<String> users;

  DatabaseReference databasereference =
      FirebaseDatabase.instance.reference().child("path");

  ProductChat({
    this.boardType,
    this.title,
    this.postId,
    // this.user1,
    // this.user2,
    this.chatId,
    this.productImage,
    this.recentText,
    this.timeStamp,
    this.users,
  });

  ProductChat.forMapSnapshot(dynamic snapshot) {
    chatId = snapshot["chatId"];
    boardType = snapshot["boardtype"];
    title = snapshot["title"];
    postId = snapshot["postId"];
    productImage = snapshot["productImage"];
    recentText = snapshot["recentText"];
    timeStamp = snapshot["timestamp"];
    users = snapshot["users"].toString();
    user1 = snapshot['users'].keys.toList()[0];
    user2 = snapshot['users'].keys.toList()[1];
  }

//채팅방 ID
  DatabaseReference createChatID(String chatId) {
    return FirebaseDatabase.instance.reference().child("path").child(chatId);
  }

  createChat(String chatId) {
    createChatID(chatId).set(toJson());
  }

  toJson() {
    print("리얼타임 투제이슨 실행");
    //print("리얼타임내부:" + boardType);
    return {
      "boardtype": boardType,
      "title": title,
      "postId": postId,
      "productImage": productImage,
      "recentText": recentText,
      "timestamp": timeStamp,
      "users": [user1, user2],
    };
  }

  load() {
    print(" $boardType, $postId, $productImage, $recentText, $timeStamp");
  }

//안씀
  ProductChat.forSnapshot(DataSnapshot snapshot) {
    print("####에드 폴 호출");
    print(
        "####에드 폴스냅샷 넣기전 ${snapshot.key} ${snapshot.value["boardtype"]} ${snapshot.value["users"]}");
    //key = snapshot.key;
    boardType = snapshot.value["boardtype"];
    title = snapshot.value["title"];
    postId = snapshot.value["postId"];
    // user1 = snapshot.value["users"][0],
    // user2 = snapshot.value["users"][1],
    productImage = snapshot.value["productImage"];
    recentText = snapshot.value["recentText"];
    timeStamp = snapshot.value["timestamp"];
    users = snapshot.value["users"].toString();
    print("####에드 다넣음");
    // print(
    //     "####에드 폴스냅샷 내부 $key $boardType $title $postId $productImage $recenTtext $timeStamp $users");
  }

  factory ProductChat.fromFireStore(Map<dynamic, dynamic> snapshot) {
    //print("snapshot sss" + snapshot['boardtype']);
    return ProductChat(
      boardType: snapshot['boardtype'],
      title: snapshot["title"],
      postId: snapshot["postId"],
      // user1: snapshot['users'][0],
      // user2: snapshot['users'][1],
      productImage: snapshot["productImage"],
      recentText: snapshot["recentText"],
      timeStamp: snapshot["timestamp"],
      // users: snapshot['users']
      //[0] + snapshot['users'][1],
    );
  }
}
