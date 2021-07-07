import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/search/utils/searchFirebaseApi.dart';

class SearchProductProvider extends ChangeNotifier {
  final _algoliaSnapshot = <AlgoliaObjectSnapshot>[];
  final int limit = 12;
  int page = 0;
  bool _hasNext = true;
  bool _isFetching = false;

  List<Product> get products => _algoliaSnapshot.map((snap) {
        return Product.fromJson(snap.data, snap.objectID);
        // final _product = snap.data;

        // return Product(
        //   firestoreid: snap.objectID,
        //   uid: _product['uid'],
        //   title: _product['title'],
        //   category: _product['category'],
        //   favoriteUserList: _product['favoriteUserList'],
        //   price: _product['price'],
        //   trading: _product['trading'],
        //   completed: _product['completed'],
        //   hide: _product['hide'],
        //   deleted: _product['deleted'],
        //   imagesUrl: _product['imagesUrl'],
        //   bumpTime: DateTime.fromMicrosecondsSinceEpoch(_product['bumpTime']),
        // );
      }).toList();

  Future searchProducts(String search) async {
    if (_isFetching) return;
    _algoliaSnapshot.clear();
    _isFetching = true;
    _hasNext = true;
    page = 0;

    final snap = await SearchFirebaseApi.getSearchProducts(page, limit, search,
        startAfter: 0);
    _algoliaSnapshot.addAll(snap);

    if (snap.length < limit) _hasNext = false;

    _isFetching = false;
    notifyListeners();
  }

  Future searchNextProducts(String search) async {
    if (_isFetching || !_hasNext) return;
    _isFetching = true;

    try {
      final snap = await SearchFirebaseApi.getSearchProducts(
          ++page, limit, search,
          startAfter: _algoliaSnapshot.isEmpty
              ? 0
              : _algoliaSnapshot.last.data['bumpTime']);
      _algoliaSnapshot.addAll(snap);

      if (snap.length < limit) _hasNext = false;
    } catch (error) {}

    _isFetching = false;
    notifyListeners();
  }

  void clearList() {
    _algoliaSnapshot.clear();
  }
}
