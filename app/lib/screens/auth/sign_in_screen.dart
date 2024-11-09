import 'package:com.gogospider.booking/component/base_scaffold_body.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/network/network_utils.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/screens/auth/forgot_screen.dart';
import 'package:com.gogospider.booking/screens/auth/otp_login_screen.dart';
import 'package:com.gogospider.booking/screens/auth/sign_up_screen.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/model_keys.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uuid/uuid.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignInScreen extends StatefulWidget {
  final bool? isFromDashboard;
  final bool? isFromServiceBooking;
  final bool returnExpected;

  SignInScreen(
      {this.isFromDashboard,
      this.isFromServiceBooking,
      this.returnExpected = false});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  String phoneNumber = '';
  bool isRemember = true;
  var uuid = Uuid();
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    log("App Token ${appStore.token}");
    isRemember = getBoolAsync(IS_REMEMBERED, defaultValue: true);
    if (isRemember) {
      // emailCont.text = getStringAsync(USER_EMAIL);
      phoneCont.text = getStringAsync(USER_PHONE);
      // passwordCont.text = getStringAsync(USER_PASSWORD);
    } else {
      if (isIqonicProduct) {
        // emailCont.text = DEFAULT_EMAIL;
        phoneCont.text = "";
        passwordCont.text = DEFAULT_PASS;
      }
    }
    afterBuildCreated(() {
      if (getStringAsync(PLAYERID).isEmpty) saveOneSignalPlayerId();
    });
  }

  //region Methods
  void loginUsers() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      appStore.setLoading(true);
      phoneNumber = phoneCont.text.trim();
      phoneNumber = phoneNumber.replaceAll(' ', '');
      phoneNumber = phoneNumber.replaceAll('(', '');
      phoneNumber = phoneNumber.replaceAll(')', '');
      await setValue(PLAYERID, '');
      await OneSignal.shared.getDeviceState().then((value) async {
        await setValue(PLAYERID, value!.userId);
        var request = {
          // UserKeys.email: "info@gogospider.com",
          UserKeys.phoneNumber: phoneNumber,
          UserKeys.password: passwordCont.text.trim(),
          UserKeys.playerId:
              getStringAsync(PLAYERID, defaultValue: value.userId.toString()),
          // UserKeys.uid: uuid.v4().toString(),
        };
        if (isRemember) {
          // await setValue(USER_EMAIL, emailCont.text);
          await setValue(CONTACT_NUMBER, phoneNumber);
          await setValue(USER_PASSWORD, passwordCont.text.trim());
          await setValue(IS_REMEMBERED, isRemember);
        }

        await loginUser(request).then((res) async {
          if (res.data == null) {
            appStore.setLoading(false);
            return showDialog(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(res.message.toString()),
                  actions: <Widget>[
                    AppButton(
                      text: language.signUp,
                      textColor: Colors.white,
                      color: warningColor,
                      onTap: () {
                        Navigator.of(context).pop();
                        SignUpScreen().launch(context);
                      },
                    ),
                    AppButton(
                      text: language.lblLogin,
                      textColor: Colors.white,
                      color: primaryColor,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
          res.data!.password = passwordCont.text.trim();
          // await userService.getUser(email: res.data!.email).then((value) async {
          await _auth
              .signInWithEmailAndPassword(
                  email: res.data!.email.validate(),
                  password: passwordCont.text.trim())
              .then((valuepass) {
            userService
                .userByMobileNumber(
                    phoneNumber, res.data!.email, res.data!.userType)
                .then((value) async {
              authService.updateUserDataPss(
                  value, value.id, passwordCont.text.trim());
              res.data!.uid = value.uid.validate();
              if (res.data!.userType == LOGIN_TYPE_USER) {
                if (res.data != null) {
                  if (res.data!.apiToken.validate().isNotEmpty)
                    await appStore.setToken(res.data!.apiToken.validate());
                  await update(res.data!, value).then((v) async {
                    await saveUserData(res.data!).then((values) async {
                      appStore.uid = value.uid.validate();
                      onLoginSuccessRedirection();
                      appStore.setLoading(false);
                    });
                  }).catchError((onError) async {
                    await appStore.setToken('').then((value) {
                      appStore.setLoading(false);
                      return showDialog(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(language.somethingWentWrong),
                            actions: <Widget>[
                              AppButton(
                                text: language.lblLogin,
                                textColor: Colors.white,
                                color: primaryColor,
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    });
                  });
                }

                /// Save receiverId to Sender Doc.
                ///  await userService
                // await userService
                //     .userByMobileNumber("095343000")
                //     .then((value) async {
                //   /// Save receiverId to Sender Doc.
                //   // userService
                //   //     .saveToContacts(
                //   //         senderId: appStore.uid, receiverId: value.uid.validate())
                //   //     .then((value) => log("---ReceiverId to Sender Doc.---"))
                //   //     .catchError((e) {
                //   //   log(e.toString());
                //   // });

                //   /// Save senderId to Receiver Doc.
                //   userService
                //       .saveToContacts(
                //           senderId: value.uid.validate(), receiverId: appStore.uid)
                //       .then((value) => log("---SenderId to Receiver Doc.---"))
                //       .catchError((e) {
                //     log(e.toString());
                //   });

                // }).catchError((e) {
                //   log(e.toString());
                // });
              } else {
                appStore.setLoading(false);
                return showDialog(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text(language.somethingWentWrong),
                      actions: <Widget>[
                        AppButton(
                          text: language.lblLogin,
                          textColor: Colors.white,
                          color: primaryColor,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            }).catchError((e) {
              if (e.toString() == USER_NOT_FOUND) {
                authService
                    .signUpWithPhonePassword(context,
                        registerResponse: res,
                        password: passwordCont.text.trim())
                    .then((value) async {
                  authService.updateUserDataPss(
                      res.data!, res.data!.id, passwordCont.text.trim());
                  log("Firebase Login Register Done.");
                  await userService
                      .userByMobileNumber(
                          phoneNumber, res.data!.email, res.data!.userType)
                      .then((value) async {
                    res.data!.uid = value.uid.validate();
                    if (res.data!.userType == LOGIN_TYPE_USER) {
                      if (res.data != null) {
                        if (res.data!.apiToken.validate().isNotEmpty)
                          await appStore
                              .setToken(res.data!.apiToken.validate());
                        await update(res.data!, value).then((v) async {
                          await saveUserData(res.data!).then((values) async {
                            appStore.uid = value.uid.validate();
                            appStore.setLoading(false);
                            onLoginSuccessRedirection();
                          });
                        }).catchError((onError) async {
                          await appStore.setToken('').then((value) {
                            appStore.setLoading(false);
                            return showDialog(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(language.somethingWentWrong),
                                  actions: <Widget>[
                                    AppButton(
                                      text: language.lblLogin,
                                      textColor: Colors.white,
                                      color: primaryColor,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        });
                      }
                    }
                  });
                }).catchError((e) {
                  // print("USER_CANNOT_LOGIN1 $USER_CANNOT_LOGIN");
                  appStore.setLoading(false);
                  if (e.toString() == USER_CANNOT_LOGIN) {
                    toast(language.lblLoginAgain);
                    SignInScreen().launch(context, isNewTask: true);
                  } else if (e.toString() == USER_NOT_CREATED) {
                    toast(language.lblLoginAgain);
                    SignInScreen().launch(context, isNewTask: true);
                  }
                });
                // authService.registerUserWhenUserNotFound(
                //     context, res, passwordCont.text.trim());
                // authService.signUpWithOTP(context, res.data!).then((value) {});
                // authService
                //     .loginUpWithPhone(context, res, passwordCont.text.trim())
                //     .then((value) {
                //   onLoginSuccessRedirection();
                // });
              } else {
                // print("USER_CANNOT_LOGIN2 $USER_CANNOT_LOGIN");
                appStore.setLoading(false);
                toast(language.somethingWentWrong);
              }
            });
          }).catchError((e) {
            print("USER_CANNOT_LOGIN3 $USER_CANNOT_LOGIN");
            // appStore.setLoading(false);
            // toast(language.somethingWentWrong, print: true);
            authService
                .signUpWithPhonePassword(context,
                    registerResponse: res, password: passwordCont.text.trim())
                .then((value) async {
              authService.updateUserDataPss(
                  res.data!, res.data!.id, passwordCont.text.trim());
              log("Firebase Login Register Done.");
              await userService
                  .userByMobileNumber(
                      phoneNumber, res.data!.email, res.data!.userType)
                  .then((value) async {
                res.data!.uid = value.uid.validate();
                if (res.data!.userType == LOGIN_TYPE_USER) {
                  if (res.data != null) {
                    if (res.data!.apiToken.validate().isNotEmpty)
                      await appStore.setToken(res.data!.apiToken.validate());
                    await update(res.data!, value).then((v) async {
                      await saveUserData(res.data!).then((values) async {
                        appStore.uid = value.uid.validate();
                        appStore.setLoading(false);
                        onLoginSuccessRedirection();
                      });
                    }).catchError((onError) async {
                      await appStore.setToken('').then((value) {
                        appStore.setLoading(false);
                        return showDialog(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(language.somethingWentWrong),
                              actions: <Widget>[
                                AppButton(
                                  text: language.lblLogin,
                                  textColor: Colors.white,
                                  color: primaryColor,
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      });
                    });
                  }
                }
              });
            }).catchError((e) {
              appStore.setLoading(false);
              if (e.toString() == USER_CANNOT_LOGIN) {
                toast(language.lblLoginAgain);
                SignInScreen().launch(context, isNewTask: true);
              } else if (e.toString() == USER_NOT_CREATED) {
                toast(language.lblLoginAgain);
                SignInScreen().launch(context, isNewTask: true);
              }
            });
          });
        }).catchError((e) {
          appStore.setLoading(false);
          toast(language.somethingWentWrong);
        });
      }).catchError((onError) {
        appStore.setLoading(false);
        toast(language.somethingWentWrong);
      });
    }
  }

  Future<void> update(UserData data, UserData value) async {
    hideKeyboard(context);

    MultipartRequest multiPartRequest =
        await getMultiPartRequest('update-profile?id=${data.id}');
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
        // appStore.setLoading(false);
      },
      onError: (error) {
        toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  void googleSignIn() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    await authService.signInWithGoogle().then((value) async {
      appStore.setLoading(false);

      onLoginSuccessRedirection();
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void otpSignIn() async {
    hideKeyboard(context);

    OTPLoginScreen().launch(context);
    /*appStore.setLoading(true);

    await showInDialog(
      context,
      contentPadding: EdgeInsets.zero,
      builder: (p0) => AppCommonDialog(title: language.lblOTPLogin, child: OTPDialog()),
    );

    appStore.setLoading(false);*/
  }

  void onLoginSuccessRedirection() {
    if (widget.isFromServiceBooking.validate() ||
        widget.isFromDashboard.validate() ||
        widget.returnExpected.validate()) {
      if (widget.isFromDashboard.validate()) {
        // setStatusBarColor(context.primaryColor);
      }
      finish(context, true);
    } else {
      // DashboardScreen().launch(context,
      //     isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      DashboardScreen().launch(context);
    }
  }

  //endregion

  //region Widgets
  Widget _buildTopWidget() {
    return Container(
      child: Column(
        children: [
          16.height,
          Text(language.welcomeBack,
                  style: primaryTextStyle(size: 16),
                  textAlign: TextAlign.center)
              .center()
              .paddingSymmetric(horizontal: 32),
          32.height,
        ],
      ),
    );
  }

  Widget _buildFormWidget() {
    return Column(
      children: [
        // AppTextField(
        //   textFieldType: TextFieldType.EMAIL,
        //   controller: emailCont,
        //   focus: emailFocus,
        //   nextFocus: passwordFocus,
        //   errorThisFieldRequired: language.requiredText,
        //   decoration:
        //       inputDecoration(context, labelText: language.hintEmailTxt),
        //   suffix: ic_message.iconImage(size: 10).paddingAll(14),
        //   autoFillHints: [AutofillHints.email],
        // ),
        Container(
          child: AppTextField(
            textFieldType: TextFieldType.PHONE,
            controller: phoneCont,
            focus: phoneFocus,
            // readOnly: widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
            errorThisFieldRequired: language.requiredText,
            nextFocus: passwordFocus,
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
        16.height,
        AppTextField(
          textFieldType: TextFieldType.PASSWORD,
          controller: passwordCont,
          focus: passwordFocus,
          suffixPasswordVisibleWidget:
              ic_show.iconImage(size: 10).paddingAll(14),
          suffixPasswordInvisibleWidget:
              ic_hide.iconImage(size: 10).paddingAll(14),
          errorThisFieldRequired: language.requiredText,
          decoration:
              inputDecoration(context, labelText: language.hintPasswordTxt),
          onFieldSubmitted: (s) {
            loginUsers();
          },
        ),
        16.height,
      ],
    );
  }

  Widget _buildRememberWidget() {
    return Column(
      children: [
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundedCheckBox(
              borderColor: context.primaryColor,
              checkedColor: context.primaryColor,
              isChecked: isRemember,
              text: language.rememberMe,
              textStyle: secondaryTextStyle(),
              size: 20,
              onTap: (value) async {
                await setValue(IS_REMEMBERED, isRemember);
                isRemember = !isRemember;
                setState(() {});
              },
            ),
            TextButton(
              onPressed: () {
                ForGotScreen().launch(context);
                // showInDialog(
                //   context,
                //   contentPadding: EdgeInsets.zero,
                //   dialogAnimation: DialogAnimation.SLIDE_TOP_BOTTOM,
                //   builder: (_) => ForgotPasswordScreen(),
                // );
              },
              child: Text(
                language.forgotPassword,
                style: boldTextStyle(
                    color: primaryColor, fontStyle: FontStyle.italic),
              ),
            ).flexible(),
          ],
        ),
        24.height,
        AppButton(
          text: language.lblSignInHere,
          color: primaryColor,
          textStyle: boldTextStyle(color: white),
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            loginUsers();
          },
        ),
        16.height,
        AppButton(
          text: language.txtCreateAccount,
          color: primaryColor,
          textStyle: boldTextStyle(color: white),
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            SignUpScreen().launch(context);
          },
        ),
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(language.doNotHaveAccount, style: secondaryTextStyle()),
            TextButton(
              onPressed: () {
                hideKeyboard(context);
                SignUpScreen().launch(context);
              },
              child: Text(
                language.signUp,
                style: boldTextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
        // TextButton(
        //   onPressed: () {
        //     if (isAndroid) {
        //       launchUrl(
        //           Uri.parse(
        //               '${getSocialMediaLink(LinkProvider.PLAY_STORE)}$PROVIDER_PACKAGE_NAME'),
        //           mode: LaunchMode.externalApplication);
        //     } else {
        //       commonLaunchUrl(IOS_LINK_FOR_PARTNER,
        //           launchMode: LaunchMode.externalNonBrowserApplication);
        //     }
        //   },
        //   child: Text('Register as Partner',
        //       style: boldTextStyle(color: primaryColor)),
        // )
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (widget.isFromServiceBooking.validate()) {
      setStatusBarColor(Colors.transparent,
          statusBarIconBrightness: Brightness.dark);
    }
    if (widget.isFromDashboard.validate()) {
      setStatusBarColor(Colors.transparent,
          statusBarIconBrightness: Brightness.dark);
    }
    setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.light);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DBHelper().deleteAllCartItem();
    // appStore.setLoading(false);
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
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                ),
                Image.asset(appLogo, height: 100, width: 100),
                _buildTopWidget(),
                _buildFormWidget(),
                _buildRememberWidget(),
                30.height,
                Observer(
                    builder: (_) =>
                        LoaderWidget().center().visible(appStore.isLoading)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
