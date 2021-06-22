import 'package:flutter/material.dart';
import 'package:flutter_5/widget/camera_button_widget.dart';
import 'package:flutter_5/widget/gallery_button_widget.dart';

class SourcePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Source'),
      ),
      body: ListView(
        children: [
          CameraButtonWidget(),
          GalleryButtonWidget(),
        ],
      ),
    );
  }
}
