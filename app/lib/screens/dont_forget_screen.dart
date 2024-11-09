import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/screens/auth/sign_up_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DontForgetScreen extends StatefulWidget {
  @override
  _DontForgetScreenState createState() => _DontForgetScreenState();
}

class _DontForgetScreenState extends State<DontForgetScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CachedImageWidget(
                url: ic_dont_forget,
                height: MediaQuery.of(context).size.width - 20,
              ),
            ),
            // 15.height,
            Center(
              child: RichText(
                textAlign: TextAlign.left,
                softWrap: true,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "ប្រសិនបើ ",
                      style: secondaryTextStyle(color: black, size: 15)),
                  TextSpan(
                      text: "លោកអ្នកមិនមានគណនីទេ ",
                      style: boldTextStyle(color: warningColor, size: 15)),
                  TextSpan(
                      text: "សូមចុះឈ្មោះនៅទំព័របន្ទាប់ ",
                      style: secondaryTextStyle(color: black, size: 15)),
                ]),
              ),
            ),
            10.height,
            Center(
              child: RichText(
                textAlign: TextAlign.left,
                softWrap: true,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "If you ",
                      style: secondaryTextStyle(color: black, size: 13)),
                  TextSpan(
                      text: "don't have account, please sign up ",
                      style: boldTextStyle(color: warningColor, size: 13)),
                  TextSpan(
                      text: "in the next page ",
                      style: secondaryTextStyle(color: black, size: 13)),
                ]),
              ),
            ),
            Center(
              child: CachedImageWidget(
                url: ic_greeting,
                height: 300,
              ),
            ),
          ],
        )).paddingAll(15),
        Positioned(
            bottom: 20,
            left: 20,
            child: AppButton(
              textColor: black,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: cardColor,
              child: Text(
                language.back,
                style: boldTextStyle(color: black),
              ),
              onTap: () {
                finish(context);
              },
            )),
        Positioned(
            bottom: 20,
            right: 20,
            child: AppButton(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: primaryColor,
              child: Text(
                language.getStarted,
                style: boldTextStyle(color: white),
              ),
              onTap: () async {
                await setValue(IS_FIRST_TIME, false);
                SignUpScreen().launch(context);
              },
            ))
      ]),
    ));
  }
}
