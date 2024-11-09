import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/configs.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Future<Color> getMaterialYouData() async {
  if (appStore.useMaterialYouTheme && await isAndroid12Above()) {
    // primaryColor = await getMaterialYouPrimaryColor();
    primaryColor = defaultPrimaryColor;
  } else {
    primaryColor = defaultPrimaryColor;
  }

  return primaryColor;
}
