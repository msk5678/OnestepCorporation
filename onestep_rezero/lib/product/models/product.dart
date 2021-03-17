class Product {
  final String title;
  final String firestoreid;
  final String uid;
  final String category;
  final String price;
  final String explain;
  final int views;

  final List<dynamic> favoriteuserlist;

  final DateTime uploadtime;
  final DateTime updatetime;
  final DateTime bumptime;

  final List<dynamic> images;
  final bool hide;
  final bool deleted;

  Product({
    this.title,
    this.firestoreid,
    this.uid,
    this.category,
    this.price,
    this.explain,
    this.views,
    this.favoriteuserlist,
    this.uploadtime,
    this.updatetime,
    this.bumptime,
    this.images,
    this.hide,
    this.deleted,
  });

  factory Product.fromJson(Map<String, dynamic> json, String id) {
    return Product(
      title: json['title'],
      firestoreid: id,
      uid: json['uid'],
      category: json['category'],
      price: json['price'],
      explain: json['explain'],
      views: json['views'],
      updatetime: json['updatetime'].toDate(),
      uploadtime: json['uploadtime'].toDate(),
      bumptime: json['bumptime'].toDate(),
      favoriteuserlist: json['favoriteuserlist'],
      images: json['images'],
      hide: json['hide'],
      deleted: json['deleted'],
    );
  }
}
