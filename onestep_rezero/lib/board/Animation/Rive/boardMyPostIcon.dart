import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveFileData {
  final riveFile;
  final riveAnimation;

  RiveFileData({
    this.riveFile,
    this.riveAnimation,
  });
}

class MyBoardCategoryIcon extends StatefulWidget {
  final riveFile;
  final width;
  final height;
  MyBoardCategoryIcon({Key key, this.riveFile, this.height, this.width})
      : super(key: key);

  @override
  _MyPostIconState createState() => _MyPostIconState();
  void target() {
    _MyPostIconState().startAnimation();
  }
}

class _MyPostIconState extends State<MyBoardCategoryIcon> {
  bool get isPlaying => _controller?.isActive ?? false;
  RiveFileData riveFileData;
  Artboard _riveArtboard;
  StateMachineController _controller;
  SMIInput<bool> _pressInput;

  double widgetWidth;
  double widgetHeight;

  // void _togglePlay() {
  //   setState(() => _controller.isActive = !_controller.isActive);
  // }

  initRiveLoad() {
    String riveFile = riveFileData.riveFile;
    String riveAnimation = riveFileData.riveAnimation;

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load(riveFile).then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, riveAnimation);
        if (controller != null) {
          artboard.addController(controller);

          _pressInput = controller.findInput('Start');
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  void initState() {
    riveFileData = widget.riveFile;
    widgetWidth = widget.width ?? 100;
    widgetHeight = widget.height ?? 100;
    initRiveLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("_pressInput.value : ${_pressInput}");
    startAnimation();
    return Center(
        child: _riveArtboard == null
            ? Container(
                child: Text("RiveArtBoard is Null"),
              )
            : SizedBox(
                width: widgetWidth,
                height: widgetHeight,
                child: Rive(
                  artboard: _riveArtboard,
                ),
              ));
  }

  void startAnimation() {
    _pressInput.value = true;
    Future.delayed(Duration(seconds: 1))
        .then((value) => _pressInput.value = false);
  }
}
