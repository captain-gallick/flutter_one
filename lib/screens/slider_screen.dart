import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/data_models/service_count.dart';
import 'package:flutter_app_one/my_widgets/text_field.dart';
import 'package:flutter_app_one/screens/booking_history.dart';
import 'package:flutter_app_one/screens/profile_screen.dart';
import 'package:flutter_app_one/screens/splash_screen.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';
import 'package:http/http.dart';

import 'login_screen.dart';

List<ServiceCount> serviceCount = [];

class SlliderScreen extends StatefulWidget {
  final bool loggedIn;
  const SlliderScreen({Key? key, required this.loggedIn}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
// ignore: no_logic_in_create_state
    return _SlliderScreenState(loggedIn);
  }
}

class _SlliderScreenState extends State<SlliderScreen> {
  final bool loggedIn;
  _SlliderScreenState(this.loggedIn);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background1.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/images/logo_white.png',
                    height: 50.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                    onPressed: () {},
                    child: const MyTextField(
                      hint: 'Service',
                      icon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                    onPressed: () {
                      if (loggedIn) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BookingHistoryScreen()));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      }
                    },
                    child: const Text(
                      '- Booking History',
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                    onPressed: () {
                      if (loggedIn) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProfileScreen()));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      }
                    },
                    child: const Text(
                      '- My Profile',
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: (loggedIn)
                    ? TextButton(
                        onPressed: () {
                          UserPreferences prefs = UserPreferences();
                          prefs.removeUser();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MySplashScreen()));
                        },
                        child: const Text(
                          '- Logout',
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        ))
                    : Container(),
              ),
              //getDepartmentList()
            ]),
      ),
    );
  }

  getDepartmentList() {
    return Expanded(
      child: ListView.builder(
          itemCount: serviceCount.length,
          itemBuilder: (context, position) {
            return GestureDetector(
                onTap: () {
                  /* setState(() {
                  depId = int.parse(departments[position].id);
                  showDeps = -1;
                  getServicesByDepartment();
                }); */
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      serviceCount[position].count,
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      serviceCount[position].name,
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.white),
                    )
                  ],
                ));
          }),
    );
  }
  /* getServicesByDepartment() async {
    try {
      serviceCount.clear();
      final Response response =
          await get(Uri.parse(AppUrl.services));

      if (jsonDecode(response.body).toString().contains('data')) {
        List<dynamic> list = jsonDecode(response.body)['data'];
        for (int i = 0; i < list.length; i++) {
          serviceCount.add(MyServices.fromJson(list[i]));
        }
        setState(() {
          showDeps = 2;
          Navigator.pop(dialogContext);
        });
        //getCarousal();
      } else {}
      return services;
    } catch (e) {}
  } */
}
