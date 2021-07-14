import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:onestep_rezero/myinfo/utils/mySaleProductFirebaseApi.dart';
import 'package:onestep_rezero/product/models/product.dart';

class MySaleProductProvider extends ChangeNotifier {
  final _productsSnapshot = <DocumentSnapshot>[];
  final int documentLimit = 12;
  bool _hasNext = true;
  bool isFetching = false;
  List<Product> product = [];

  List<Product> get products => product;

  Future fetchProducts() async {
    if (isFetching) return;
    isFetching = true;
    _hasNext = true;
    _productsSnapshot.clear();
    try {
      final snap = await MySaleProductFirebaseApi.getProducts(
        documentLimit,
        startAfter: null,
      );
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
    } catch (error) {}
    product = _productsSnapshot.map((snap) {
      return Product.fromJson(snap.data(), snap.id);
    }).toList();

    isFetching = false;
    notifyListeners();
  }

  Future fetchNextProducts() async {
    if (isFetching || !_hasNext) return;
    isFetching = true;

    try {
      final snap = await MySaleProductFirebaseApi.getProducts(
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

    isFetching = false;
    notifyListeners();
  }

  Future updateState(String id, bool trading, bool hold, bool completed) async {
    if (isFetching) return;
    isFetching = true;

    DocumentSnapshot _documentSnapshot = _productsSnapshot[
        _productsSnapshot.indexWhere((element) => element.id == id)];

    print("@@@@@@@@@@@ ${_documentSnapshot.data()}");
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
