import 'package:flutter/material.dart';
import 'package:flutter_app_one/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_one/my_widgets/app_button.dart';
import 'package:flutter_app_one/my_widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _backgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.bgTopColor, AppColors.bgBottomColor])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        _backgroundGradient(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const MyTextField(
                        hint: "Enter your email",
                        icon: Icons.person_outline,
                        key: null,
                      ),
                      const SizedBox(height: 20),
                      const MyTextField(
                        hint: "Enter your password",
                        icon: Icons.person_outline,
                        isPassword: true,
                      ),
                      const SizedBox(height: 40),
                      AppButton(
                        title: "Login",
                        onPressed: () {
                          // ignore: avoid_print
                          print("Login");
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Forgot your password?",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(color: Colors.white, width: 60, height: 4),
                    const Text(
                      "or Register",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Container(color: Colors.white, width: 60, height: 4),
                  ],
                ),
                AppButton(
                  title: "Register",
                  onPressed: () {
                    // ignore: avoid_print
                    print("Register");
                  },
                ),
              ],
            )),
          ),
        )
      ]),
    );
  }
}
