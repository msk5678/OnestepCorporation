import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onestep_rezero/product/models/product.dart';

import '../productFirebaseApi.dart';

final productMainServiceProvider = Provider<ProductMainService>((ref) {
  return ProductMainService();
});

class ProductMainService {
  final _productsSnapshot = <DocumentSnapshot>[];
  final int documentLimit = 12;
  bool _hasNext = true;
  bool _isFetchingUsers = false;

  List<Product> get products => _productsSnapshot.map((snap) {
        final product = snap.data();

        return Product(
          firestoreid: snap.id,
          uid: product['uid'],
          title: product['title'],
          category: product['category'],
          favoriteuserlist: product['favoriteuserlist'],
          price: product['price'],
          hide: product['hide'],
          deleted: product['deleted'],
          images: product['images'],
          bumptime: product['bumptime'].toDate(),
        );
      }).toList();

  Future fetchProducts() async {
    if (_isFetchingUsers) return;
    _isFetchingUsers = true;
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
    _isFetchingUsers = false;
  }

  Future fetchNextProducts() async {
    if (_isFetchingUsers || !_hasNext) return;
    _isFetchingUsers = true;

    try {
      final snap = await ProductFirebaseApi.getAllProducts(
        documentLimit,
        startAfter:
            _productsSnapshot.isNotEmpty ? _productsSnapshot.last : null,
      );
      _productsSnapshot.addAll(snap.docs);

      if (snap.docs.length < documentLimit) _hasNext = false;
    } catch (error) {}

    _isFetchingUsers = false;
  }
}
