import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/screens/maintenance_mode_screen.dart';
import 'package:com.gogospider.booking/screens/select_language_screen.dart';
import 'package:com.gogospider.booking/utils/configs.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
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
          SelectLanguageScreen().launch(context,
              isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
          // WalkThroughScreen().launch(context,
          //     isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            appStore.isDarkMode ? splash_background : splash_light_background,
            height: context.height(),
            width: context.width(),
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(appLogo, height: 120, width: 120),
              32.height,
              Text(APP_NAME, style: boldTextStyle(size: 26)),
            ],
          ),
        ],
      ),
    );
  }
}
