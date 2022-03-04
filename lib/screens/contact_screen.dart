import 'package:flutter/material.dart';
import 'package:flutter_app_one/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomeScreen()),
          (route) => false,
        );
        return false;
      },
      child: SafeArea(
          child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const HomeScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.black,
              )),
        ),
        body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/images/background1.png'),
              fit: BoxFit.cover,
            )),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset('assets/images/road.png'),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Image.asset(
                        'assets/images/logo_white_big.png',
                        width: 100,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'CONTACT',
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SizedBox(
                        width: 300,
                        child: ListTile(
                            dense: true,
                            title: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    url_launcher.launch("tel://+91903576567");
                                  },
                                  child: const Text(
                                    '+(91) 90357 6567',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    url_launcher.launch("tel://+91903585557");
                                  },
                                  child: const Text(
                                    '+(91) 90358 5557',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20.0),
                                  ),
                                ),
                              ],
                            ),
                            leading: Image.asset(
                              'assets/images/mobile.png',
                              width: 50,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: SizedBox(
                        width: 300,
                        child: ListTile(
                            dense: true,
                            title: Align(
                              alignment: const Alignment(-0.2, 0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      final Uri params = Uri(
                                          scheme: 'mailto',
                                          path: 'info@maljal.org');

                                      var url = params.toString();
                                      launch(url);
                                    },
                                    child: const Text(
                                      'info@maljal.org',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      final Uri params = Uri(
                                          scheme: 'mailto',
                                          path: 'help@maljal.org');

                                      var url = params.toString();
                                      launch(url);
                                    },
                                    child: const Text(
                                      'help@maljal.org',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            leading: Image.asset(
                              'assets/images/mail.png',
                              width: 50,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: ListTile(
                          dense: true,
                          title: Align(
                            alignment: const Alignment(1, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
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
                          ),
                          leading: Image.asset(
                            'assets/images/message.png',
                            width: 50,
                          )),
                    ),
                  ],
                )
              ],
            )),
      )),
    );
  }
}
