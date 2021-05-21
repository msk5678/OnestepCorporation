import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class ConvertImages extends StatefulWidget {
  /// The asset we want to show thumb for.
  final Asset asset;

  /// The thumb width
  final double width;

  /// The thumb height
  final double height;

  /// The thumb quality
  final int quality;

  /// This is the widget that will be displayed while the
  /// thumb is loading.
  final Widget spinner;

  const ConvertImages({
    Key key,
    @required this.asset,
    @required this.width,
    @required this.height,
    this.quality = 100,
    this.spinner = const Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    ),
  }) : super(key: key);

  @override
  _ConvertImagesState createState() => _ConvertImagesState();
}

class _ConvertImagesState extends State<ConvertImages> {
  ByteData _thumbData;

  double get width => widget.width;
  double get height => widget.height;
  int get quality => widget.quality;
  Asset get asset => widget.asset;
  Widget get spinner => widget.spinner;

  @override
  void initState() {
    super.initState();
    this._loadThumb();
  }

  @override
  void didUpdateWidget(ConvertImages oldWidget) {
    if (oldWidget.asset.identifier != widget.asset.identifier) {
      this._loadThumb();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _loadThumb() async {
    setState(() {
      _thumbData = null;
    });

    ByteData thumbData = await asset.getByteData(
      quality: quality,
    );

    if (this.mounted) {
      setState(() {
        _thumbData = thumbData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbData == null) {
      return spinner;
    }
    return Image.memory(
      _thumbData.buffer.asUint8List(),
      width: widget.width,
      height: widget.height,
      key: ValueKey(asset.identifier),
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
  }
}
