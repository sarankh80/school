import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> forgotPwd() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      appStore.setLoading(true);
      phoneNumber = phoneCont.text.trim();
      phoneNumber = phoneNumber.replaceAll(' ', '');
      phoneNumber = phoneNumber.replaceAll('(', '');
      phoneNumber = phoneNumber.replaceAll(')', '');
      Map req = {
        // UserKeys.email: emailCont.text.validate(),
        UserKeys.phoneNumber: phoneNumber,
      };
      forgotPassword(req).then((res) {
        appStore.setLoading(false);
        finish(context);

        toast(res.message.validate());
      }).catchError((e) {
        toast(e.toString(), print: true);
      }).whenComplete(() => appStore.setLoading(false));
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
              width: context.width(),
              decoration: boxDecorationDefault(
                  color: context.primaryColor,
                  borderRadius: radiusOnly(
                      topRight: defaultRadius, topLeft: defaultRadius)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.forgotPassword,
                      style: boldTextStyle(color: Colors.white, size: 18)),
                  IconButton(
                    onPressed: () {
                      finish(context);
                    },
                    icon: Icon(Icons.clear, color: Colors.white, size: 20),
                  )
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${language.hintEmailAddressTxt}",
                    style: boldTextStyle(size: 20)),
                2.height,
                Text(language.lblForgotPwdSubtitle,
                    style: secondaryTextStyle()),
                16.height,
                // Observer(
                //   builder: (_) => AppTextField(
                //     textFieldType: TextFieldType.EMAIL,
                //     controller: emailCont,
                //     autoFocus: true,
                //     errorThisFieldRequired: language.requiredText,
                //     decoration: inputDecoration(context,
                //         labelText: language.hintEmailTxt),
                //   ).visible(!appStore.isLoading, defaultWidget: Loader()),
                // ),
                Container(
                  child: AppTextField(
                    textFieldType: TextFieldType.PHONE,
                    controller: phoneCont,
                    autoFocus: true,
                    errorThisFieldRequired: language.requiredText,
                    decoration: inputDecoration(
                      context,
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
                    inputFormatters: [
                      // MaskedInputFormatter("(0)## ### ####"),
                      phoneInputFormatter()
                    ],
                  ),
                ),
                26.height,
                AppButton(
                  text: language.resetPassword,
                  height: 35,
                  color: primaryColor,
                  textStyle: primaryTextStyle(color: white),
                  width: context.width() - context.navigationBarHeight,
                  onTap: () {
                    if (getStringAsync(USER_PHONE) != DEFAULT_PHONE) {
                      forgotPwd();
                    } else {
                      toast(language.lblUnAuthorized);
                      finish(context);
                    }
                  },
                ),
              ],
            ).paddingAll(16),
          ],
        ),
      ),
    );
  }
}
