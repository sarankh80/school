import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/base_scaffold_body.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/screens/auth/sign_up_screen.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/model_keys.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class OTPLoginScreen extends StatefulWidget {
  const OTPLoginScreen({Key? key}) : super(key: key);

  @override
  State<OTPLoginScreen> createState() => _OTPLoginScreenState();
}

class _OTPLoginScreenState extends State<OTPLoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController numberController = TextEditingController();

  String countryCode = '';
  String phoneNumber = '';
  String verificationId = '';
  String otpCode = '';

  bool isCodeSent = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() => init());
  }

  Future<void> init() async {
    appStore.setLoading(false);
  }

  //region Methods
  Future<void> otpLogin() async {
    var request = {
      UserKeys.userName: phoneNumber.replaceAll('+', ''),
      UserKeys.password: phoneNumber.replaceAll('+', ''),
      UserKeys.playerId: getStringAsync(PLAYERID),
      UserKeys.loginType: LOGIN_TYPE_OTP,
    };

    appStore.setLoading(true);
    await loginUser(request, isSocialLogin: true).then((res) async {
      res.data!.password = phoneNumber.validate();

      await userService.getUser(email: res.data!.email).then((value) {
        res.data!.uid = value.uid;

        if (res.data!.userType == LOGIN_TYPE_USER) {
          if (res.data != null) saveUserData(res.data!);

          toast(language.loginSuccessfully);

          DashboardScreen().launch(context,
              isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        } else {
          toast(language.lblOnlyUserCanLoggedInHere);
        }
      }).catchError((e) {
        if (e.toString() == USER_NOT_FOUND) {
          authService.registerUserWhenUserNotFound(
              context, res, phoneNumber.validate());
        } else {
          toast(e.toString());
        }
      });
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  Future<void> submit() async {
    appStore.setLoading(true);

    log('A $verificationId $otpCode');
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpCode);

    // Sign the user in (or link) with the credential
    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) async {
      print("value $value");
      Map req = {
        "email": '',
        "username": phoneNumber.replaceAll('+', ''),
        "first_name": '',
        "last_name": '',
        "login_type": LOGIN_TYPE_OTP,
        "user_type": USER_TYPE_USER,
        "accessToken": phoneNumber.replaceAll('+', ''),
      };

      await loginUser(req, isSocialLogin: true).then((value) async {
        appStore.setLoginType(LOGIN_TYPE_OTP);

        if (value.isUserExist == null) {
          /// Registered
          otpLogin();
        } else {
          /// Not registered
          finish(context);

          SignUpScreen(
            phoneNumber: phoneNumber.replaceAll('+', ''),
            otpCode: otpCode.validate(),
            verificationId: verificationId,
            isOTPLogin: true,
          ).launch(context);
        }
      }).catchError((e) {
        log('loginUser $e');
        if (e.toString().contains('invalid_username')) {
          finish(context);
          SignUpScreen(
            phoneNumber: phoneNumber.replaceAll('+', ''),
            otpCode: otpCode.validate(),
            verificationId: verificationId,
            isOTPLogin: true,
          ).launch(context);
        } else if (e.toString() == USER_NOT_FOUND) {
          //authService.registerUserWhenUserNotFound(context, value, passwordCont.text.trim());
        } else {
          toast(e.toString(), print: true);
        }
      });
    }).catchError((e) {
      log('signInWithCredential $e');
      if (e.toString().contains('invalid-verification-code')) {
        toast('Invalid Verification Code', print: true);
      } else {
        toast(e.toString());
      }
    });

    appStore.setLoading(false);
  }

  Future<void> sendOTP() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      hideKeyboard(context);

      String number = '+$countryCode${numberController.text.trim()}';

      if (!number.startsWith('+')) {
        number = '+$countryCode${numberController.text.trim()}';
      }
      phoneNumber = number;
      appStore.setLoading(true);
      toast('Sending OTP');
      await authService.loginWithOTP(number, onVerificationIdReceived: (value) {
        if (appStore.isLoading && value.isNotEmpty) {
          verificationId = value;
          isCodeSent = true;
          setState(() {});
          toast('OTP Sent');
        }
        appStore.setLoading(false);
      }, onVerificationError: (s) {
        toast(s);
        appStore.setLoading(false);
      }).then((value) {
        //
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    }
  }

  //endregion

  Widget _buildMainWidget() {
    if (!isCodeSent) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language.lblenterPhnNumber, style: boldTextStyle()),
          16.height,
          Container(
            child: Row(
              children: [
                CountryCodePicker(
                  initialSelection: '+91',
                  showCountryOnly: false,
                  showFlag: true,
                  showFlagDialog: true,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  dialogBackgroundColor: context.cardColor,
                  textStyle: primaryTextStyle(size: 18),
                  onInit: (c) {
                    countryCode = c!.dialCode.validate();
                  },
                  onChanged: (c) {
                    countryCode = c.dialCode.validate();
                  },
                ),
                2.width,
                Form(
                  key: formKey,
                  child: AppTextField(
                    controller: numberController,
                    textFieldType: TextFieldType.PHONE,
                    decoration: inputDecoration(context),
                    autoFocus: true,
                    onFieldSubmitted: (s) {
                      sendOTP();
                    },
                  ).expand(),
                ),
              ],
            ),
          ),
          30.height,
          AppButton(
            onTap: () {
              sendOTP();
            },
            text: language.btnSendOtp,
            color: primaryColor,
            textStyle: boldTextStyle(color: white),
            width: context.width(),
          )
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(language.enterOtp, style: boldTextStyle()),
          30.height,
          OTPTextField(
            pinLength: 6,
            onChanged: (s) {
              otpCode = s;
            },
            onCompleted: (pin) {
              otpCode = pin;
              submit();
            },
          ).fit(),
          30.height,
          AppButton(
            onTap: () {
              submit();
            },
            text: language.confirm,
            color: primaryColor,
            textStyle: boldTextStyle(color: white),
            width: context.width(),
          ),
        ],
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
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
      body: Body(
        child: Container(
          padding: EdgeInsets.all(16),
          child: _buildMainWidget(),
        ),
      ),
    );
  }
}
