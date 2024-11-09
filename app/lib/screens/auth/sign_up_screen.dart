import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/component/selected_item_widget.dart';
import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/screens/auth/confirm_code.dart';
import 'package:com.gogospider.booking/screens/auth/sign_in_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/configs.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/model_keys.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:telephony/telephony.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  final String? phoneNumber;
  final bool? isOTPLogin;
  final String? verificationId;
  final String? otpCode;

  SignUpScreen(
      {this.phoneNumber,
      this.isOTPLogin = false,
      this.otpCode,
      this.verificationId});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserData userModel = UserData();
  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  String phoneNumber = '';
  String verificationId = '';
  bool isAcceptedTc = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await Telephony.instance.requestSmsPermissions;
    mobileCont.text =
        widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
    passwordCont.text =
        widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
    userNameCont.text =
        widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> registerWithOTP() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      appStore.setLoading(true);
      phoneNumber = mobileCont.text.trim();
      phoneNumber = phoneNumber.replaceAll(' ', '');
      phoneNumber = phoneNumber.replaceAll('(', '');
      phoneNumber = phoneNumber.replaceAll(')', '');
      await OneSignal.shared.getDeviceState().then((values) async {
        await setValue(PLAYERID, values!.userId);
      }).catchError(onError);
      Map<String, dynamic> request = {
        UserKeys.firstName: fNameCont.text.trim(),
        UserKeys.lastName: lNameCont.text.trim(),
        UserKeys.userName: userNameCont.text.trim(),
        UserKeys.userType: LOGIN_TYPE_USER,
        UserKeys.phoneNumber: widget.phoneNumber ?? phoneNumber,
        UserKeys.email: LOGIN_TYPE_USER + phoneNumber + "@gogospider.com",
        UserKeys.password: widget.phoneNumber ?? passwordCont.text.trim(),
        UserKeys.passwordConfirmation:
            widget.phoneNumber ?? passwordCont.text.trim(),
        UserKeys.codition: 0,
        UserKeys.uid: userModel.uid,
        UserKeys.playerId: getStringAsync(PLAYERID),
        UserKeys.loginType: LOGIN_TYPE_OTP
      };

      await createUser(request).then((value) async {
        if (value.data == null) {
          appStore.setLoading(false);
          showDialog(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(value.message.toString()),
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
        } else {
          sendOTP(value);
        }
      }).catchError((e) {
        appStore.setLoading(false);
        toast(language.somethingWentWrong);
      });
    }
  }

  Future<void> sendOTP(request) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      String number =
          '+$DEFAULT_COUNTRY_PHONE${phoneNumber.substring(1).trim()}';
      if (!number.startsWith('+')) {
        number = '+$DEFAULT_COUNTRY_PHONE${phoneNumber.substring(1).trim()}';
      }
      phoneNumber = number;
      appStore.setLoading(true);
      await authService.loginWithOTP(number,
          onVerificationIdReceived: (verificationId) {
        if (verificationId.isNotEmpty) {
          appStore.setLoading(true);
          // verificationId = verificationId;
          // setValue("verificationId", "");
          // setValue("verificationId", verificationId);
          ConfirmCode(
                  userData: request,
                  codition: 0,
                  password: widget.phoneNumber ?? passwordCont.text.trim(),
                  verificationId: verificationId,
                  numberPhone: number)
              .launch(context);
          toast('Code From GOGO SPIDER');
          appStore.setLoading(false);
        }
      }, onVerificationError: (s) {
        print(s.toString());
        toast(language.verificationCodeNotSend);
        appStore.setLoading(false);
      }).then((values) {
        // ConfirmCode(
        //         userData: request,
        //         codition: 0,
        //         password: widget.phoneNumber ?? passwordCont.text.trim(),
        //         verificationId: getStringAsync("verificationId"),
        //         numberPhone: number)
        //     .launch(context);
        // toast('Code From GOGO SPIDER');
        appStore.setLoading(true);
      }).catchError((e) {
        print(e.toString());
        appStore.setLoading(false);
        toast(language.somethingWentWrong, print: true);
      });
    }
  }

  Widget _buildTopWidget() {
    return Column(
      children: [
        Container(
          child: Image.asset(appLogo, height: 100, width: 100),
        ),
        16.height,
        Text(language.lblSignUpInfo,
                style: primaryTextStyle(size: 18), textAlign: TextAlign.center)
            .center()
            .paddingSymmetric(horizontal: 32),
      ],
    );
  }

  Widget _buildFormWidget() {
    return Column(
      children: [
        32.height,
        Container(
          child: AppTextField(
            textFieldType: TextFieldType.PHONE,
            controller: mobileCont,
            focus: mobileFocus,
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
            ).copyWith(
              hintStyle: secondaryTextStyle(),
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
          textFieldType: TextFieldType.NAME,
          controller: fNameCont,
          focus: fNameFocus,
          nextFocus: lNameFocus,
          errorThisFieldRequired: language.requiredText,
          decoration:
              inputDecoration(context, labelText: language.hintFirstNameTxt),
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: lNameCont,
          focus: lNameFocus,
          nextFocus: passwordFocus,
          errorThisFieldRequired: language.requiredText,
          decoration:
              inputDecoration(context, labelText: language.hintLastNameTxt),
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        ),
        // AppTextField(
        //   textFieldType: TextFieldType.USERNAME,
        //   controller: userNameCont,
        //   focus: userNameFocus,
        //   // nextFocus: emailFocus,
        //   nextFocus: mobileFocus,
        //   readOnly: widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
        //   errorThisFieldRequired: language.requiredText,
        //   decoration:
        //       inputDecoration(context, labelText: language.hintUserNameTxt),
        //   suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        // ),
        // 16.height,
        // AppTextField(
        //   textFieldType: TextFieldType.EMAIL,
        //   controller: emailCont,
        //   focus: emailFocus,
        //   errorThisFieldRequired: language.requiredText,
        //   nextFocus: mobileFocus,
        //   decoration:
        //       inputDecoration(context, labelText: language.hintEmailTxt),
        //   suffix: ic_message.iconImage(size: 10).paddingAll(14),
        // ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.PASSWORD,
          controller: passwordCont,
          focus: passwordFocus,
          readOnly: widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
          suffixPasswordVisibleWidget:
              ic_show.iconImage(size: 10).paddingAll(14),
          suffixPasswordInvisibleWidget:
              ic_hide.iconImage(size: 10).paddingAll(14),
          errorThisFieldRequired: language.requiredText,
          decoration:
              inputDecoration(context, labelText: language.hintPasswordTxt),
          onFieldSubmitted: (s) {
            // if (widget.isOTPLogin == false)
            //   registerUser();
            // else
            // registerWithOTP();
          },
        ),
        20.height,
        _buildTcAcceptWidget(),
        8.height,
        AppButton(
          text: language.signUp,
          color: primaryColor,
          textStyle: boldTextStyle(color: white),
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            // if (widget.isOTPLogin == false)
            //   registerUser();
            // else
            registerWithOTP();
          },
        ),
      ],
    );
  }

  Widget _buildTcAcceptWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SelectedItemWidget(isSelected: isAcceptedTc).onTap(() async {
          isAcceptedTc = !isAcceptedTc;
          setState(() {});
        }),
        16.width,
        RichTextWidget(
          list: [
            TextSpan(
                text: '${language.lblAgree} ', style: secondaryTextStyle()),
            // TextSpan(
            //   text: language.lblTermsOfService,
            //   style: boldTextStyle(color: primaryColor, size: 14),
            //   recognizer: TapGestureRecognizer()
            //     ..onTap = () {
            //       // commonLaunchUrl(TERMS_CONDITION_URL,
            //       //     launchMode: LaunchMode.externalApplication);
            //     },
            // ),
            // TextSpan(text: ' & ', style: secondaryTextStyle()),
            TextSpan(
              text: language.lblPrivacyPolicy,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  commonLaunchUrl(PRIVACY_POLICY_URL,
                      launchMode: LaunchMode.externalApplication);
                },
            ),
          ],
        ).flexible(flex: 2),
      ],
    ).paddingSymmetric(vertical: 16);
  }

  Widget _buildFooterWidget() {
    return Column(
      children: [
        16.height,
        RichTextWidget(
          list: [
            TextSpan(
                text: "${language.alreadyHaveAccountTxt} ",
                style: secondaryTextStyle()),
            TextSpan(
              text: language.lblSignInHere,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // finish(context);
                  SignInScreen().launch(context);
                },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DBHelper().deleteAllCartItem();
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: context.scaffoldBackgroundColor,
      //   leading: BackWidget(iconColor: context.iconColor),
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                    ),
                    _buildTopWidget(),
                    _buildFormWidget(),
                    8.height,
                    _buildFooterWidget(),
                  ],
                ),
              ),
            ),
            Observer(
                builder: (_) =>
                    LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
