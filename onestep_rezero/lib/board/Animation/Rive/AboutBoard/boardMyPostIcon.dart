import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveFileData {
  final riveFile;
  final riveAnimation;
  final riveStateMachine;

  RiveFileData({this.riveFile, this.riveAnimation, this.riveStateMachine});
}

class MyBoardCategoryIcon extends StatefulWidget {
  final riveFileData;
  final double width;
  final double height;
  final Stream<bool> stream;
  MyBoardCategoryIcon(
      {Key key, this.riveFileData, this.height, this.width, this.stream})
      : super(key: key);

  @override
  _MyPostIconState createState() => _MyPostIconState();
}

class _MyPostIconState extends State<MyBoardCategoryIcon> {
  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard _riveArtboard;
  StateMachineController _controller;

  SMIInput<bool> _pressInput;
  bool isActive = false;

  double widgetWidth;
  double widgetHeight;

  updateMethod() {
    setState(() {});
  }

  @override
  void initState() {
    widgetWidth = widget.width;
    widgetHeight = widget.height;
    String loadRivePath = widget.riveFileData.riveFile;
    // String loadRiveAnimation = widget.riveFileData.riveFile;
    String loadRiveStateMachine = widget.riveFileData.riveStateMachine;
    super.initState();
    widget.stream.listen((bool isPlay) {
      updateMethod();
    });
    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load(loadRivePath).then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, loadRiveStateMachine);
        if (controller != null) {
          artboard.addController(controller);

          _pressInput = controller.findInput('Start');
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) => toggle());
    return Center(
      child: _riveArtboard == null
          ? Container(
              child: Text("_RIVE ART BOARD IS NULL"),
            )
          : SizedBox(
              width: widgetWidth,
              height: widgetHeight,
              child: Rive(
                artboard: _riveArtboard,
              ),
            ),
    );
  }

  void toggle() {
    if (!isActive) {
      if (_pressInput != null) {
        isActive = true;
        _pressInput.value = true;
        Future.delayed(Duration(seconds: 1)).then((value) {
          _pressInput.value = false;
          isActive = false;
        });
      }
    }
  }
}
