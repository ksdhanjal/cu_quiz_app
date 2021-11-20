
import 'package:flutter/material.dart';

class OptionsData {
  final String? correctAnswer;
  final bool? isCorrect;
  final String? option;
  final Color? color;
  final String? optionLetter;

  OptionsData({this.isCorrect, this.option, this.color, this.optionLetter, this.correctAnswer});
}