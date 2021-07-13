import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:onestep_rezero/product/models/product.dart';
import 'package:onestep_rezero/search/utils/searchFirebaseApi.dart';

class SearchProductProvider extends ChangeNotifier {
  final _algoliaSnapshot = <AlgoliaObjectSnapshot>[];
  final int limit = 12;
  int page = 0;
  bool hasNext = true;
  bool isFetching = false;

  List<Product> get products => _algoliaSnapshot.map((snap) {
        return Product.fromJson(snap.data, snap.objectID);
      }).toList();

  Future searchProducts(String search) async {
    if (isFetching) return;
    _algoliaSnapshot.clear();
    isFetching = true;
    hasNext = true;
    page = 0;

    final snap = await SearchFirebaseApi.getSearchProducts(page, limit, search,
        startAfter: 0);
    _algoliaSnapshot.addAll(snap);

    if (snap.length < limit) hasNext = false;

    isFetching = false;
    notifyListeners();
  }

  Future searchNextProducts(String search) async {
    if (isFetching || !hasNext) return;
    isFetching = true;

    try {
      final snap = await SearchFirebaseApi.getSearchProducts(
          ++page, limit, search,
          startAfter: _algoliaSnapshot.isEmpty
              ? 0
              : _algoliaSnapshot.last.data['bumpTime']);
      _algoliaSnapshot.addAll(snap);

      if (snap.length < limit) hasNext = false;
    } catch (error) {}

    isFetching = false;
    notifyListeners();
  }

  void clearList() {
    _algoliaSnapshot.clear();
  }
}
