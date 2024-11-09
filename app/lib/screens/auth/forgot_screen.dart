import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/screens/auth/confirm_code.dart';
import 'package:com.gogospider.booking/screens/auth/sign_up_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class ForGotScreen extends StatefulWidget {
  final bool? isFromDashboard;
  final bool? isFromServiceBooking;
  final bool returnExpected;
  ForGotScreen(
      {this.isFromDashboard,
      this.isFromServiceBooking,
      this.returnExpected = false});

  @override
  _ForGotScreenState createState() => _ForGotScreenState();
}

class _ForGotScreenState extends State<ForGotScreen> {
  TextEditingController phoneCont = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  String phoneNumberold = '';
  bool isCodeSent = false;
  String verificationId = '';
  Future<void> sendConde() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      appStore.setLoading(true);
      phoneNumber = phoneCont.text.trim();
      phoneNumber = phoneNumber.replaceAll(' ', '');
      phoneNumber = phoneNumber.replaceAll('(', '');
      phoneNumber = phoneNumber.replaceAll(')', '');
      phoneNumberold = phoneNumber;
      // Map<String, dynamic> request = {
      //   UserKeys.userType: LOGIN_TYPE_USER,
      //   UserKeys.phoneNumber: phoneNumber,
      //   UserKeys.loginType: LOGIN_TYPE_OTP,
      //   UserKeys.codition: 1
      // };
      String number =
          '+$DEFAULT_COUNTRY_PHONE${phoneNumber.substring(1).trim()}';
      if (!number.startsWith('+')) {
        number = '+$DEFAULT_COUNTRY_PHONE${phoneNumber.substring(1).trim()}';
      }
      phoneNumber = number;
      await authService.loginWithOTP(number,
          onVerificationIdReceived: (verificationId) {
        if (verificationId.isNotEmpty) {
          // verificationId = verificationId;
          // setValue("verificationId", "");
          // setValue("verificationId", verificationId);
          appStore.setLoading(true);
          ConfirmCode(
                  userData: null,
                  codition: 1,
                  password: "",
                  verificationId: verificationId,
                  numberPhone: phoneCont.text.trim())
              .launch(context);
          toast('Code From GOGO SPIDER');
          appStore.setLoading(false);
        }
      }, onVerificationError: (s) {
        toast(s);
        appStore.setLoading(false);
      }).then((value) {
        appStore.setLoading(true);
        // verificationId = getStringAsync("verificationId");
        // ConfirmCode(
        //         userData: null,
        //         codition: 1,
        //         password: "",
        //         verificationId: getStringAsync("verificationId"),
        //         numberPhone: phoneCont.text.trim())
        //     .launch(context);
        // toast('Code From GOGO SPIDER');
        // appStore.setLoading(false);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: context.scaffoldBackgroundColor,
      //   leading: Navigator.of(context).canPop()
      //       ? BackWidget(iconColor: context.iconColor)
      //       : null,
      //   scrolledUnderElevation: 0,
      //   systemOverlayStyle: SystemUiOverlayStyle(
      //       statusBarIconBrightness:
      //           appStore.isDarkMode ? Brightness.light : Brightness.dark,
      //       statusBarColor: context.scaffoldBackgroundColor),
      // ),
      body: SizedBox(
        width: context.width(),
        child: Stack(
          children: [
            Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(26),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 50,
                    ),
                    Image.asset(appLogo, height: 120, width: 120),
                    20.height,
                    Text(language.descriptionForgotPassword,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17)),
                    30.height,
                    Container(
                      child: AppTextField(
                        textFieldType: TextFieldType.PHONE,
                        controller: phoneCont,
                        errorThisFieldRequired: language.requiredText,
                        decoration: inputDecorationOther(
                          context,
                          labelText: labelTextFormatPone(),
                          prefixIcon: Container(
                            width: 100,
                            margin: EdgeInsets.only(right: 10),
                            child: Row(children: [
                              Image.asset(
                                ic_khmer,
                                width: 35,
                              ).paddingAll(10),
                              Text(
                                codeCountry(),
                                style: TextStyle(fontSize: 15.5),
                              )
                            ]),
                          ),
                        ),
                        suffix: ic_calling.iconImage(size: 10).paddingAll(14),
                        inputFormatters: [
                          phoneInputFormatter()
                          // MaskedInputFormatter("(0)## ### ####"),
                        ],
                      ),
                    ),
                    30.height,
                    AppButton(
                      onTap: () {
                        sendConde();
                      },
                      text: language.send,
                      color: primaryColor,
                      textStyle: boldTextStyle(color: white),
                      width: context.width(),
                    ),
                    20.height,
                    RichText(
                      text: TextSpan(
                          text: language.doNotHaveAccount,
                          style: boldTextStyle(color: gray, size: 14),
                          children: [
                            TextSpan(text: ""),
                            TextSpan(
                              text: language.txtCreateAccount,
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () => SignUpScreen().launch(context),
                              style: boldTextStyle(color: primaryColor),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
            Observer(
              builder: (_) =>
                  LoaderWidget().center().visible(appStore.isLoading),
            ),
          ],
        ),
      ),
    );
  }
}
