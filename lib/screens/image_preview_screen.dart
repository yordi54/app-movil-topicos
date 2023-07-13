import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String imageFile;
  const ImagePreviewScreen({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.file(File(imageFile))
        ),
        floatingActionButton:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: () => Navigator.pop(context, null),
              heroTag: 'preview-back',
              child: const Icon(Icons.arrow_back),
            ),
            FloatingActionButton(
              onPressed: () => Navigator.pop(context, imageFile),
              heroTag: 'preview-accept',
              child: const Icon(Icons.check),
            ),
          ],
        ),
    );
  }
}