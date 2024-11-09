import 'package:com.gogospider.booking/screens/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class DialogTokenExpired extends StatelessWidget {
  final String msg;

  DialogTokenExpired({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(logout_image,
                width: context.width(), fit: BoxFit.cover),
            32.height,
            Text(language.lblYourSessionExpiredTitle,
                textAlign: TextAlign.center, style: boldTextStyle(size: 25)),
            16.height,
            Text(language.lblYourSessionExpiredSubTitle,
                textAlign: TextAlign.center,
                style: secondaryTextStyle(size: 18)),
            28.height,
            Row(
              children: [
                16.width,
                AppButton(
                  child: Text(language.lblLogin,
                      style: boldTextStyle(color: white)),
                  color: context.primaryColor,
                  elevation: 0,
                  onTap: () async {
                    if (await isNetworkAvailable()) {
                      appStore.setLoading(true);

                      await clearPreferences();
                      appStore.setLoading(false);
                      SignInScreen().launch(context,
                          isNewTask: true,
                          pageRouteAnimation: PageRouteAnimation.Fade);
                    } else {
                      toast(errorInternetNotAvailable);
                    }
                  },
                ).expand(),
              ],
            ),
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 24),
        // Observer(
        //     builder: (_) => LoaderWidget()
        //         .withSize(width: 60, height: 60)
        //         .visible(appStore.isLoading)),
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}

bool isViewAllVisible(List list) => list.length >= 4;
