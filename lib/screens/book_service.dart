import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/data_models/areas.dart';
import 'package:flutter_app_one/data_models/cities.dart';
import 'package:flutter_app_one/my_widgets/app_button.dart';
import 'package:flutter_app_one/my_widgets/text_field.dart';
import 'package:flutter_app_one/screens/home_screen.dart';
import 'package:flutter_app_one/screens/mark_location.dart';
import 'package:flutter_app_one/utils/app_colors.dart';
import 'package:flutter_app_one/utils/network_connecttion.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';
import 'package:flutter_app_one/utils/globals.dart' as globals;
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

class _BookServiceScreenState extends State<BookServiceScreen>
    with WidgetsBindingObserver {
  final descriptionController = TextEditingController();
  final nameController = TextEditingController();
  final buildingController = TextEditingController();
  final wardController = TextEditingController();

  final int depId;
  final String serviceName;
  final String serviceId;
  final String vibhag;
  String cameraImgPath;

  String fileName = '';
  String videoName = '';
  late PlatformFile media, media1;
  late UserPreferences prefs;

  String cityText = 'Select City';
  String cityId = '0';
  String areaId = '0';
  String areaText = 'Select Area';
  String pincodeText = 'Pincode';
  String name = '-';
  String building = '-';
  String ward = '-';

  List<Cities> cities = [];
  List<Areas> areas = [];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      super.didChangeAppLifecycleState(state);

      // These are the callbacks
      switch (state) {
        case AppLifecycleState.resumed:
          setState(() {});
          // widget is resumed
          break;
        case AppLifecycleState.inactive:
          // widget is inactive
          break;
        case AppLifecycleState.paused:

          // widget is paused
          break;
        case AppLifecycleState.detached:
          // widget is detached
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getUserDetails());
    WidgetsBinding.instance?.addObserver(this);
  }

  _BookServiceScreenState(this.cameraImgPath, this.depId, this.serviceName,
      this.vibhag, this.serviceId);

  @override
  void dispose() {
    descriptionController.dispose();
    nameController.dispose();
    buildingController.dispose();
    wardController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  late BuildContext dialogContext, waitDialogContext;
  late BuildContext buildContext;

  getUserDetails() {
    globals.locationUpdated = false;
    setState(() {
      UserPreferences().getUser().then((value) {
        name = name == '-' ? value.name : name;
        nameController.text = name;
        building = building == '-' ? value.building : building;
        buildingController.text = building;

        areaId = value.areaId;
        areaText = value.areaId != '0' ? value.areaName : areaText;
        ward = ward == '-' ? value.ward : ward;
        wardController.text = ward;

        cityId = value.cityId;
        cityText = value.cityId != '0' ? value.cityName : cityText;

        pincodeText = value.pincode == '0' ? pincodeText : value.pincode;
      });
    });
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
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 70.0),
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
              heading('Full Name*'),
              MyTextField(
                active: true,
                type: TextInputType.name,
                hint: 'Full Name',
                myController: nameController,
              ),
              heading('Building*'),
              MyTextField(
                active: true,
                type: TextInputType.streetAddress,
                myController: buildingController,
                hint: 'Building',
              ),
              heading('Ward*'),
              MyTextField(
                active: true,
                type: TextInputType.streetAddress,
                myController: wardController,
                key: null,
                hint: 'Ward',
              ),
              heading('City*'),
              GestureDetector(
                onTap: () {
                  NetworkCheckUp().checkConnection().then((value) {
                    if (value) {
                      getCities();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please connect to internet."),
                      ));
                    }
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffF4F7FE),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(cityText),
                    )),
              ),
              heading('Area*'),
              GestureDetector(
                onTap: () {
                  if (cityText != "Select City") {
                    NetworkCheckUp().checkConnection().then((value) {
                      if (value) {
                        getAreas(cityId);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Please connect to internet."),
                        ));
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please Select city"),
                    ));
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffF4F7FE),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(areaText),
                    )),
              ),
              heading('Pincode*'),
              Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffF4F7FE),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(pincodeText),
                  )),
              heading('Short Description'),
              MyTextField(
                myController: descriptionController,
                type: TextInputType.multiline,
                hint: "Please write a short description about the problem",
              ),
              const SizedBox(
                height: 40.0,
              ),
              heading('Current Location'),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FutureBuilder(
                    future: getLocationText(), // async work
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Text('Loading....');
                        default:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text('${snapshot.data}');
                          }
                      }
                    },
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppButton(
                      title: 'CHANGE LOCATION',
                      width: 200.0,
                      onPressed: () {
                        NetworkCheckUp().checkConnection().then((value) {
                          if (value) {
                            saveData();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const MarkLocationScreen()),
                            ).then((value) {
                              setState(() {});
                            });
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Please connect to internet."),
                            ));
                          }
                        });
                      }),
                ],
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
                        GestureDetector(
                          child: DottedBorder(
                            color: Colors.black,
                            strokeWidth: 1,
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text('Browse Photo'),
                            ),
                          ),
                          onTap: () {
                            pickFile();
                          },
                        ),

                        /* IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 100.0,
                        onPressed: () {
                          pickFile();
                        },
                        icon:
                            Image.asset('assets/images/browse_photo_btn.png')), */
                        Text(fileName),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          child: DottedBorder(
                            color: Colors.black,
                            strokeWidth: 1,
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text('Browse Video'),
                            ),
                          ),
                          onTap: () {
                            pickVideo();
                          },
                        ),
                        /* IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        iconSize: 100.0,
                        onPressed: () {
                          pickVideo();
                        },
                        icon: Image.asset('assets/images/open_camera_btn.png')), */
                        Text(videoName),
                      ],
                    ),
                  ]),
              const SizedBox(
                height: 40.0,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () async {
                  NetworkCheckUp().checkConnection().then((value) {
                    if (value) {
                      booknow();
                      /* if (globals.locationUpdated) {
                        booknow();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Please mark your location."),
                        ));
                      } */
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please connect to internet."),
                      ));
                    }
                  });
                },
                icon: Image.asset('assets/images/book_button.png'),
                iconSize: 40.0,
              )
            ]));
  }

  Future<String> getLocationText() async {
    List<String> array = await getCurrentLocation();
    String lat = array[0].toString();
    String lng = array[1].toString();
    return ('latitude: ' + lat.toString() + ', \nlongitude: ' + lng.toString())
        .toString();
  }

  late BuildContext listDialogContext;

  saveData() {
    name = nameController.text;
    building = buildingController.text;
    ward = wardController.text;
  }

  void showWaitLoader() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          waitDialogContext = context;
          return WillPopScope(
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      CircularProgressIndicator(),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text('Please wait...')),
                    ],
                  ),
                ),
              ),
              onWillPop: () async => false);
        });
  }

  Future<void> getCities() async {
    try {
      saveData();
      cities = [];
      showWaitLoader();
      String token = '';

      await UserPreferences().getUser().then((value) => {
            token = value.token,
          });
      final Response response = await get(
        Uri.parse(AppUrl.citiesUrl),
        headers: <String, String>{
          'token': token,
        },
      );

      log(response.body);
      if (jsonDecode(response.body)['data'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              jsonDecode(response.body)['message'].toString().toUpperCase()),
        ));
        Navigator.pop(dialogContext);
      } else {
        List<dynamic> list = jsonDecode(response.body)['data'];
        for (int i = 0; i < list.length; i++) {
          log(Cities.fromJson(list[i]).toString());
          cities.add(Cities.fromJson(list[i]));
        }
        Navigator.pop(waitDialogContext);
        _listDialog(1);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /* getCities() async {
    saveData();
    cities.add(Cities('1', 'Agra'));
    cities.add(Cities('2', 'Ghaziabad'));

    _listDialog(1);
  } */

  Future<void> getAreas(String cityId) async {
    try {
      saveData();
      areas = [];
      showWaitLoader();
      String token = '';

      await UserPreferences().getUser().then((value) => {
            token = value.token,
          });
      final Response response = await get(
        Uri.parse(AppUrl.areasUrl + cityId),
        headers: <String, String>{
          'token': token,
        },
      );

      log(response.body);
      if (jsonDecode(response.body)['data'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              jsonDecode(response.body)['message'].toString().toUpperCase()),
        ));
        Navigator.pop(dialogContext);
      } else {
        List<dynamic> list = jsonDecode(response.body)['data'];
        for (int i = 0; i < list.length; i++) {
          areas.add(Areas.fromJson(list[i]));
        }
        Navigator.pop(waitDialogContext);
        _listDialog(2);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  /* getAreas(String cityId) async {
    saveData();
    if (cityId == "1") {
      areas.add(Areas('1', 'Shaganj', '282010'));
      areas.add(Areas('2', 'Agra Fort', '282003'));
      areas.add(Areas('3', 'Idgah Colony', '282001'));
      areas.add(Areas('4', 'Jaipur House', '282002'));
      areas.add(Areas('5', 'Ganesh Nagar', '282005'));
    } else if (cityId == "2") {
      areas.add(Areas('1', 'Vaishali', '201019'));
      areas.add(Areas('2', 'Sultanpur', '201206'));
      areas.add(Areas('3', 'Noida Sector 41', '201303'));
      areas.add(Areas('4', 'Old Raj Nagar', '201002'));
      areas.add(Areas('5', 'Hindon Air Field', '201004'));
    }
    _listDialog(2);
  } */

  void _listDialog(int i) {
    showDialog(
        barrierDismissible: false,
        context: buildContext,
        builder: (BuildContext context) {
          listDialogContext = context;
          return Dialog(
              backgroundColor: Colors.white,
              child: Container(
                constraints: const BoxConstraints(
                    minHeight: 0, minWidth: double.infinity, maxHeight: 300),
                //height: 300.0,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: (i == 1) ? cities.length : areas.length,
                    itemBuilder: (context, position) {
                      return GestureDetector(
                        child: ListTile(
                          title: Text((i == 1)
                              ? cities[position].name
                              : areas[position].name),
                        ),
                        onTap: () {
                          Navigator.pop(listDialogContext);
                          setState(() {
                            if (i == 1) {
                              cityText = cities[position].name;
                              cityId = cities[position].id;
                            } else {
                              areaText = areas[position].name;
                              areaId = areas[position].id;
                              pincodeText = areas[position].pincode;
                              log(pincodeText);
                            }
                          });
                        },
                      );
                    }),
              ));
        });
  }

  pickFile() async {
    saveData();

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

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

  pickVideo() async {
    //await saveTempData();
    saveData();

    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      final file = result.files.first;
      media1 = file;
      setState(() {
        if (file.name.length > 10) {
          videoName = file.name.substring(0, 10);
        } else {
          videoName = file.name;
        }
      });
    } else {
      // User canceled the picker
    }
  }

  saveTempData() async {
    await UserPreferences().saveTempData(
        nameController.text, buildingController.text, wardController.text);
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

  getCurrentLocation() async {
    String lat = "";
    String lng = "";
    await UserPreferences().getLocation().then((value) {
      lat = value['lat'];
      lng = value['lng'];
    });

    return [lat, lng];
  }

  booknow() async {
    try {
      showLoader(1);
      List<String> array = await getCurrentLocation();
      String lat = array[0].toString();
      String lng = array[1].toString();
      log(lat.toString() + '---' + lng.toString());

      String token = '';
      String email = '';
      String phone = '';
      await UserPreferences().getUser().then((value) =>
          {token = value.token, email = value.email, phone = value.phone});

      if (nameController.text.isNotEmpty &&
          buildingController.text.isNotEmpty &&
          areaText != 'Select Area' &&
          cityText != 'Select City' &&
          pincodeText != 'Pincode' &&
          wardController.text.isNotEmpty) {
        var request = MultipartRequest("POST", Uri.parse(AppUrl.insertbooking));
        request.headers.addAll(<String, String>{"token": token});

        request.fields['name'] = nameController.text;
        request.fields['email'] = email;
        request.fields['phone'] = phone;
        request.fields['service'] = serviceId;
        request.fields['department'] = depId.toString();
        //request.fields['aadhar'] = aadharController.text;
        //request.fields['address'] = addressController.text;
        request.fields['building'] = buildingController.text;
        request.fields['area'] = areaId;
        request.fields['ward'] = wardController.text;
        request.fields['pincode'] = pincodeText;
        request.fields['city'] = cityId;
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
        if (videoName != '') {
          request.files.add(MultipartFile(
              'media1',
              File(media1.path.toString()).readAsBytes().asStream(),
              File(media1.path.toString()).lengthSync(),
              filename: media1.path.toString().split("/").last,
              contentType: MediaType('video', 'mp4')));
        }

        /* log(request.fields.toString());
      log(request.files.toString());
      log(request.headers.toString()); */

        var response = await request.send();
        log(response.toString());
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
        Navigator.pop(dialogContext);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please fill all the details marked *."),
        ));
      }
    } catch (e) {
      Navigator.pop(dialogContext);
      log(e.toString());
    }
  }

  late BuildContext mapDialogContext;
  CameraPosition initialLoaction =
      const CameraPosition(target: LatLng(27, 78), zoom: 14.47);
  late Marker locationMarker = const Marker(markerId: MarkerId('position'));
  late GoogleMapController _mapController;

  void getLocationDialog() {
    showDialog(
        barrierDismissible: true,
        context: buildContext,
        builder: (BuildContext context) {
          mapDialogContext = context;
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 400.0,
                child: Column(
                  children: [
                    SizedBox(
                      height: 300.0,
                      child: GoogleMap(
                        onTap: _addMarker,
                        initialCameraPosition: initialLoaction,
                        mapType: MapType.hybrid,
                        markers: {locationMarker},
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                      ),
                    ),
                    AppButton(title: 'Select', onPressed: () {})
                  ],
                ),
              ),
            ),
          );
        });
  }

  _addMarker(LatLng pos) {
    setState(() {
      locationMarker = Marker(
        markerId: const MarkerId('position'),
        infoWindow: const InfoWindow(title: 'Marked location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
      );
    });

    log(pos.latitude.toString() + '---' + pos.longitude.toString());
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
