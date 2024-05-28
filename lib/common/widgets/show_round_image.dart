import 'dart:math';
import 'dart:typed_data';

import 'package:easypos/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ShowRoundImage extends StatefulWidget {
  final Uint8List? image;
  final double height;
  final double width;
  final double borderRadius;
  const ShowRoundImage({super.key, required this.image, required this.height, required this.width, required this.borderRadius});

  @override
  State<ShowRoundImage> createState() => _ShowRoundImageState();
}

class _ShowRoundImageState extends State<ShowRoundImage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: AppColors().grey(),
            borderRadius: BorderRadius.circular(800000),
          ),
          child: widget.image == null ?
          Icon(Icons.image, color: Colors.white, size: min(widget.height, widget.width) - 2,)
          :
          ClipOval(
            child: Image.memory(
              widget.image!,
              fit: BoxFit.cover,
              height: widget.height,
              width: widget.width,
            ),
          ),
        );
      },
    );
  }
}