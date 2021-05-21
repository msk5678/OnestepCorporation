import 'package:algolia/algolia.dart';
import 'package:onestep_rezero/main.dart';

Algolia algolia = Algolia.init(
  applicationId: 'SM0LVJM1EL',
  apiKey: '67bfc3f1aa7f241789e0a88b2c90a3b9',
);

class SearchFirebaseApi {
  static Future<List<AlgoliaObjectSnapshot>> getSearchProducts(
      int page, int limit, String search,
      {int startAfter}) async {
    AlgoliaQuery query = algolia.instance
        .index('university_' + currentUserModel.university + '_product')
        .query(search)
        .setHitsPerPage(limit);

    AlgoliaQuerySnapshot querySnap;
    if (startAfter == 0) {
      querySnap = await query.getObjects();
    } else {
      querySnap = await query.filters('bumpTime < $startAfter').getObjects();
    }

    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }
}
