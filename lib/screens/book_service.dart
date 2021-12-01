import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/data_models/user.dart';
import 'package:flutter_app_one/my_widgets/text_field.dart';
import 'package:flutter_app_one/screens/camera_screen.dart';
import 'package:flutter_app_one/screens/home_screen.dart';
import 'package:flutter_app_one/utils/app_colors.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dotted_border/dotted_border.dart';

class BookServiceScreen extends StatefulWidget {
  final int depId;
  final String serviceName;
  final String vibhag;
  final String cameraImgPath = '';

  const BookServiceScreen(
      {Key? key,
      String? cameraImgPath,
      required this.depId,
      required this.serviceName,
      required this.vibhag})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _BookServiceScreenState(cameraImgPath, depId, serviceName, vibhag);
  }
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  final descriptionController = TextEditingController();

  final int depId;
  final String serviceName;
  final String vibhag;
  String cameraImgPath;

  String fileName = '';
  late PlatformFile media;
  late UserPreferences prefs;
  late Future<User> user;
  late String name;
  late String phone;
  late String address;
  late String email;

  @override
  void initState() {
    super.initState();
  }

  _BookServiceScreenState(
      this.cameraImgPath, this.depId, this.serviceName, this.vibhag);

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  late BuildContext dialogContext;
  late BuildContext buildContext;

  Future<UserPreferences> _setupUser() async {
    prefs = UserPreferences();
    prefs.getName().then((value) => name = value);
    prefs.getEmail().then((value) => email = value);
    prefs.getAddress().then((value) => address = value);
    prefs.getPhone().then((value) => phone = value);
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return SafeArea(
        child: WillPopScope(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Scaffold(
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Align(
                      alignment: Alignment(-0.25, 0.0),
                      child: Text(
                        "Book Service",
                        style: TextStyle(color: AppColors.appGrey),
                      )),
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  leading: IconButton(
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.appGrey,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          buildContext,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const HomeScreen()),
                          (route) => false,
                        );
                      }),
                ),
                body: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                        child: FutureBuilder(
                            future: _setupUser(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return bookingForm();
                              } else {
                                return const CircularProgressIndicator();
                              }
                            }))))
          ],
        ),
      ),
      onWillPop: () async {
        Navigator.pushReplacement(
          buildContext,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomeScreen()),
        );
        return false;
      },
    ));
  }

  Container bookingForm() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 70.0),
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              heading('Full Name'),
              MyTextField(
                active: false,
                type: TextInputType.name,
                hint: name,
                key: null,
              ),
              heading('Email'),
              MyTextField(
                active: false,
                type: TextInputType.emailAddress,
                hint: email,
                key: null,
              ),
              heading('Phone'),
              MyTextField(
                active: false,
                length: 10,
                type: TextInputType.phone,
                hint: phone,
                key: null,
              ),
              heading('Address'),
              MyTextField(
                active: false,
                type: TextInputType.streetAddress,
                hint: address,
                key: null,
              ),
              heading('Department (Vibhag)'),
              MyTextField(
                active: false,
                hint: vibhag,
              ),
              heading('Service Name'),
              MyTextField(
                active: false,
                hint: serviceName,
              ),
              heading('Short Description'),
              MyTextField(
                myController: descriptionController,
                type: TextInputType.multiline,
                hint: "Please write a short description about the problem",
              ),
              const SizedBox(
                height: 40.0,
              ),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        pickFile();
                      },
                      child: DottedBorder(
                        customPath: (size) {
                          return Path()
                            ..moveTo(0, 40)
                            ..lineTo(size.width, 40);
                        },
                        borderType: BorderType.RRect,
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          children: <Widget>[
                            const Text('Brwose Photo'),
                            Text(fileName),
                          ],
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     showCamera();
                    //   },
                    //   child: DottedBorder(
                    //     customPath: (size) {
                    //       return Path()
                    //         ..moveTo(0, 40)
                    //         ..lineTo(size.width, 40);
                    //     },
                    //     borderType: BorderType.RRect,
                    //     padding: EdgeInsets.all(6),
                    //     child: Column(
                    //       children: <Widget>[
                    //         Text('Open Camera'),
                    //         Text(cameraImgPath),
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ]),
              const SizedBox(
                height: 40.0,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () async {
                  await booknow();
                },
                icon: Image.asset('assets/images/book_button.png'),
                iconSize: 40.0,
              )
            ]));
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = result.files.first;
      media = file;
      setState(() {
        fileName = file.name;
      });
    } else {
      // User canceled the picker
    }
  }

  Padding heading(title) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.appGrey,
        ),
      ),
    );
  }

  void showLoader(int i) {
    showDialog(
        barrierDismissible: false,
        context: buildContext,
        builder: (BuildContext context) {
          dialogContext = context;
          return WillPopScope(
              child: Dialog(
                backgroundColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    child: ((i == 1)
                        ? Image.asset(
                            'assets/images/loader.png',
                            width: 100.0,
                          )
                        : Image.asset('assets/images/done.png', width: 100.0)),
                  ),
                ),
              ),
              onWillPop: () async => false);
        });
  }

  booknow() async {
    showLoader(1);

    String descr = descriptionController.text;

    var request = MultipartRequest("POST", Uri.parse(AppUrl.insertbooking));
    UserPreferences preferences = UserPreferences();
    Future<User> user = preferences.getUser();
    user.then((value) async {
      request.fields['user_id'] = value.userId;
      request.fields['name'] = value.name;
      request.fields['address'] = value.address;
      request.fields['email'] = value.email;
      request.fields['phone'] = value.phone;
      request.fields['service'] = serviceName;
      request.fields['department'] = vibhag;
      request.fields['sdescr'] = descr;
      if (fileName != '') {
        request.files.add(MultipartFile(
            'media',
            File(media.path.toString()).readAsBytes().asStream(),
            File(media.path.toString()).lengthSync(),
            filename: media.path.toString().split("/").last,
            contentType: MediaType('image', 'jpeg')));
      }
      if (cameraImgPath != '') {
        request.files.add(MultipartFile(
            'media1',
            File(cameraImgPath).readAsBytes().asStream(),
            File(cameraImgPath).lengthSync(),
            filename: cameraImgPath.split("/").last,
            contentType: MediaType('image', 'jpeg')));
      }
    });

    await request.send().then((value) {
      if (value.statusCode == 200) {
        Navigator.pop(dialogContext);
        showLoader(2);
        Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        });
      }
    });
  }

  showCamera() async {
    Navigator.pushReplacement(
        buildContext,
        MaterialPageRoute(
            builder: (context) => CameraScreen(
                  depId: depId,
                  serviceName: serviceName,
                  vibhag: vibhag,
                )));
  }
}
