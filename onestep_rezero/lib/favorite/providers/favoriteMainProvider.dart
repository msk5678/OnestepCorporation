import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestep_rezero/favorite/utils/favoriteFirebaseApi.dart';
import 'package:onestep_rezero/product/models/product.dart';

class FavoriteMainProvider extends ChangeNotifier {
  final _productsSnapshot = <DocumentSnapshot>[];
  final int documentLimit = 12;
  bool hasNext = true;
  bool isFetching = false;
  List<Product> product = [];

  List<Product> get products => _productsSnapshot.map((snap) {
        final _product = snap.data();

        return Product(
          firestoreid: snap.id,
          uid: _product['uid'],
          title: _product['title'],
          category: _product['category'],
          favoriteUserList: _product['favoriteUserList'],
          price: _product['price'],
          trading: _product['trading'],
          completed: _product['completed'],
          hide: _product['hide'],
          deleted: _product['deleted'],
          imagesUrl: _product['imagesUrl'],
          bumpTime: DateTime.fromMicrosecondsSinceEpoch(_product['bumpTime']),
        );
      }).toList();

  Future fetchProducts() async {
    if (isFetching) return;
    isFetching = true;
    hasNext = true;
    _productsSnapshot.clear();
    try {
      final snap = await FavoriteFirebaseApi.getProducts(
        documentLimit,
        startAfter: null,
      );
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) hasNext = false;
    } catch (error) {}
    isFetching = false;
    notifyListeners();
  }

  Future fetchNextProducts() async {
    if (isFetching || !hasNext) return;
    isFetching = true;

    try {
      final snap = await FavoriteFirebaseApi.getProducts(
        documentLimit,
        startAfter:
            _productsSnapshot.isNotEmpty ? _productsSnapshot.last : null,
      );
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) hasNext = false;
    } catch (error) {}
    isFetching = false;
    notifyListeners();
  }
}
