import 'package:flutter/material.dart';


class RoundedBorderTextField extends StatelessWidget {
  final String hintText;
  final String label;
  final bool obscureText;
  final TextInputType inputType;
  final TextEditingController? controller;

  const RoundedBorderTextField(
      {Key? key,
        this.hintText = "",
        this.label = "",
        this.inputType = TextInputType.text,
        this.controller,
        this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white),),
        hintText: hintText,
      ),
    );
  }
}