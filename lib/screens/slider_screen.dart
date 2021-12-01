import 'package:flutter/material.dart';
import 'package:flutter_app_one/my_widgets/text_field.dart';
import 'package:flutter_app_one/screens/booking_history.dart';
import 'package:flutter_app_one/screens/profile_screen.dart';
import 'package:flutter_app_one/screens/splash_screen.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';

class SlliderScreen extends StatelessWidget {
  const SlliderScreen({Key? key}) : super(key: key);

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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BookingHistoryScreen()));
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()));
                    },
                    child: const Text(
                      '- My Profile',
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                    onPressed: () {
                      UserPreferences prefs = UserPreferences();
                      prefs.removeUser();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MySplashScreen()));
                    },
                    child: const Text(
                      '- Logout',
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    )),
              ),
            ]),
      ),
    );
  }
}
