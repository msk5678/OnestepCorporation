class Product {
  final String firestoreid;

  final String uid;
  final List<dynamic> imagesUrl;
  final String title;
  final String category;
  final String detailCategory;
  final String price;
  final String explain;

  final bool trading;
  final bool completed;
  final bool hide;
  final bool deleted;
  final bool reported;

  final Map<String, dynamic> favoriteUserList;
  final List<dynamic> chatUserList;
  final Map<String, dynamic> views;

  final DateTime uploadTime;
  final DateTime updateTime;
  final DateTime bumpTime;

  Product({
    this.firestoreid,
    this.uid,
    this.imagesUrl,
    this.title,
    this.category,
    this.detailCategory,
    this.price,
    this.explain,
    this.trading,
    this.completed,
    this.hide,
    this.deleted,
    this.reported,
    this.favoriteUserList,
    this.chatUserList,
    this.views,
    this.uploadTime,
    this.updateTime,
    this.bumpTime,
  });

  factory Product.fromJson(Map<String, dynamic> json, String id) {
    return Product(
      firestoreid: id,
      uid: json['uid'],
      imagesUrl: json['imagesUrl'],
      title: json['title'],
      category: json['category'],
      detailCategory: json['detailCategory'],
      price: json['price'],
      explain: json['explain'],
      favoriteUserList: json['favoriteUserList'],
      chatUserList: json['chatUserList'],
      trading: json['trading'],
      completed: json['completed'],
      hide: json['hide'],
      deleted: json['deleted'],
      reported: json['reported'],
      views: json['views'],
      updateTime: DateTime.fromMicrosecondsSinceEpoch(json['updateTime']),
      uploadTime: DateTime.fromMicrosecondsSinceEpoch(json['uploadTime']),
      bumpTime: DateTime.fromMicrosecondsSinceEpoch(json['bumpTime']),
    );
  }
}
