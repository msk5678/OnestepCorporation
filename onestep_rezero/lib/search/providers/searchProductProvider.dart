import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/search/utils/searchFirebaseApi.dart';

class SearchProductProvider extends StateNotifier<List<Product>> {
  final _productsSnapshot = <DocumentSnapshot>[];
  final int documentLimit = 12;
  bool _hasNext = true;
  bool _isFetching = false;
  List<Product> product = [];

  SearchProductProvider() : super(const []);

  Future searchProducts(String search) async {
    if (_isFetching) return;
    _isFetching = true;
    _hasNext = true;
    _productsSnapshot.clear();

    try {
      final snap = await SearchFirebaseApi.getSearchProducts(
        documentLimit,
        search,
        startAfter:
            _productsSnapshot.isNotEmpty ? _productsSnapshot.last : null,
      );
      _productsSnapshot.addAll(snap.docs);

      state = _productsSnapshot.map((snap) {
        final _product = snap.data();

        return Product(
          firestoreid: snap.id,
          uid: _product['uid'],
          title: _product['title'],
          category: _product['category'],
          favoriteuserlist: _product['favoriteuserlist'],
          price: _product['price'],
          hide: _product['hide'],
          deleted: _product['deleted'],
          images: _product['images'],
          bumptime: _product['bumptime'].toDate(),
        );
      }).toList();

      if (snap.docs.length < documentLimit) _hasNext = false;
    } catch (error) {}

    _isFetching = false;
  }

  Future searchNextProducts(String search) async {
    if (_isFetching || !_hasNext) return;
    _isFetching = true;
    _productsSnapshot.clear();

    try {
      final snap = await SearchFirebaseApi.getSearchProducts(
        documentLimit,
        search,
        startAfter:
            _productsSnapshot.isNotEmpty ? _productsSnapshot.last : null,
      );
      _productsSnapshot.addAll(snap.docs);

      state = _productsSnapshot.map((snap) {
        final _product = snap.data();

        return Product(
          firestoreid: snap.id,
          uid: _product['uid'],
          title: _product['title'],
          category: _product['category'],
          favoriteuserlist: _product['favoriteuserlist'],
          price: _product['price'],
          hide: _product['hide'],
          deleted: _product['deleted'],
          images: _product['images'],
          bumptime: _product['bumptime'].toDate(),
        );
      }).toList();

      if (snap.docs.length < documentLimit) _hasNext = false;
    } catch (error) {}

    _isFetching = false;
  }
}
