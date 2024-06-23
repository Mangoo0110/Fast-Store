import 'dart:typed_data';

import 'package:easypos/common/widgets/image_related/show_rect_image.dart';
import 'package:easypos/common/widgets/image_related/upload_image.dart';
import 'package:flutter/material.dart';

class ImageShowUploadWidget extends StatefulWidget {
  final String? heroTagForImage;
  final Uint8List? image;
  final void Function (Uint8List image) onUpload;
  const ImageShowUploadWidget({super.key, required this.heroTagForImage, required this.image, required this.onUpload});

  @override
  State<ImageShowUploadWidget> createState() => _ImageShowUploadWidgetState();
}

class _ImageShowUploadWidgetState extends State<ImageShowUploadWidget> {
  Uint8List? thisImage;
  @override
  void initState() {
    // TODO: implement initState
    thisImage = widget.image;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: widget.heroTagForImage ?? 'dsvds',
              child: ShowRectImage(height: 140, width: 140, image: thisImage, borderRadius: 8,)
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UploadImage(
                onPick: (pickedImage) {
                  setState(() {
                    thisImage = pickedImage;
                    widget.onUpload(pickedImage);
                  });
                },
              )
            ),
          ],
        );
      },
    );
  }
}