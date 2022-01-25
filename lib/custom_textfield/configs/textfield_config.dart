import 'package:flutter/material.dart';

class TextFieldConfig {
  final String? initialValue;
  final TextStyle? style;
  final bool autoFocus;
  final Color? cursorColor;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool autocorrect;
  final String obscureCharacter;
  final bool enableSuggestions;
  final FocusNode? focusNode;
  final InputDecoration? inputDecoration;
  final bool isEnabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final TextAlignVertical? textAlignVertical;
  final bool readOnly;
  final int? maxLength;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;

  const TextFieldConfig({
    this.initialValue,
    this.style,
    this.autoFocus = false,
    this.cursorColor,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.autocorrect = true,
    this.obscureCharacter = '•',
    this.enableSuggestions = true,
    this.focusNode,
    this.inputDecoration,
    this.isEnabled = true,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.textAlignVertical,
    this.readOnly = false,
    this.maxLength,
    this.maxLines,
    this.textInputAction,
    this.controller,
  });
}

enum TextFieldType {
  text,
  password,
  email,
  phoneNumber,
  multiline,
  name,
  number
}

class TextFieldValidatorUtils {
  static String? validateNumber(String? value) {
    if (value == null) {
      return null;
    }

    var result = RegExp(Utils.regexNumber).hasMatch(value);
    if (result) {
      return null;
    } else {
      return 'Number is not valid!';
    }
  }

  static String? validateText(String? value) {
    if (value == null) {
      return null;
    }

    var result = RegExp(Utils.regexText).hasMatch(value);
    if (result) {
      return null;
    } else {
      return 'Text can not empty!';
    }
  }

  static String? validateEmail(String? value) {
    if (value == null) {
      return null;
    }

    var result = RegExp(Utils.regexEmail).hasMatch(value);
    if (result) {
      return null;
    } else {
      return 'Email is not valid!';
    }
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null) {
      return null;
    }

    var result = RegExp(Utils.regexPhone).hasMatch(value);
    if (result) {
      return null;
    } else {
      return 'Phone is not valid!';
    }
  }

  static String? validatePassword(String? value) {
    if (value == null) {
      return null;
    }

    var result = RegExp(Utils.regexPwd).hasMatch(value);
    if (result) {
      return null;
    } else {
      return 'Password is not valid!';
    }
  }
}

class Utils {
  Utils._();

  static String regexText = r'^.+$';
  static String regexNumber = r'^\d+$';
  static String regexPwd = r'^(?=.*[a-z])(?=.*\d).{8,16}$';
  static String regexPhone = r'(^(?:[+0]9)?[-0-9]{10,15}$)';
  static String regexEmail = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
}
