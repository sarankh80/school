import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class NewUpdateDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: context.width() - 16,
          constraints: BoxConstraints(maxHeight: context.height() * 0.6),
          child: AnimatedScrollView(
            listAnimationType: ListAnimationType.FadeIn,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    appLogo,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              10.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.lblTimeToUpdate,
                      style: boldTextStyle(size: 20)),
                  Text(
                      isAndroid
                          ? remoteConfigDataModel.android!.versionName
                              .validate()
                          : remoteConfigDataModel.iOS!.versionName.validate(),
                      style: boldTextStyle()),
                ],
              ),
              8.height,
              Text(
                  language
                      .weFixeSomeBugAndAddedSomeFeatureToMakeYourExperienceAsSmoothAsPossible,
                  style: secondaryTextStyle(size: 12),
                  textAlign: TextAlign.left),
              10.height,
              UL(
                spacing: 0,
                children: remoteConfigDataModel.changeLogs!.map((e) {
                  return Text(e.validate(), style: primaryTextStyle(size: 14));
                }).toList(),
              ),
              24.height,
              Row(
                children: [
                  // AppButton(
                  //   child: Text(language.lblCancel,
                  //       style: boldTextStyle(color: primaryColor)),
                  //   shapeBorder: RoundedRectangleBorder(
                  //       borderRadius: radius(),
                  //       side: BorderSide(color: primaryColor)),
                  //   elevation: 0,
                  //   onTap: () async {
                  //     if (remoteConfigDataModel.isForceUpdate!) {
                  //       exit(0);
                  //     } else {
                  //       finish(context);
                  //     }
                  //   },
                  // ).expand(),
                  // 16.width,
                  AppButton(
                    child: Text(language.lblUpdateNow,
                        style: boldTextStyle(color: white)),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                    color: primaryColor,
                    elevation: 0,
                    onTap: () async {
                      getPackageName().then((value) {
                        String package = APP_STORE_ID;
                        if (isAndroid) package = value;

                        commonLaunchUrl(
                          '${isAndroid ? getSocialMediaLink(LinkProvider.PLAY_STORE) : getSocialMediaLink(LinkProvider.APPSTORE)}$package',
                          launchMode: LaunchMode.externalApplication,
                        );

                        // if (remoteConfigDataModel.isForceUpdate!) {
                        //   exit(0);
                        // } else {
                        //   finish(context);
                        // }
                      }).catchError((onError) {
                        log(onError.toString());
                      });
                    },
                  ).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 24),
        ),
        // Positioned(
        //   top: 20,
        //   child: Image.asset(
        //     appLogo,
        //     height: 100,
        //     width: 100,
        //     fit: BoxFit.cover,
        //   ),
        // ),
      ],
    );
  }
}
