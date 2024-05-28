import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

import 'package:easypos/utils/app_textstyles.dart';
import 'package:easypos/utils/dekhao.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class UploadImage extends StatefulWidget {
  final Function (Uint8List pickedImage) onPick;
  const UploadImage({required this.onPick, super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  Uint8List? image;

  //functions :: 
  Future<File> uint8ListToFile(Uint8List uint8List, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(uint8List);
    return file;
  }

  Future pickImage() async {
    try {
      final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 15);
      if(returnedImage == null) return;
      setState(() {
        image = File(returnedImage.path).readAsBytesSync();
        if(image == null){
          return;
        }
          widget.onPick(image!);
      });
    } catch (error) {
      dekhao(error.toString());
      Fluttertoast.showToast(msg: "Failed to pick image. Internal error!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return InkWell(
          onTap: () async{
            await pickImage();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.file_copy),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('Browse files', style: AppTextStyle().actionBoldNormalSize(context: context),),
                ),
              ],
            ),
          )
        );
      },
    );
  }
}