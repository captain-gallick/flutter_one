import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/data_models/user.dart';
import 'package:flutter_app_one/my_widgets/text_field.dart';
import 'package:flutter_app_one/screens/book_track_screen.dart';
import 'package:flutter_app_one/screens/registration_screen.dart';
import 'package:flutter_app_one/utils/shared_preferences.dart';
import 'package:http/http.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _phone, _otp;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  bool showOTP = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
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
          length: 10,
          hint: 'Phone Number',
        ),
        Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () async {
              sendOTP();
            },
            icon: Image.asset('assets/images/continue_button.png'),
            iconSize: 150.0,
          ),
        ),
        Center(
          child: TextButton(
            onPressed: gotoBookTrack,
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
        const Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 20.0),
          child: Align(
              alignment: Alignment.centerLeft, child: Text('Enter the OTP')),
        ),
        MyTextField(
          myController: otpController,
          type: TextInputType.number,
          length: 6,
          hint: 'OTP',
        ),
        Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: doLogin,
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
  }

  Future<void> doLogin() async {
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

      if (!(jsonDecode(response.body).toString().toLowerCase())
          .contains('success')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonDecode(response.body).toString().toUpperCase()),
        ));
        Navigator.pop(dialogContext);
      } else {
        User user = User.fromJson(jsonDecode(response.body)['data']);

        UserPreferences userPreferences = UserPreferences();

        await userPreferences.saveUser(user);

        gotoHome();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a valid Phone Number."),
      ));
    }
  }
}
