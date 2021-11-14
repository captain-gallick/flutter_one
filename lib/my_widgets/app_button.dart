// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_app_one/app_colors.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color color;

  const AppButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.color = AppColors.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      onPressed: () {},
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
