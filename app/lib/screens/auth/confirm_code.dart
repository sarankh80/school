import 'dart:convert';
import 'dart:io';

import 'package:com.gogospider.booking/component/base_scaffold_body.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/login_model.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/network/network_utils.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/screens/auth/new_password.dart';
import 'package:com.gogospider.booking/screens/auth/sign_in_screen.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/model_keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:otp_text_field/otp_text_field.dart' as abc;
import 'package:telephony/telephony.dart';

class ConfirmCode extends StatefulWidget {
  final LoginResponse? userData;
  final String verificationId;
  final int? codition;
  final String numberPhone;
  final String? password;
  final bool? isFromDashboard;
  final bool? isFromServiceBooking;
  final bool returnExpected;
  ConfirmCode(
      {this.userData,
      required this.verificationId,
      this.password,
      this.codition,
      required this.numberPhone,
      this.isFromDashboard,
      this.isFromServiceBooking,
      this.returnExpected = false});

  @override
  State<StatefulWidget> createState() => _ConfirmCodeState();
}

class _ConfirmCodeState extends State<ConfirmCode> {
  String otpCode = '';
  String phoneNumber = '';
  String verificationId = '';

  abc.OtpFieldController otpbox = abc.OtpFieldController();
  TextEditingController pinCode = TextEditingController();

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() => init());
  }

  init() async {
    verificationId = widget.verificationId;
    final bool? result = await Telephony.instance.requestSmsPermissions;

    if (result != null && result) {
      if (Platform.isAndroid) {
        Telephony.instance.listenIncomingSms(
          onNewMessage: (SmsMessage message) {
            //print(message.address); //+977981******67, sender nubmer
            //print(message.body); //Your OTP code is 34567
            //print(message.date); //1659690242000, timestamp
            // String sms = message.body.toString(); //get the message
            // if (message.address == "CloudOTP") {
            //   //verify SMS is sent for OTP with sender number
            //   String otpcode = sms.replaceAll(new RegExp(r'[^0-9]'), '');
            //   //prase code from the OTP sms
            //   pinCode.text = otpcode;
            //   // otpbox.set(otpcode.split(""));
            //   //split otp code to list of number
            //   //and populate to otb boxes
            //   // setState(() {
            //   //   //refresh UI
            //   // });
            // } else {
            //   print("Normal message.");
            // }

            String sms = message.body.toString(); //get the message
            if (message.address == "CloudOTP") {
              List<String> list = sms.split(' ');
              pinCode.text = list[0];
            } else {
              print("Normal message.");
            }
          },
          listenInBackground: false,
        );
      }
    }
  }

  void onLoginSuccessRedirection() {
    if (widget.isFromServiceBooking.validate() ||
        widget.isFromDashboard.validate() ||
        widget.returnExpected.validate()) {
      if (widget.isFromDashboard.validate()) {
        setStatusBarColor(context.primaryColor);
      }
      // finish(context, true);
    } else {
      DashboardScreen().launch(context);
    }
  }

  Future<void> registerWithOTP() async {
    appStore.setLoading(true);
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String pinCodeStr = pinCode.text.toString();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: pinCodeStr);
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((valueFire) async {
      if (widget.codition == 1) {
        phoneNumber = widget.numberPhone;
        phoneNumber = phoneNumber.replaceAll(' ', '');
        phoneNumber = phoneNumber.replaceAll('(', '');
        phoneNumber = phoneNumber.replaceAll(')', '');
        String? email = USER_TYPE_USER + phoneNumber + "@gogospider.com";
        userService.getUserEmail(email: email).then((valueEmail) {
          // print('valueEmail : ${valueEmail.verificationId}');
          NewPasswordScreen(
                  numberPhone: widget.numberPhone,
                  email: email,
                  verificationId: valueEmail.verificationId)
              .launch(context, isNewTask: true);
        });
        appStore.setLoading(false);
      } else {
        await setValue(PLAYERID, '');
        await OneSignal.shared.getDeviceState().then((value) async {
          await setValue(PLAYERID, value!.userId);
        }).catchError(onError);
        Map<String, dynamic> request = {
          UserKeys.firstName: widget.userData!.data!.firstName,
          UserKeys.lastName: widget.userData!.data!.lastName,
          UserKeys.userType: LOGIN_TYPE_USER,
          UserKeys.phoneNumber: widget.userData!.data!.contactNumber,
          UserKeys.password: widget.password,
          UserKeys.passwordConfirmation: widget.password,
          UserKeys.loginType: LOGIN_TYPE_OTP,
          UserKeys.playerId: getStringAsync(PLAYERID),
          UserKeys.verificationId:
              stringToBase64.encode(widget.password.validate()),
          // UserKeys.uid: valueFire.user!.uid
        };
        if (widget.userData != null) {
          String? email = widget.userData!.data!.userType! +
              widget.userData!.data!.contactNumber! +
              "@gogospider.com";
          await userService.getUserEmail(email: email).then((value) async {
            if (value.id != widget.userData!.data!.id) {
              await authService.updateUserDataId(
                  value, widget.userData!.data!.id);
              await authService.updateUserDataPss(
                  value, widget.userData!.data!.id, widget.password);
            }
            appStore.uid = value.uid.toString();
            appStore.playerId = getStringAsync(PLAYERID);
            if (value.id != null) {
              verificationUser(request).then((valueVeri) {
                // userService.userByMobileNumber("095343000").then((value) async {
                //   /// Save receiverId to Sender Doc.
                //   userService
                //       .saveToContacts(
                //           senderId: appStore.uid,
                //           receiverId: value.uid.validate())
                //       .then((value) => log("---ReceiverId to Sender Doc.---"))
                //       .catchError((e) {
                //     log(e.toString());
                //   });

                //   /// Save senderId to Receiver Doc.
                //   userService
                //       .saveToContacts(
                //           senderId: value.uid.validate(),
                //           receiverId: appStore.uid)
                //       .then((value) => log("---SenderId to Receiver Doc.---"))
                //       .catchError((e) {
                //     log(e.toString());
                //   });
                // }).catchError((e) {
                //   log(e.toString());
                // });

                loginUser(request).then((res) async {
                  // print('login res : ${res.data!.toJson()}');
                  res.data!.uid = value.uid.toString();
                  res.data!.username = "${value.firstName} ${value.lastName}";
                  await update(res.data!, res.data!).then((valueUpate) async {
                    await saveUserData(res.data!).then((values) async {
                      onLoginSuccessRedirection();
                      appStore.setLoading(false);
                    });
                  });
                  // await saveUserData(res.data!);
                  // appStore.uid = valueFire.user!.uid;
                  // appStore.setLoading(false);
                  // onLoginSuccessRedirection();
                }).catchError((onError) {
                  appStore.setLoading(false);
                  print(onError.toString());
                  SignInScreen().launch(context);
                });
              }).catchError((e) {
                appStore.setLoading(false);
                print(e.toString());
                toast(language.somethingWentWrong);
                // throw e.toString();
              });
            } else {
              authService
                  .signUpWithPhonePassword(context,
                      registerResponse: widget.userData!,
                      password: widget.password)
                  .then((value) {
                verificationUser(request).then((value) {
                  loginUser(request).then((res) async {
                    await update(res.data!, res.data!).then((v) async {
                      await saveUserData(res.data!).then((values) async {
                        appStore.uid = valueFire.user!.uid;
                        onLoginSuccessRedirection();
                        appStore.setLoading(false);
                      });
                    });
                  }).catchError((onError) {
                    print(onError.toString());
                    appStore.setLoading(false);
                    SignInScreen().launch(context);
                  });
                  // loginUser(request).then((res) async {
                  //   await saveUserData(res.data!);
                  //   appStore.setLoading(false);
                  //   onLoginSuccessRedirection();
                  // }).catchError((onError) {
                  //   appStore.setLoading(false);
                  //   SignInScreen().launch(context);
                  // });
                }).catchError((e) {
                  print(e.toString());
                  appStore.setLoading(false);
                  toast(language.somethingWentWrong);
                });
              });
            }
          });
        } else {
          appStore.setLoading(false);
          print(onError.toString());
          toast(language.somethingWentWrong);
        }
      }
    }).catchError((e) {
      print(e.toString());
      appStore.setLoading(false);
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(language.invalidVerificationCode),
            actions: <Widget>[
              AppButton(
                text: language.lblOk,
                color: primaryColor,
                textColor: Colors.white,
                onTap: () {
                  appStore.setLoading(false);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> resedCode() async {
    appStore.setLoading(true);
    log("Login No Success");
    await authService.loginWithOTP(widget.numberPhone,
        onVerificationIdReceived: (value) {
      if (value.isNotEmpty) {
        verificationId = value;
        toast('Resend Code From GOGO SPIDER');
      }
      appStore.setLoading(false);
    }, onVerificationError: (s) {
      appStore.setLoading(false);
      toast(language.verificationCodeNotSend);
    }).catchError((e) {
      print(e.toString());
      appStore.setLoading(false);
      toast(language.somethingWentWrong, print: true);
      return e.toString();
    });
  }

  Future<void> update(UserData data, UserData value) async {
    hideKeyboard(context);

    MultipartRequest multiPartRequest =
        await getMultiPartRequest('update-profile?id=${data.id}');
    multiPartRequest.fields[UserKeys.firstName] =
        widget.userData!.data!.firstName.validate();
    multiPartRequest.fields[UserKeys.lastName] =
        widget.userData!.data!.lastName.validate();
    multiPartRequest.fields[UserKeys.userType] = LOGIN_TYPE_USER;
    multiPartRequest.fields[UserKeys.password] = widget.password.validate();
    multiPartRequest.fields[UserKeys.email] = value.email.validate();
    multiPartRequest.fields[UserKeys.playerId] = getStringAsync(PLAYERID);
    multiPartRequest.fields[UserKeys.uid] = value.uid.validate();
    multiPartRequest.headers.addAll(buildHeaderTokens());
    appStore.setLoading(true);
    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (datas) async {
        if (datas != null) {
          if ((datas as String).isJson()) {
            return datas;
          }
        }
      },
      onError: (error) {
        print(error.toString());
        toast(language.somethingWentWrong, print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(language.somethingWentWrong, print: true);
      print(e.toString());
    });
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
      body: Body(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
              ),
              Image.asset(appLogo, height: 120, width: 120),
              20.height,
              Text(language.codeVerification,
                  style: boldTextStyle(
                    size: 25,
                  )),
              10.height,
              Text(language.enterOtp,
                  style: boldTextStyle(color: gray, size: 14)),
              10.height,
              Text(language.phone + ": " + widget.numberPhone,
                  style: boldTextStyle()),
              20.height,
              AppTextField(
                textFieldType: TextFieldType.OTHER,
                controller: pinCode,
                autoFocus: true,
                errorThisFieldRequired: language.requiredText,
                decoration: inputDecoration(
                  context,
                  // prefixIcon: Container(
                  //   width: 100,
                  //   margin: EdgeInsets.only(right: 10),
                  //   child: Row(children: [
                  //     Image.asset(
                  //       ic_khmer,
                  //       width: 35,
                  //     ).paddingAll(10),
                  //     Text(
                  //       codeCountry(),
                  //       style: TextStyle(fontSize: 15.5),
                  //     )
                  //   ]),
                  // ),
                ).copyWith(
                  hintStyle: secondaryTextStyle(),
                ),
                validator: (v) {
                  if (v!.isEmpty) {
                    return errorThisFieldRequired;
                  }
                  return null;
                },
              ),
              // abc.OTPTextField(
              //   controller: otpbox,
              //   length: 6,
              //   width: MediaQuery.of(context).size.width,
              //   fieldWidth: 50,
              //   style: TextStyle(fontSize: 17),
              //   textFieldAlignment: MainAxisAlignment.spaceAround,
              //   fieldStyle: FieldStyle.box,
              //   onCompleted: (pin) {
              //     otpCode = pin;
              //   },
              //   onChanged: (s) {
              //     otpCode = s;
              //   },
              // ),
              30.height,
              RichText(
                text: TextSpan(
                    text: language.donotReveiveCode,
                    style: boldTextStyle(color: gray, size: 14),
                    children: [
                      TextSpan(text: "   "),
                      TextSpan(
                        text: language.resendCode,
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => resedCode(),
                        style: boldTextStyle(color: primaryColor),
                      ),
                    ]),
              ),
              20.height,
              AppButton(
                onTap: () {
                  registerWithOTP();
                },
                text: language.confirm,
                color: primaryColor,
                textStyle: boldTextStyle(color: white),
                width: context.width(),
              ),
              Observer(
                builder: (context) =>
                    LoaderWidget().center().visible(appStore.isLoading),
              )
            ],
          ),
        ),
      ),
    );
  }
}
