import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveFileData {
  final riveFile;
  final riveAnimation;
  RiveFileData({this.riveFile, this.riveAnimation});
}

class MyBoardCategoryIcon extends StatefulWidget {
  final riveFile;
  MyBoardCategoryIcon({Key key, this.riveFile}) : super(key: key);

  @override
  _MyPostIconState createState() => _MyPostIconState();
}

class _MyPostIconState extends State<MyBoardCategoryIcon> {
  RiveFileData riveFileData;
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  void _togglePlay() {
    setState(() => _controller.isActive = !_controller.isActive);
  }

  initRiveLoad() {
    String riveFile = riveFileData.riveFile;
    String riveAnimation = riveFileData.riveAnimation;
    print("riverFile : ${riveFile}");
    print("riverFile : ${riveAnimation}");
    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load(riveFile).then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard.We store a reference to it so we can toggle playback.
        artboard.addController(_controller = SimpleAnimation(riveAnimation));
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  @override
  void initState() {
    riveFileData = widget.riveFile;

    initRiveLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _togglePlay();
      },
      child: Container(
        child: Center(
          child: _riveArtboard == null
              ? const SizedBox()
              : Rive(artboard: _riveArtboard),
        ),
      ),
    );
  }
}
