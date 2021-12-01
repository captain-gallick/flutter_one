import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_one/constants/app_urls.dart';
import 'package:flutter_app_one/data_models/user.dart';
import 'package:flutter_app_one/my_widgets/app_button.dart';
import 'package:flutter_app_one/my_widgets/text_field.dart';
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
  late String _email, _password;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  late BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          child: Center(
            child: Wrap(
              direction: Axis.horizontal,
              spacing: 10.0,
              children: <Widget>[
                const SizedBox(
                  height: 200.0,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 210.0,
                  ),
                ),
                const SizedBox(height: 40.0),
                MyTextField(
                  hint: 'Email',
                  myController: emailController,
                  type: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10.0),
                MyTextField(
                    hint: 'Password',
                    isPassword: true,
                    myController: passwordController),
                Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () async {
                      doLogin();
                    },
                    icon: Image.asset('assets/images/continue_button.png'),
                    iconSize: 150.0,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Color(0xffF4F7FE)),
                  ),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 50.0, horizontal: 100.0),
                  child: AppButton(
                      title: 'Register', onPressed: gotoRegistrations),
                )
                    // child: IconButton(
                    //   padding: EdgeInsets.zero,
                    //   constraints: BoxConstraints(),
                    //   onPressed: gotoRegistrations,
                    //   icon: Image.asset('assets/images/skip_button.png'),
                    //   iconSize: 150.0,
                    // ),
                    ),
              ],
            ),
          ),
        ),
      ),
    ));
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
                    children: const <Widget>[
                      CircularProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text('Please wait while we login...'),
                      ),
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

  void gotoRegistrations() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const RegistrationScreen()));
  }

  Future<void> doLogin() async {
    _email = emailController.text;
    _password = passwordController.text;

    if (_email.isNotEmpty && _password.isNotEmpty) {
      showLoader();
      final Response response = await post(
        Uri.parse(AppUrl.login),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'email': _email, 'password': _password}),
      );

      if (!(jsonDecode(response.body).toString().toLowerCase())
          .contains('data')) {
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
        content: Text("Please enter valid email and password"),
      ));
    }
  }
}
