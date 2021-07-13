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
        return Product.fromJson(snap.data(), snap.id);
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

  Future updateState(String id, bool trading, bool hold, bool completed) async {
    if (isFetching) return;
    isFetching = true;

    DocumentSnapshot _documentSnapshot = _productsSnapshot[
        _productsSnapshot.indexWhere((element) => element.id == id)];

    Product _product = Product.fromJson(_documentSnapshot.data(), id);
    _product.setTrading = trading;
    _product.setHold = hold;
    _product.setCompleted = completed;

    product[product.indexWhere((element) => element.firestoreid == id)] =
        _product;

    isFetching = false;
    notifyListeners();
  }
}
