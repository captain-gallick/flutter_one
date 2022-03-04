import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/data_models/areas.dart';
import 'package:flutter_app_one/data_models/cities.dart';
import 'package:flutter_app_one/my_widgets/app_button.dart';
import 'package:flutter_app_one/my_widgets/text_field.dart';
import 'package:flutter_app_one/utils/app_colors.dart';
import 'package:flutter_app_one/utils/network_connecttion.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';
import 'package:http/http.dart';

import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '-';
  String email = '-';
  String building = '-';
  String ward = '-';
  String aadhar = '-';

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final aadharController = TextEditingController();
  final buildingController = TextEditingController();
  final areaController = TextEditingController();
  final wardController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();

  String cityText = 'Select City';
  String cityId = '0';
  String areaId = '0';
  String areaText = 'Select Area';
  String pincodeText = 'Pincode';

  List<Cities> cities = [];
  List<Areas> areas = [];

  late BuildContext listDialogContext, waitDialogContext;
  late BuildContext buildContext;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => getUserDetails());
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    buildingController.dispose();
    wardController.dispose();
    aadharController.dispose();
    super.dispose();
  }

  late BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return SafeArea(
        child: WillPopScope(
            onWillPop: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const HomeScreen()),
                (route) => false,
              );
              return false;
            },
            child: Scaffold(
                appBar: AppBar(
                  title: const Align(
                      alignment: Alignment(-0.25, 0.0),
                      child: Text(
                        "Profile",
                        style: TextStyle(color: AppColors.appGrey),
                      )),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.appGrey,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
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
                        child: Container(
                      child: registrationForm(),
                    ))))));
  }

  getUserDetails() {
    setState(() {
      UserPreferences().getUser().then((value) {
        name = name == '-' ? value.name : name;
        nameController.text = name;

        email = email == '-' ? value.email : email;
        emailController.text = email;

        building = building == '-' ? value.building : building;
        buildingController.text = building;

        areaId = value.areaId;
        areaText = value.areaId != '0' ? value.areaName : areaText;

        ward = ward == '-' ? value.ward : ward;
        wardController.text = ward;

        cityId = value.cityId;
        cityText = value.cityId != '0' ? value.cityName : cityText;

        pincodeText = value.pincode == '0' ? pincodeText : value.pincode;

        aadhar = aadhar == '-' ? value.aadhar : aadhar;
        aadharController.text = aadhar;
      });
    });
  }

  registrationForm() {
    return Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              heading('Full Name'),
              MyTextField(
                type: TextInputType.name,
                hint: "Enter your Name",
                key: null,
                myController: nameController,
              ),
              heading('Email'),
              MyTextField(
                type: TextInputType.emailAddress,
                hint: "Enter your email",
                key: null,
                myController: emailController,
              ),
              heading('City'),
              GestureDetector(
                onTap: () {
                  getCities();
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
              heading('Area'),
              GestureDetector(
                onTap: () {
                  if (cityText != "Select City") {
                    getAreas(cityId);
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
              heading('Pincode'),
              Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffF4F7FE),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(pincodeText),
                  )),
              heading('Building'),
              MyTextField(
                type: TextInputType.streetAddress,
                hint: "Enter your Building",
                key: null,
                myController: buildingController,
              ),
              heading('Ward'),
              MyTextField(
                type: TextInputType.streetAddress,
                hint: "Enter your Ward",
                key: null,
                myController: wardController,
              ),
              heading('Aadhar Number'),
              MyTextField(
                length: 12,
                type: TextInputType.number,
                hint: "Enter your Aadhar Number",
                key: null,
                myController: aadharController,
              )
              /* heading('Phone'),
              MyTextField(
                length: 10,
                type: TextInputType.phone,
                hint: "Enter your Phone Number",
                key: null,
                myController: phoneController,
              ), */
              /* heading('Address'),
              MyTextField(
                type: TextInputType.streetAddress,
                hint: "Enter your Address",
                key: null,
                myController: addressController,
              ),
              heading('Aadhar Number'),
              MyTextField(
                length: 12,
                type: TextInputType.number,
                hint: "Enter your Aadhar Number",
                key: null,
                myController: aadharController,
              ),*/

              ,
              const SizedBox(
                height: 40.0,
              ),
              AppButton(
                  title: 'Update',
                  onPressed: () {
                    NetworkCheckUp().checkConnection().then((value) {
                      if (value) {
                        updateProfile();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Please connect to internet."),
                        ));
                      }
                    });
                  })
            ]));
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

  saveData() {
    name = nameController.text;
    building = buildingController.text;
    ward = wardController.text;
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
                            } else if (i == 2) {
                              areaText = areas[position].name;
                              areaId = areas[position].id;
                              pincodeText = areas[position].pincode;
                            }
                          });
                        },
                      );
                    }),
              ));
        });
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

  void showLoader(String text) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return WillPopScope(
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const CircularProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(text),
                      ),
                    ],
                  ),
                ),
              ),
              onWillPop: () async => false);
        });
  }

  Future<void> updateProfile() async {
    try {
      String token = '';
      await UserPreferences().getToken().then((value) => {token = value});

      String name = nameController.text;
      String email = emailController.text;
      //String phone = phoneController.text;
      //String address = addressController.text;
      //String aadhar = aadharController.text;
      String building = buildingController.text;
      //String area = areaController.text;
      String ward = wardController.text;
      //String pincode = pincodeController.text;
      //String city = cityController.text;

      showLoader('Please wait...');
      final Response response = await post(
        Uri.parse(AppUrl.updateUser),
        headers: <String, String>{'token': token},
        body: jsonEncode(<String, String>{
          'email': email,
          'name': name,
          'building': building,
          'area': areaId,
          'ward': ward,
          'pincode': pincodeText,
          'city': cityId,
          'aadhar': aadhar
        }),
      );

      log(response.body);

      if (response.statusCode == 200) {
        //log(response.body);
        if (!(jsonDecode(response.body).toString().toLowerCase())
            .contains('data')) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(jsonDecode(response.body).toString().toUpperCase()),
          ));
          Navigator.pop(dialogContext);
        } else {
          Navigator.pop(dialogContext);

          var data = jsonDecode(response.body)['data'];

          /* log(data['name'] +
            "--" +
            data['email'] +
            "--" +
            data['building'] +
            "--" +
            data['area'] +
            "--" +
            data['pincode'] +
            "--" +
            data['ward'] +
            "--" +
            data['city']); */

          UserPreferences userPreferences = UserPreferences();

          await userPreferences.updateUser(
            data['name'] ?? '',
            data['email'] ?? '',
            data['building'] ?? '',
            data['areaid'] ?? '',
            data['area'] ?? '',
            data['pin'] ?? '',
            data['ward'] ?? '',
            data['cityid'] ?? '',
            data['city'] ?? '',
            data['aadhar'] ?? '',
          );
          showLoader('Profile Successfully Updated!');
          setState(() {
            Navigator.pop(dialogContext);
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter valid details"),
        ));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
