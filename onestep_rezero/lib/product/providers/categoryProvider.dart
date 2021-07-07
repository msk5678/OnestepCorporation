import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/utils/categoryFirebaseApi.dart';

class CategoryProvider extends ChangeNotifier {
  final _productsSnapshot = <DocumentSnapshot>[];
  final int documentLimit = 12;
  String category;
  String detailCategory;
  bool hasNext = true;
  bool isFetching = false;
  List<Product> product = [];

  List<Product> get products => product;

  Future fetchProducts({String category, String detailCategory}) async {
    if (isFetching) return;
    isFetching = true;
    hasNext = true;

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

      if (snap.docs.length < documentLimit) hasNext = false;
    } catch (error) {}

    product = _productsSnapshot.map((snap) {
      return Product.fromJson(snap.data(), snap.id);
    }).toList();

    isFetching = false;
    notifyListeners();
  }

  Future fetchNextProducts() async {
    if (isFetching || !hasNext) return;
    isFetching = true;

    try {
      final snap = await CategoryFirebaseApi.getAllProducts(
        documentLimit,
        category: this.category,
        detailCategory: this.detailCategory,
        startAfter:
            _productsSnapshot.isNotEmpty ? _productsSnapshot.last : null,
      );
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) hasNext = false;
    } catch (error) {}

    product = _productsSnapshot.map((snap) {
      return Product.fromJson(snap.data(), snap.id);
    }).toList();

    isFetching = false;
    notifyListeners();
  }
}
