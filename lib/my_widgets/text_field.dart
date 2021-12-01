// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hint;
  final bool isPassword;
  final myController;
  final type;
  final length;
  final active;
  final icon;
  final text;

  const MyTextField(
      {Key? key,
      this.active = true,
      this.text = '',
      this.type,
      // ignore: avoid_init_to_null
      this.icon = null,
      this.length,
      required this.hint,
      this.isPassword = false,
      this.myController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF4F7FE),
        borderRadius: BorderRadius.circular(32),
      ),
      child: TextField(
        enabled: active,
        keyboardType: type,
        maxLength: length,
        controller: myController,
        obscureText: isPassword,
        decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            prefixIcon: icon,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            counterText: '',
            contentPadding: const EdgeInsets.all(20)),
      ),
    );
  }
}
