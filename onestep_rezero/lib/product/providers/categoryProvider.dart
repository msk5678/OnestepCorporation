import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/utils/categoryFirebaseApi.dart';

class CategoryProvider extends ChangeNotifier {
  final _productsSnapshot = <DocumentSnapshot>[];
  final int documentLimit = 12;
  String category;
  String detailCategory;
  bool _hasNext = true;
  bool _isFetching = false;
  List<Product> product = [];

  List<Product> get products => product;

  Future fetchProducts({String category, String detailCategory}) async {
    if (_isFetching) return;
    _isFetching = true;
    _hasNext = true;

    if (category != null) {
      this.category = category;
      this.detailCategory = detailCategory;
    }

    _productsSnapshot.clear();

    try {
      final snap = await CategoryFirebaseApi.getAllProducts(
        documentLimit,
        category: this.category,
        detailCategory: detailCategory,
        startAfter: null,
      );
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
    } catch (error) {}

    product = _productsSnapshot.map((snap) {
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

    _isFetching = false;
    notifyListeners();
  }

  Future fetchNextProducts() async {
    if (_isFetching || !_hasNext) return;
    _isFetching = true;

    try {
      final snap = await CategoryFirebaseApi.getAllProducts(
        documentLimit,
        category: this.category,
        detailCategory: this.detailCategory,
        startAfter:
            _productsSnapshot.isNotEmpty ? _productsSnapshot.last : null,
      );
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
    } catch (error) {}

    product = _productsSnapshot.map((snap) {
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

    _isFetching = false;
    notifyListeners();
  }
}
