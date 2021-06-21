import 'dart:math';

class CreateRandomNumberNotDuplicated {
  final int length;
  List<int> _initList = [];
  List<int> _randomList = [];
  var _rng = new Random();
  CreateRandomNumberNotDuplicated({this.length}) {
    reset();
    makeRandom();
  }
  reset() {
    _initList = List<int>.generate(length, (index) => index);
    _randomList = [];
  }

  makeRandom() {
    int randomNumber;
    for (int i = 0; i < length; i++) {
      // if (length - i - 1 == 0) {
      //   _randomList.add(_initList.removeAt(0));
      // } else {
      randomNumber = _rng.nextInt(length - i);
      int pickNumber = _initList.removeAt(randomNumber);
      _randomList.add(pickNumber);
      // }
    }
  }

  get getRandomNumberList => _randomList;
}
