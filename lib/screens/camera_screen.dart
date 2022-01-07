// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_one/screens/book_service.dart';

// class CameraScreen extends StatefulWidget {
//   final String vibhag;
//   final int depId;
//   final String serviceName;
//   const CameraScreen({
//     Key? key,
//     required this.vibhag,
//     required this.depId,
//     required this.serviceName,
//   }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     // ignore: no_logic_in_create_state
//     return _CameraScreenState(vibhag, depId, serviceName);
//   }
// }

// class _CameraScreenState extends State<CameraScreen> {
//   final String vibhag;
//   final int depId;
//   final String serviceName;
//   late List<CameraDescription> cameras;
//   late CameraController controller;
//   bool _isReady = false;

//   _CameraScreenState(this.vibhag, this.depId, this.serviceName);

//   @override
//   void initState() {
//     super.initState();
//     _setupCameras();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isReady) {
//       return Container();
//     } else {
//       return WillPopScope(
//         onWillPop: () async {
//           Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => BookServiceScreen(
//                         depId: depId,
//                         serviceName: serviceName,
//                         vibhag: vibhag,
//                       )));
//           return false;
//         },
//         child: Scaffold(
//           body: CameraPreview(controller),
//           floatingActionButton: FloatingActionButton(
//             onPressed: () async {
//               // Take the Picture in a try / catch block. If anything goes wrong,
//               // catch the error.
//               try {
//                 // Ensure that the camera is initialized.
//                 //await _initializeControllerFuture;

//                 // Attempt to take a picture and get the file `image`
//                 // where it was saved.
//                 final image = await controller.takePicture();

//                 // If the picture was taken, display it on a new screen.
//                 await Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => DisplayPictureScreen(
//                       // Pass the automatically generated path to
//                       // the DisplayPictureScreen widget.
//                       imagePath: image.path, depId: depId,
//                       serviceName: serviceName, vibhag: serviceName,
//                     ),
//                   ),
//                 );
//               } catch (e) {
//                 // If an error occurs, log the error to the console.
//                 //print(e);
//               }
//             },
//             child: const Icon(Icons.camera_alt),
//           ),
//         ),
//       );
//     }
//   }

//   Future<void> _setupCameras() async {
//     try {
//       // initialize cameras.
//       cameras = await availableCameras();
//       // initialize camera controllers.
//       controller = CameraController(cameras[0], ResolutionPreset.medium);
//       await controller.initialize();
//     } on CameraException catch (_) {
//       // do something on error.
//     }
//     if (!mounted) return;
//     setState(() {
//       _isReady = true;
//     });
//   }
// }

// // A widget that displays the picture taken by the user.
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;
//   final String vibhag;
//   final String serviceName;
//   final int depId;

//   const DisplayPictureScreen(
//       {Key? key,
//       required this.imagePath,
//       required this.vibhag,
//       required this.serviceName,
//       required this.depId})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => CameraScreen(
//                     depId: depId, serviceName: serviceName, vibhag: vibhag)));

//         return false;
//       },
//       child: Scaffold(
//         // The image is stored as a file on the device. Use the `Image.file`
//         // constructor with the given path to display the image.
//         body: Image.file(File(imagePath)),
//         floatingActionButton: FloatingActionButton(
//             child: const Icon(Icons.done),
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => BookServiceScreen(
//                     // Pass the automatically generated path to
//                     // the DisplayPictureScreen widget.
//                     cameraImgPath: imagePath, depId: depId,
//                     serviceName: serviceName, vibhag: serviceName,
//                   ),
//                 ),
//               );
//             }),
//       ),
//     );
//   }
// }
