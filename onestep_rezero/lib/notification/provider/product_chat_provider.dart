import 'package:flutter_riverpod/flutter_riverpod.dart';

final productChatProvider = StateController<dynamic>((ref) {
  print('>>>In ProductChat Provider');
  return '';
});
