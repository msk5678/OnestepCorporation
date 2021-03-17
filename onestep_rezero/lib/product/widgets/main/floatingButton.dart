import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final floatingStateProvider = StateProvider<bool>((ref) {
  return false;
});

class FloatingButton extends ConsumerWidget {
  const FloatingButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Visibility(
      visible: context.read(floatingStateProvider).state,
      child: Container(
        height: 40.0,
        width: 40.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.keyboard_arrow_up_rounded, color: Colors.black),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.0))),
          ),
        ),
      ),
    );
  }
}
