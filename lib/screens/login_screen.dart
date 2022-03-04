import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/data_models/user.dart';
import 'package:flutter_app_one/my_widgets/text_field.dart';
import 'package:flutter_app_one/screens/book_track_screen.dart';
import 'package:flutter_app_one/screens/profile_screen.dart';
import 'package:flutter_app_one/screens/registration_screen.dart';
import 'package:flutter_app_one/utils/network_connecttion.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:flutter_app_one/utils/globals.dart' as globals;

import 'book_service.dart';
import 'booking_history.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _phone, _otp;
  final phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool showOTP = false;
  //final scaffoldKey = GlobalKey();
  //late OTPTextEditController otpController;
  //final OTPInteractor _otpInteractor = OTPInteractor();

  @override
  void initState() {
    super.initState();
    //_otpInteractor = OTPInteractor();
    /* _otpInteractor.startListenUserConsent('VM-MOURJA');
    /* .getAppSignature()
        //ignore: avoid_print
        .then((value) => print('signature - $value')); */

    otpController = OTPTextEditController(
      codeLength: 6,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
      ); */
  }

  @override
  Future<void> dispose() async {
    //await _otpInteractor.stopListenForCode();
    //await otpController.stopListen();
    otpController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  late BuildContext dialogContext, exitDialogContext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        if (showOTP) {
          showAlertDialog();
        } else {
          SystemNavigator.pop();
        }
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/login_bg.png'),
                fit: BoxFit.cover,
              )),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: (showOTP ? getOTPLayout() : getphoneNumberLayout()),
          ),
        ),
      ),
    ));
  }

  getphoneNumberLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 210.0,
          ),
        ),
        const SizedBox(height: 60.0),
        const Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 20.0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Enter Your Phone Number')),
        ),
        MyTextField(
          myController: phoneController,
          type: TextInputType.phone,
          alignment: TextAlign.center,
          length: 10,
          hint: 'Phone Number',
        ),
        Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () async {
              NetworkCheckUp().checkConnection().then((value) {
                if (value) {
                  sendOTP();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please connect to internet."),
                  ));
                }
              });
            },
            icon: Image.asset('assets/images/continue_button.png'),
            iconSize: 150.0,
          ),
        ),
        Center(
          child: TextButton(
            onPressed: gotoHome,
            child: const Text('SKIP'),
          ),
        ),
      ],
    );
  }

  getOTPLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 210.0,
          ),
        ),
        const SizedBox(height: 60.0),
        const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Enter the OTP',
              style: TextStyle(fontSize: 17),
            )),
        Row(
          children: <Widget>[
            Text('sent to ${phoneController.text}'),
            TextButton(
                onPressed: () {
                  showAlertDialog();
                },
                child: const Text(
                  'change?',
                  style: TextStyle(decoration: TextDecoration.underline),
                ))
          ],
        ),
        MyTextField(
          myController: otpController,
          type: TextInputType.number,
          length: 6,
          hint: 'OTP',
          alignment: TextAlign.center,
        ),
        Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              NetworkCheckUp().checkConnection().then((value) {
                if (value) {
                  doLogin();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please connect to internet."),
                  ));
                }
              });
            },
            icon: Image.asset('assets/images/next_button.png'),
            iconSize: 150.0,
          ),
        ),
      ],
    );
  }

  void showLoader() {
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
                        child: (showOTP
                            ? const Text('Please wait while we login...')
                            : const Text('Please wait...')),
                      ),
                    ],
                  ),
                ),
              ),
              onWillPop: () async => false);
        });
  }

  showAlertDialog() {
    // set up the buttons
    Widget yesButton = TextButton(
      child: const Text("YES"),
      onPressed: () {
        setState(() {
          showOTP = !showOTP;
          Navigator.pop(exitDialogContext);
        });
      },
    );
    Widget noButton = TextButton(
      child: const Text("NO"),
      onPressed: () {
        Navigator.pop(exitDialogContext);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text("Are you sure?"),
      actions: [
        yesButton,
        noButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        exitDialogContext = context;
        return WillPopScope(
            child: alert,
            onWillPop: () async {
              return false;
            });
      },
    );
  }

  void showExitDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          exitDialogContext = context;
          return WillPopScope(
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('Are you sure?'),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: GestureDetector(
                              child: const Text('YES'),
                              onTap: () {
                                setState(() {
                                  showOTP = !showOTP;
                                  Navigator.pop(exitDialogContext);
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: GestureDetector(
                              child: const Text('NO'),
                              onTap: () {
                                Navigator.pop(exitDialogContext);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              onWillPop: () async => false);
        });
  }

  void gotoHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  void gotoBookTrack() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const BookTrackScreen()));
  }

  void gotoRegistrations() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const RegistrationScreen()));
  }

  Future<void> sendOTP() async {
    try {
      _phone = phoneController.text;
      //_password = passwordController.text;

      if (_phone.length == 10) {
        showLoader();
        final Response response = await post(
          Uri.parse(AppUrl.sendOtp),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'phone': _phone}),
        );

        log(response.body);
        if (!(jsonDecode(response.body).toString().toLowerCase())
            .contains('success')) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(jsonDecode(response.body).toString().toUpperCase()),
          ));
          Navigator.pop(dialogContext);
        } else {
          setState(() {
            showOTP = !showOTP;
            Navigator.pop(dialogContext);
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter a valid Phone Number."),
        ));
      }
    } catch (e) {
      Navigator.pop(dialogContext);
      log(e.toString());
    }
  }

  Future<void> doLogin() async {
    try {
      _otp = otpController.text;

      if (_otp.length == 6) {
        showLoader();
        final Response response = await post(
          Uri.parse(AppUrl.verifyOtp),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'phone': _phone, 'otp': _otp}),
        );

        log(response.body);
        if (!(jsonDecode(response.body).toString().toLowerCase())
            .contains('success')) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                jsonDecode(response.body)['message'].toString().toUpperCase()),
          ));
          Navigator.pop(dialogContext);
        } else {
          User user = User.fromJson(jsonDecode(response.body)['data']);

          UserPreferences userPreferences = UserPreferences();

          await userPreferences.saveUser(user);

          checkPath();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter a valid Phone Number."),
        ));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  checkPath() {
    if (globals.gotoBookingHistory) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const BookingHistoryScreen()));
    } else if (globals.gotoProfile) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()));
    } else if (globals.gotoBookService) {
      var item = globals.item;
      if (item != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BookServiceScreen(
                      depId: depId,
                      serviceName: item.title,
                      vibhag: item.vibhag,
                      serviceId: item.id,
                    )));
      }
    } else {
      gotoBookTrack();
    }
    clearGlobals();
  }

  clearGlobals() {
    globals.depId = -1;
    globals.item;
    globals.gotoBookService = false;
    globals.gotoBookingHistory = false;
    globals.gotoProfile = false;
  }
}
