import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class Utility {
//
  static const String KEY = "IMAGE_KEY";

  static Future<String?> getImageFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY) ?? null;
  }

  static Future<bool> saveImageToPreferences(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY, value);
  }

  static Image imageFromBase64String(
      String base64String, double width, double height, BoxFit boxFit) {
    return Image.memory(
      base64Decode(base64String),
      fit: boxFit,
      width: width,
      height: height,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static bool validUrl(String value) {
    bool validValue = Uri.parse(value).isAbsolute;
    return validValue;
  }
}
