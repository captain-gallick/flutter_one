import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/my_widgets/text_field.dart';
import 'package:flutter_app_one/screens/home_screen.dart';
import 'package:flutter_app_one/utils/app_colors.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class BookServiceScreen extends StatefulWidget {
  final int depId;
  final String serviceName;
  final String serviceId;
  final String vibhag;
  final String cameraImgPath = '';

  const BookServiceScreen(
      {Key? key,
      String? cameraImgPath,
      required this.depId,
      required this.serviceName,
      required this.serviceId,
      required this.vibhag})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _BookServiceScreenState(
        cameraImgPath, depId, serviceName, vibhag, serviceId);
  }
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  final descriptionController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  //final addressController = TextEditingController();
  final aadharController = TextEditingController();
  final buildingController = TextEditingController();
  final areaController = TextEditingController();
  final wardController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();

  final int depId;
  final String serviceName;
  final String serviceId;
  final String vibhag;
  String cameraImgPath;

  String fileName = '';
  late PlatformFile media;
  late UserPreferences prefs;

  @override
  void initState() {
    super.initState();
  }

  _BookServiceScreenState(this.cameraImgPath, this.depId, this.serviceName,
      this.vibhag, this.serviceId);

  @override
  void dispose() {
    descriptionController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    //addressController.dispose();
    aadharController.dispose();
    buildingController.dispose();
    areaController.dispose();
    wardController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  late BuildContext dialogContext;
  late BuildContext buildContext;

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
                    child: SingleChildScrollView(child: bookingForm())))
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
    if (fileName != '') {
      UserPreferences().getTempData().then((value) => {
            nameController.text = value[0],
            emailController.text = value[1],
            phoneController.text = value[2],
            buildingController.text = value[3],
            areaController.text = value[4],
            wardController.text = value[5],
            pincodeController.text = value[6],
            cityController.text = value[7],
          });
    } else {
      UserPreferences().getUser().then((value) {
        UserPreferences().saveTempData(value.name, value.email, value.phone,
            value.building, value.area, value.ward, value.pincode, value.city);
        UserPreferences().getTempData().then((value) => {
              nameController.text = value[0],
              emailController.text = value[1],
              phoneController.text = value[2],
              buildingController.text = value[3],
              areaController.text = value[4],
              wardController.text = value[5],
              pincodeController.text = value[6],
              cityController.text = value[7],
            });
      });
    }

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
                active: true,
                type: TextInputType.name,
                hint: 'Full Name',
                myController: nameController,
              ),
              heading('Email'),
              MyTextField(
                active: true,
                type: TextInputType.emailAddress,
                hint: 'Email',
                myController: emailController,
              ),
              /* heading('Aadhar Number'),
              MyTextField(
                active: true,
                length: 12,
                type: TextInputType.number,
                hint: 'Adhaar Number',
                text: adhaar,
                myController: aadharController,
              ), */
              heading('Phone'),
              MyTextField(
                length: 10,
                active: false,
                type: TextInputType.phone,
                hint: 'Phone',
                myController: phoneController,
              ),
              /* heading('Address'),
              MyTextField(
                active: true,
                hint: 'Address',
                type: TextInputType.streetAddress,
                text: address,
                myController: addressController,
              ), */
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
              heading('Building'),
              MyTextField(
                active: true,
                type: TextInputType.streetAddress,
                myController: buildingController,
                hint: 'Building',
              ),
              heading('Area'),
              MyTextField(
                active: true,
                type: TextInputType.streetAddress,
                myController: areaController,
                hint: 'Area',
              ),
              heading('Ward'),
              MyTextField(
                active: true,
                type: TextInputType.streetAddress,
                myController: wardController,
                key: null,
                hint: 'Ward',
              ),
              heading('City'),
              MyTextField(
                active: true,
                type: TextInputType.streetAddress,
                myController: cityController,
                key: null,
                hint: 'City',
              ),
              heading('Pincode'),
              MyTextField(
                active: true,
                type: TextInputType.number,
                myController: pincodeController,
                length: 6,
                key: null,
                hint: 'Pincode',
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
                    Column(
                      children: <Widget>[
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            iconSize: 100.0,
                            onPressed: () {
                              pickFile();
                            },
                            icon: Image.asset(
                                'assets/images/browse_photo_btn.png')),
                        Text(fileName),
                      ],
                    ),
                    /* Column(
                  children: <Widget>[
                    IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 100.0,
                        onPressed: () {
                          pickFile();
                        },
                        icon: Image.asset('assets/images/open_camera_btn.png')),
                    Text(fileName),
                  ],
                ), */
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
    UserPreferences().saveTempData(
        nameController.text,
        emailController.text,
        phoneController.text,
        buildingController.text,
        areaController.text,
        wardController.text,
        pincodeController.text,
        cityController.text);

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final file = result.files.first;
      media = file;
      setState(() {
        if (file.name.length > 10) {
          fileName = file.name.substring(0, 10);
        } else {
          fileName = file.name;
        }
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
    String token = '';
    String lat = '';
    String lng = '';
    await UserPreferences().getUser().then(
        (value) => {token = value.token, lat = value.lat, lng = value.long});

    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        buildingController.text.isNotEmpty &&
        areaController.text.isNotEmpty &&
        wardController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        phoneController.text.length == 10 &&
        pincodeController.text.length == 6) {
      showLoader(1);

      var request = MultipartRequest("POST", Uri.parse(AppUrl.insertbooking));
      request.headers.addAll(<String, String>{"token": token});

      request.fields['name'] = nameController.text;
      request.fields['email'] = emailController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['service'] = serviceId;
      request.fields['department'] = depId.toString();
      //request.fields['aadhar'] = aadharController.text;
      //request.fields['address'] = addressController.text;
      request.fields['building'] = buildingController.text;
      request.fields['area'] = areaController.text;
      request.fields['ward'] = wardController.text;
      request.fields['pincode'] = pincodeController.text;
      request.fields['city'] = cityController.text;
      request.fields['lat'] = lat;
      request.fields['lng'] = lng;
      request.fields['sdescr'] = descriptionController.text;
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

      /* log(request.fields.toString());
      log(request.files.toString());
      log(request.headers.toString()); */

      var response = await request.send();
      if (response.statusCode == 200) {
        Navigator.pop(dialogContext);
        showLoader(2);
        Timer(const Duration(seconds: 3), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        });
      } else {
        Navigator.pop(dialogContext);
        log(response.statusCode.toString());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("An Error occured"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter valid details"),
      ));
    }
  }

  // showCamera() async {
  //   Navigator.pushReplacement(
  //       buildContext,
  //       MaterialPageRoute(
  //           builder: (context) => CameraScreen(
  //                 depId: depId,
  //                 serviceName: serviceName,
  //                 vibhag: vibhag,
  //               )));
  // }
}
