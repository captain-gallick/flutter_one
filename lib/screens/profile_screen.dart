import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/my_widgets/app_button.dart';
import 'package:flutter_app_one/my_widgets/text_field.dart';
import 'package:flutter_app_one/utils/app_colors.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';
import 'package:http/http.dart';

import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  //final phoneController = TextEditingController();
  //final addressController = TextEditingController();
  //final aadharController = TextEditingController();
  final buildingController = TextEditingController();
  final areaController = TextEditingController();
  final wardController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    //phoneController.dispose();
    //addressController.dispose();
    //aadharController.dispose();
    buildingController.dispose();
    areaController.dispose();
    wardController.dispose();
    pincodeController.dispose();
    cityController.dispose();

    super.dispose();
  }

  late BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
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
                    child: SingleChildScrollView(child: registrationForm())))));
  }

  Container registrationForm() {
    UserPreferences().getUser().then((value) {
      nameController.text = value.name;
      emailController.text = value.email;
      buildingController.text = value.building;
      areaController.text = value.area;
      wardController.text = value.ward;
      cityController.text = value.city;
      pincodeController.text = value.pincode;
      //aadharController.text = value.aadhar;
      //phoneController.text = value.phone;
    });

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
              heading('Building Name'),
              MyTextField(
                type: TextInputType.streetAddress,
                hint: "Enter your Building Name",
                key: null,
                myController: buildingController,
              ),
              heading('Area'),
              MyTextField(
                type: TextInputType.streetAddress,
                hint: "Enter your Area",
                key: null,
                myController: areaController,
              ),
              heading('Ward'),
              MyTextField(
                type: TextInputType.streetAddress,
                hint: "Enter your Ward",
                key: null,
                myController: wardController,
              ),
              heading('Pincode'),
              MyTextField(
                length: 6,
                type: TextInputType.number,
                hint: "Enter your Pincode",
                key: null,
                myController: pincodeController,
              ),
              heading('City'),
              MyTextField(
                type: TextInputType.streetAddress,
                hint: "Enter your City",
                key: null,
                myController: cityController,
              ),
              const SizedBox(
                height: 40.0,
              ),
              AppButton(
                  title: 'Update',
                  onPressed: () {
                    updateProfile();
                  })
            ]));
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
    String token = '';
    await UserPreferences().getToken().then((value) => {token = value});

    String name = nameController.text;
    String email = emailController.text;
    //String phone = phoneController.text;
    //String address = addressController.text;
    //String aadhar = aadharController.text;
    String building = buildingController.text;
    String area = areaController.text;
    String ward = wardController.text;
    String pincode = pincodeController.text;
    String city = cityController.text;

    showLoader('Please wait...');
    final Response response = await post(
      Uri.parse(AppUrl.updateUser),
      headers: <String, String>{'token': token},
      body: jsonEncode(<String, String>{
        'email': email,
        'name': name,
        'building': building,
        'area': area,
        'ward': ward,
        'pincode': pincode,
        'city': city
      }),
    );

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
            data['name'],
            data['email'],
            data['building'],
            data['area'],
            data['pincode'],
            data['ward'],
            data['city']);
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
  }
}
