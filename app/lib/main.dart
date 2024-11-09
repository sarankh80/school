import 'package:com.gogospider.booking/app_theme.dart';
import 'package:com.gogospider.booking/locale/app_localizations.dart';
import 'package:com.gogospider.booking/locale/languages.dart';
import 'package:com.gogospider.booking/locale/languages_km.dart';
import 'package:com.gogospider.booking/model/material_you_model.dart';
import 'package:com.gogospider.booking/model/remote_config_data_model.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/booking/booking_detail_screen.dart';
import 'package:com.gogospider.booking/screens/splash_screen.dart';
import 'package:com.gogospider.booking/services/auth_services.dart';
import 'package:com.gogospider.booking/services/chat_messages_service.dart';
import 'package:com.gogospider.booking/services/notification_service.dart';
import 'package:com.gogospider.booking/services/user_services.dart';
import 'package:com.gogospider.booking/store/app_store.dart';
import 'package:com.gogospider.booking/store/filter_store.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/configs.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

AppStore appStore = AppStore();
FilterStore filterStore = FilterStore();
BaseLanguage language = LanguageKm();

UserService userService = UserService();
AuthServices authService = AuthServices();
ChatMessageService chatMessageService = ChatMessageService();
NotificationService notificationService = NotificationService();

RemoteConfigDataModel remoteConfigDataModel = RemoteConfigDataModel();

String currentPackageName = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  passwordLengthGlobal = 6;
  appButtonBackgroundColorGlobal = primaryColor;
  defaultAppButtonTextColorGlobal = Colors.white;
  defaultRadius = 12;
  defaultBlurRadius = 0;
  defaultSpreadRadius = 0;
  textSecondaryColorGlobal = appTextPrimaryColor;
  textPrimaryColorGlobal = appTextSecondaryColor;
  defaultAppButtonElevation = 0;
  pageRouteTransitionDurationGlobal = 400.milliseconds;

  await initialize();
  localeLanguageList = languageList();

  Stripe.publishableKey = STRIPE_PAYMENT_PUBLISH_KEY;
  if (!isDesktop) {
    Firebase.initializeApp().then((value) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      setupFirebaseRemoteConfig();
    }).catchError((e) {
      log(e.toString());
    });
  }

  await appStore.setLanguage(
      getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE));
  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN), isInitializing: true);

  int themeModeIndex = getIntAsync(THEME_MODE_INDEX);
  if (themeModeIndex == THEME_MODE_LIGHT) {
    appStore.setDarkMode(false);
  } else if (themeModeIndex == THEME_MODE_DARK) {
    appStore.setDarkMode(true);
  }

  // OneSignal.shared.setAppId(ONESIGNAL_APP_ID).then((value) {
  //   OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
  //     log("OneSignal: permission changed: $changes");
  //   });
  //   OneSignal.shared.setNotificationWillShowInForegroundHandler(
  //       (OSNotificationReceivedEvent event) {
  //     event.complete(event.notification);
  //   });

  //   OneSignal.shared.consentGranted(true);
  //   OneSignal.shared.promptUserForPushNotificationPermission();
  //   OneSignal.shared.sendTag(ONESIGNAL_TAG_KEY, ONESIGNAL_TAG_VALUE);

  //   saveOneSignalPlayerId();
  // });

  await appStore.setUseMaterialYouTheme(getBoolAsync(USE_MATERIAL_YOU_THEME),
      isInitializing: true);
  log("Main App :${getStringAsync(UID)}");

  if (appStore.isLoggedIn) {
    await appStore.setUserId(getIntAsync(USER_ID), isInitializing: true);
    await appStore.setFirstName(getStringAsync(FIRST_NAME),
        isInitializing: true);
    await appStore.setLastName(getStringAsync(LAST_NAME), isInitializing: true);
    await appStore.setUserEmail(getStringAsync(USER_EMAIL),
        isInitializing: true);
    await appStore.setUserName(getStringAsync(USERNAME), isInitializing: true);
    await appStore.setContactNumber(getStringAsync(CONTACT_NUMBER),
        isInitializing: true);
    await appStore.setUserProfile(getStringAsync(PROFILE_IMAGE),
        isInitializing: true);
    await appStore.setCountryId(getIntAsync(COUNTRY_ID), isInitializing: true);
    await appStore.setStateId(getIntAsync(STATE_ID), isInitializing: true);
    await appStore.setCityId(getIntAsync(COUNTRY_ID), isInitializing: true);
    await appStore.setUId(getStringAsync(UID), isInitializing: true);
    await appStore.setToken(getStringAsync(TOKEN), isInitializing: true);
    await appStore.setAddress(getStringAsync(ADDRESS), isInitializing: true);
    await appStore.setCurrencyCode(getStringAsync(CURRENCY_COUNTRY_CODE),
        isInitializing: true);
    await appStore.setCurrencyCountryId(getStringAsync(CURRENCY_COUNTRY_ID),
        isInitializing: true);
    await appStore.setCurrencySymbol(getStringAsync(CURRENCY_COUNTRY_SYMBOL),
        isInitializing: true);
    await appStore.setPrivacyPolicy(getStringAsync(PRIVACY_POLICY),
        isInitializing: true);
    await appStore.setLoginType(getStringAsync(LOGIN_TYPE),
        isInitializing: true);
    await appStore.setTermConditions(getStringAsync(TERM_CONDITIONS),
        isInitializing: true);
    await appStore.setInquiryEmail(getStringAsync(INQUIRY_EMAIL),
        isInitializing: true);
    await appStore.setHelplineNumber(getStringAsync(HELPLINE_NUMBER),
        isInitializing: true);

    await appStore.setCurrentLocation(getBoolAsync(IS_CURRENT_LOCATION),
        isInitializing: true);
    await appStore.setCustomeLocation(getBoolAsync(IS_CUSTOME_LOCATION),
        isInitializing: true);
  }
  setOneSignal();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    log("Token ${appStore.token}");
    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult notification) {
      log("Notification Error ${notification.notification.additionalData}");
      try {
        appStore.isAlertChooseLocation = false;
        var notId = notification.notification.additionalData!.containsKey('id')
            ? notification.notification.additionalData!['id']
            : 0;
        BookingDetailScreen(bookingId: notId.toString().toInt())
            .launch(context);
      } catch (e) {
        log("Notification Error ${e.toString()}");
        throw errorSomethingWentWrong;
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RestartAppWidget(
        child: ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Observer(
        builder: (_) => FutureBuilder<Color>(
          future: getMaterialYouData(),
          builder: (_, snap) {
            return Observer(
              builder: (_) => MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                home: SplashScreen(),
                theme: AppTheme.lightTheme(
                    color: snap.data, language: appStore.selectedLanguageCode),
                darkTheme: AppTheme.darkTheme(
                    color: snap.data, language: appStore.selectedLanguageCode),
                themeMode:
                    appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                title: APP_NAME,
                supportedLocales: LanguageDataModel.languageLocales(),
                localizationsDelegates: [
                  AppLocalizations(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) => locale,
                locale: Locale(appStore.selectedLanguageCode),
              ),
            );
          },
        ),
      ),
    ));
  }
}
