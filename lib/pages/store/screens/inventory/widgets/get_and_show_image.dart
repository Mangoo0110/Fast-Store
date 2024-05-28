// import 'dart:async';
// import 'dart:typed_data';

// import 'package:easypos/common/widgets/show_image.dart';
// import 'package:easypos/data/datasources/firebase/firebase_image_repo_impl.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class GetAndShowImageWidget extends StatefulWidget {
//   final String imageId;
//   final double height;
//   final double width;
//   const GetAndShowImageWidget({super.key, required this.imageId, required this.height, required this.width});

//   @override
//   State<GetAndShowImageWidget> createState() => _GetAndShowImageWidgetState();
// }

// class _GetAndShowImageWidgetState extends State<GetAndShowImageWidget> {

//   Uint8List? thisImage;
//   //functions 

//   Future<Uint8List?> getImage() async{
//     await FirebaseImageRepoImpl().fetchImage(imageId: widget.imageId)
//     .then((dataResult) {
//         dataResult
//           .fold(
//             (dataFailure) {
//               //Fluttertoast.showToast(msg: "Failed! \n ${dataFailure.message}");
//             } ,
//             (fetchedImage) {
//               thisImage = fetchedImage;
//             }
//           );
//       });
//     return thisImage;
//   }


  
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return 
//       },
//     );
//   }
// }