import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;

  const MyTextField(
      {Key? key,
      required this.hint,
      required this.icon,
      this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hint,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: const EdgeInsets.all(20)),
      ),
    );
  }
}
