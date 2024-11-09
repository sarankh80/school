import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/screens/maintenance_mode_screen.dart';
import 'package:com.gogospider.booking/screens/our_services_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/configs.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'walk_through_screen.dart';

class SelectLanguageScreen extends StatefulWidget {
  @override
  _SelectLanguageScreenState createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  @override
  void initState() {
    super.initState();
    // init();
  }

  Future<void> init() async {
    appStore.setAlertChooseLocation(true);
    afterBuildCreated(() async {
      setStatusBarColor(Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness:
              appStore.isDarkMode ? Brightness.light : Brightness.dark);

      await appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE,
          defaultValue: DEFAULT_LANGUAGE));

      int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
      if (themeModeIndex == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(
            MediaQuery.of(context).platformBrightness == Brightness.dark);
      }

      if (isAndroid || isIOS) {
        await getPackageName().then((value) {
          currentPackageName = value;
        }).catchError(onError);
      }

      await 500.milliseconds.delay;

      if (getBoolAsync(IN_MAINTENANCE_MODE)) {
        MaintenanceModeScreen().launch(context,
            isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      } else {
        if (getBoolAsync(IS_FIRST_TIME, defaultValue: true)) {
          WalkThroughScreen().launch(context,
              isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        } else {
          DashboardScreen().launch(context,
              isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildImageWidget(String imagePath) {
      if (imagePath.startsWith('http')) {
        return Image.network(imagePath, height: 60);
      } else {
        return Image.asset(imagePath, height: 60);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          // fit: StackFit.expand,
          children: [
            Image.asset(
              appStore.isDarkMode ? splash_background : splash_light_background,
              height: context.height(),
              width: context.width(),
              fit: BoxFit.cover,
            ),
            SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  50.height,
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          walk_Img1,
                          width: MediaQuery.of(context).size.width * 0.70,
                        ),
                        20.height,
                        Text(
                          "សូមស្វាគមន៍",
                          style: boldTextStyle(size: 40, color: warningColor),
                        ),
                        10.height,
                        Text(
                          "Welcome To GoGoSpider",
                          style: boldTextStyle(size: 25, color: warningColor),
                        ),
                        30.height,
                        Text(
                          "សូមជ្រើសរើស ភាសាខាងក្រោម",
                          style: secondaryTextStyle(size: 18, color: black),
                        ),
                        10.height,
                        Text(
                          "Please choose your languages!",
                          style: secondaryTextStyle(size: 18, color: black),
                        ),
                        30.height,
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    child: Center(
                        widthFactor: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          // reverse: true,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, index) {
                            LanguageDataModel data = localeLanguageList[index];
                            return Container(
                              child: Column(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: getStringAsync(
                                                          SELECTED_LANGUAGE_CODE) ==
                                                      data.languageCode
                                                          .validate()
                                                  ? warningColor
                                                  : white),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(children: [
                                        _buildImageWidget(data.flag.validate()),
                                        Text(
                                          data.name.validate(),
                                          style: boldTextStyle(),
                                        )
                                      ])).onTap(() async {
                                    await setValue(SELECTED_LANGUAGE_CODE,
                                        data.languageCode);
                                    await appStore
                                        .setLanguage(data.languageCode!);
                                    setState(() {});
                                  })
                                ],
                              ).paddingSymmetric(horizontal: 20),
                            );
                          },
                          itemCount: localeLanguageList.length,
                        )),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: AppButton(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                color: primaryColor,
                child: Text(
                  language.btnNext,
                  style: boldTextStyle(color: white),
                ),
                onTap: () {
                  OurServicesScreen().launch(context,
                      pageRouteAnimation: PageRouteAnimation.Fade);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
