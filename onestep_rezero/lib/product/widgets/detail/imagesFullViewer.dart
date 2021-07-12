import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImagesFullViewer extends StatefulWidget {
  final List<dynamic> imagesUrl;
  final int index;
  ImagesFullViewer({Key key, this.imagesUrl, this.index}) : super(key: key);

  @override
  _ImagesFullViewerState createState() => _ImagesFullViewerState();
}

class _ImagesFullViewerState extends State<ImagesFullViewer> {
  bool _isVisibility;
  int currentIndex;
  PageController _pageController;
  StreamController<bool> _screenTapStreamController =
      new StreamController<bool>.broadcast();

  @override
  void initState() {
    _isVisibility = true;
    currentIndex = widget.index + 1;
    _pageController = PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  void dispose() {
    _screenTapStreamController.close();
    super.dispose();
  }

  PreferredSizeWidget appbar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight / 2),
      child: StreamBuilder<bool>(
        stream: _screenTapStreamController.stream,
        initialData: _isVisibility,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Opacity(
            opacity: snapshot.data ? 1 : 0,
            child: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                padding: EdgeInsets.only(top: 0),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: kToolbarHeight / 2.5,
                ),
              ),
              // centerTitle: true,
              // title: Text(
              //   '물품사진',
              //   style: TextStyle(
              //     color: Colors.white,
              //   ),
              // ),
              elevation: 0,
              backgroundColor: Colors.black.withOpacity(0.3),
            ),
          );
        },
      ),
    );
  }

  Widget countFloatingActionButton() {
    return StreamBuilder<bool>(
      stream: _screenTapStreamController.stream,
      initialData: _isVisibility,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return Visibility(
          visible: snapshot.data,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 8.0,
            ),
            child: Container(
              padding: EdgeInsets.only(
                  top: 8.0, bottom: 8.0, right: 12.0, left: 12.0),
              color: Colors.black.withOpacity(0.3),
              child: Text(
                "$currentIndex/${widget.imagesUrl.length}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index + 1;
    });
  }

  void _onImagePointerUp(
      BuildContext c, TapUpDetails d, PhotoViewControllerValue v) {
    _isVisibility = !_isVisibility;
    _screenTapStreamController.sink.add(_isVisibility);
  }

  Widget body() {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      child: PhotoViewGallery.builder(
        onPageChanged: _onPageChanged,
        pageController: _pageController,
        itemCount: widget.imagesUrl.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(widget.imagesUrl[index]),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * 1,
            maxScale: PhotoViewComputedScale.covered * 2,
            onTapUp: _onImagePointerUp,
          );
        },
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 30.0.w,
            height: 30.0.h,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SafeArea(
        top: false,
        child: body(),
      ),
      floatingActionButton: countFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
