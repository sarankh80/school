import 'dart:convert';

import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/screens/auth/sign_in_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/model_keys.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class NewPasswordScreen extends StatefulWidget {
  final String? numberPhone;
  final String? email;
  final String? verificationId;
  NewPasswordScreen({this.numberPhone, this.email, this.verificationId});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  TextEditingController newPasswordCont = TextEditingController();
  TextEditingController reenterPasswordCont = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode reenterPasswordFocus = FocusNode();
  String phoneNumber = '';

  Future<void> changePassword() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      appStore.setLoading(true);
      phoneNumber = widget.numberPhone!;
      phoneNumber = phoneNumber.replaceAll(' ', '');
      phoneNumber = phoneNumber.replaceAll('(', '');
      phoneNumber = phoneNumber.replaceAll(')', '');
      Map<String, dynamic> request = {
        UserKeys.phoneNumber: phoneNumber,
        UserKeys.password: newPasswordCont.text,
        UserKeys.confirmPassword: reenterPasswordCont.text,
      };
      await forgotPassword(request).then((res) async {
        if (res.message.validate() != "") {
          toast(res.message.validate());
        } else {
          appStore.setLoading(true);
          // userService.getUserEmail(email: widget.email).then((valueEmail) {
          FirebaseAuth.instance.signOut();
          Codec<String, String> stringToBase64 = utf8.fuse(base64);
          FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: widget.email.validate(),
                  password:
                      stringToBase64.decode(widget.verificationId.validate()))
              .then((valuepass) {
            appStore.setLoading(true);
            authService.changePassword(newPasswordCont.text).then((value) {
              appStore.setLoading(true);
              SignInScreen().launch(context);
              appStore.setLoading(false);
            });
          });
          // });
        }
        appStore.setLoading(false);
      }).catchError((e) {
        appStore.setLoading(false);
      });
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        leading: Navigator.of(context).canPop()
            ? BackWidget(iconColor: context.iconColor)
            : null,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness:
                appStore.isDarkMode ? Brightness.light : Brightness.dark,
            statusBarColor: context.scaffoldBackgroundColor),
      ),
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
                    Image.asset(appLogo, height: 120, width: 120),
                    20.height,
                    Container(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Text(language.desNewPassword,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17)),
                    ),
                    30.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: newPasswordCont,
                      nextFocus: reenterPasswordFocus,
                      errorThisFieldRequired: language.requiredText,
                      suffixPasswordVisibleWidget:
                          ic_show.iconImage(size: 10).paddingAll(14),
                      suffixPasswordInvisibleWidget:
                          ic_hide.iconImage(size: 10).paddingAll(14),
                      decoration: inputDecoration(context,
                          labelText: language.hintNewPasswordTxt),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: reenterPasswordCont,
                      errorThisFieldRequired: language.requiredText,
                      focus: reenterPasswordFocus,
                      suffixPasswordVisibleWidget:
                          ic_show.iconImage(size: 10).paddingAll(14),
                      suffixPasswordInvisibleWidget:
                          ic_hide.iconImage(size: 10).paddingAll(14),
                      validator: (v) {
                        if (newPasswordCont.text != v) {
                          return language.passwordNotMatch;
                        } else if (reenterPasswordCont.text.isEmpty) {
                          return errorThisFieldRequired;
                        }
                        return null;
                      },
                      decoration: inputDecoration(context,
                          labelText: language.hintReenterPasswordTxt),
                    ),
                    20.height,
                    AppButton(
                      onTap: () {
                        changePassword();
                      },
                      text: language.saveChanges,
                      color: primaryColor,
                      textStyle: boldTextStyle(color: white),
                      width: context.width(),
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
