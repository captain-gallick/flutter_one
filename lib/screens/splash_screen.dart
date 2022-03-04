import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_one/screens/book_track_screen.dart';
import 'package:flutter_app_one/screens/welcome_screen.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';

import 'login_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () => checkLogin());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
            child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/images/background1.png'),
                  fit: BoxFit.cover,
                )),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(80.0),
                          child:
                              Image.asset('assets/images/logo_white_big.png'),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const CircularProgressIndicator(),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset('assets/images/road.png'),
                    )
                  ],
                ))));
  }

  Future<void> checkLogin() async {
    UserPreferences userPreferences = UserPreferences();
    String token = (await userPreferences.getUser()).token;
    if (!await userPreferences.getWelcomeScreenStatus()) {
      gotoWelcome();
    } else if (token != '') {
      gotoBookTrack();
    } else {
      gotoLogin();
    }
  }

  gotoBookTrack() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const BookTrackScreen()));
  }

  gotoWelcome() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()));
  }

  gotoLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
