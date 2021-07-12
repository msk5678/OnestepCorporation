import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/product/utils/productFirebaseApi.dart';

class ProductMainProvider extends ChangeNotifier {
  final _productsSnapshot = <DocumentSnapshot>[];
  final int documentLimit = 12;
  bool _hasNext = true;
  bool _isFetching = false;
  List<Product> product = [];

  List<Product> get products => product;

  Future fetchProducts() async {
    if (_isFetching) return;
    _isFetching = true;
    _hasNext = true;

    _productsSnapshot.clear();
    try {
      final snap = await ProductFirebaseApi.getAllProducts(
        documentLimit,
        startAfter: null,
      );
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
    } catch (error) {}

    product = _productsSnapshot.map((snap) {
      return Product.fromJson(snap.data(), snap.id);
    }).toList();

    _isFetching = false;
    notifyListeners();
  }

  Future fetchNextProducts() async {
    if (_isFetching || !_hasNext) return;
    _isFetching = true;

    try {
      final snap = await ProductFirebaseApi.getAllProducts(
        documentLimit,
        startAfter:
            _productsSnapshot.isNotEmpty ? _productsSnapshot.last : null,
      );
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
    } catch (error) {}

    product = _productsSnapshot.map((snap) {
      return Product.fromJson(snap.data(), snap.id);
    }).toList();

    _isFetching = false;
    notifyListeners();
  }

  Future updateState(String id, bool trading, bool hold, bool completed) async {
    if (_isFetching) return;
    _isFetching = true;

    DocumentSnapshot _documentSnapshot = _productsSnapshot[
        _productsSnapshot.indexWhere((element) => element.id == id)];

    Product _product = Product.fromJson(_documentSnapshot.data(), id);
    _product.setTrading = trading;
    _product.setHold = hold;
    _product.setCompleted = completed;

    product[product.indexWhere((element) => element.firestoreid == id)] =
        _product;

    _isFetching = false;
    notifyListeners();
  }
}
