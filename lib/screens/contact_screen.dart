import 'package:flutter/material.dart';
import 'package:flutter_app_one/data_models/my_bookings.dart';
import 'package:flutter_app_one/screens/booking_details.dart';

class ContactScreen extends StatelessWidget {
  final MyBooking history;
  const ContactScreen(this.history, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  BookingDetailsScreen(history: history)),
          (route) => false,
        );
        return false;
      },
      child: SafeArea(
          child: Material(
              child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/background1.png'),
                    fit: BoxFit.cover,
                  )),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    BookingDetailsScreen(history: history)),
                            (route) => false,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Icon(Icons.chevron_left_rounded),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset('assets/images/road.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 200),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/logo_white_big.png',
                              width: 150,
                            ),
                            const Text(
                              'CONTACT',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 6,
                                  height: MediaQuery.of(context).size.width / 6,
                                  child:
                                      Image.asset('assets/images/mobile.png'),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const <Widget>[
                                    Text(
                                      '+(91) 90357 6567',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                    Text(
                                      '+(91) 90358 5557',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    height:
                                        MediaQuery.of(context).size.width / 6,
                                    child:
                                        Image.asset('assets/images/mail.png'),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const <Widget>[
                                    Text(
                                      'info@maljal.org',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                    Text(
                                      'help@maljal.org',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 6,
                                    height:
                                        MediaQuery.of(context).size.width / 6,
                                    child: Image.asset(
                                        'assets/images/message.png'),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const <Widget>[
                                    Text(
                                      'maljal@skype',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                    Text(
                                      'maljal_business@skype',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )))),
    );
  }
}
