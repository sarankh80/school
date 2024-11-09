import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:com.gogospider.booking/component/ask_change_location_dialog.dart';
import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/screens/auth/sign_in_screen.dart';
import 'package:com.gogospider.booking/screens/booking/booking_detail_screen.dart';
import 'package:com.gogospider.booking/screens/cart/cart_screen.dart';
import 'package:com.gogospider.booking/screens/cart/count.dart';
import 'package:com.gogospider.booking/screens/category/category_screen.dart';
import 'package:com.gogospider.booking/screens/dashboard/fragment/booking_fragment.dart';
import 'package:com.gogospider.booking/screens/dashboard/fragment/dashboard_fragment.dart';
import 'package:com.gogospider.booking/screens/dashboard/fragment/profile_fragment.dart';
import 'package:com.gogospider.booking/screens/service/service_detail_screen.dart';
import 'package:com.gogospider.booking/services/location_service.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/permissions.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class DashboardScreen extends StatefulWidget {
  final bool? redirectToBooking;
  final bool? redirectToCart;

  DashboardScreen({this.redirectToBooking, this.redirectToCart});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  int currentIndex = 0;
  Stopwatch watch = Stopwatch();
  late Timer timer;
  bool startStop = true;
  int counterInactiveTime = 0;
  DBHelper? dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    init();
  }

  void init() async {
    // if (appStore.isAlertChooseLocation == true) {
    //   log("afterupdate : ${appStore.isCustomeLocation}");
    //   showBottomSheetChooseLocation(context, firstTimeShow: true);
    // }
    if (widget.redirectToBooking.validate(value: false)) {
      currentIndex = 1;
      setState(() {});
    }
    if (widget.redirectToCart.validate(value: false)) {
      currentIndex = 3;
      setState(() {});
    }
    afterBuildCreated(() async {
      log("isMobile $isMobile");
      // Handle Notification click and redirect to that Service & BookDetail screen
      if (isMobile) {
        OneSignal.shared.setNotificationOpenedHandler(
            (OSNotificationOpenedResult notification) async {
          if (notification.notification.additionalData!.containsKey('id')) {
            int? notId = notification.notification.additionalData!["id"];
            if (notId != null) {
              BookingDetailScreen(bookingId: notId.toString().toInt())
                  .launch(context);
            }
          } else if (notification.notification.additionalData!
              .containsKey('service_id')) {
            String? notId =
                notification.notification.additionalData!["service_id"];
            if (notId.validate().isNotEmpty) {
              ServiceDetailScreen(serviceId: notId.toInt()).launch(context);
            }
          }
        });
      }

      // Changes System theme when changed
      if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
      }
      window.onPlatformBrightnessChanged = () async {
        if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
          appStore
              .setDarkMode(context.platformBrightness() == Brightness.light);
        }
      };

      await 3.seconds.delay;
      showForceUpdateDialog(context);
    });
  }

  startWatch() {
    setState(() {
      startStop = false;
      watch.start();
      timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
      log("Current index $currentIndex");
    });
  }

  stopWatch() {
    setState(() {
      startStop = true;
      watch.stop();
      print("startstop Inside=$startStop");
    });
  }

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        print("uuuuuu Inside=$startStop");
        int milliseconds = watch.elapsedMilliseconds;
        int hundreds = (milliseconds / 10).truncate();
        int seconds = (hundreds / 100).truncate();
        int minutes = (seconds / 60).truncate();
        counterInactiveTime = minutes;
        if (minutes > 2) {
          stopWatch();
        }
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        stopWatch();
        if (counterInactiveTime >= 2) {
          // appStore.isAlertChooseLocation = true;
          if (currentIndex != 1) {
            if (getDoubleAsync(LATITUDE) == 0.0 ||
                getDoubleAsync(LATITUDE).toString() == "") {
              log("Current Late ${getBoolAsync(PERMISSION_STATUS)}");
              await LocationPermissions.locationPermissionsGranted()
                  .then((value) async {
                if (value) {
                  await setValue(PERMISSION_STATUS, value);
                  await getUserLocation(setLatLong: true).then((value) async {
                    await appStore
                        .setCurrentLocation(true)
                        .then((value) async {});
                  }).catchError((e) {
                    toast(language.somethingWentWrong);
                  });
                  // InfoLocationScreen().launch(context);
                }
              }).catchError((e) async {
                await getUserLocation(setLatLong: true).then((value) async {
                  await appStore
                      .setCurrentLocation(true)
                      .then((value) async {});
                }).catchError((e) {
                  toast(language.somethingWentWrong);
                });
                toast(language.somethingWentWrong, print: true);
              });
            }
            showBottomSheetChooseLocation(context);
          }

          setState(() {});
        }

        break;
      case AppLifecycleState.inactive:
        log("app in inactive");
        startWatch();
        break;
      case AppLifecycleState.paused:
        log("app in paused");
        startWatch();
        break;
      case AppLifecycleState.detached:
        log("app in detached");
        break;
    }

    /* if (isBackground) {
      // service.stop();
    } else {
      // service.start();
    }*/
  }

  Future<void> showBottomSheetChooseLocation(BuildContext context,
      {firstTimeShow = false}) async {
    appStore.isLoading = true;
    await getSavedAddress().then((value) async {
      counterInactiveTime = 0;
      appStore.isLoading = false;
      if (appStore.isCustomeLocation == true) {
        int selectedAddressId = getIntAsync(SELECTED_ADDRESS);
        if (value.data!
            .where((element) => element.id == selectedAddressId)
            .isNotEmpty) {
          value.data!
              .where((element) => element.id == selectedAddressId)
              .first
              .isSelected = true;
        } else {
          appStore.isCurrentLocation = true;
          appStore.isCustomeLocation = false;
        }
        setState(() {});
      }
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius:
                radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
        builder: (_) {
          return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: SafeArea(
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      // decoration: boxDecorationWithRoundedCorners(
                      //     borderRadius: radius(20),
                      //     backgroundColor: context.cardColor),
                      // padding: EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          DraggableScrollableSheet(
                              initialChildSize: 0.50,
                              minChildSize: 0.50,
                              maxChildSize: 1,
                              builder: (context, scrollController) {
                                return Stack(children: [
                                  Container(
                                      height: MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.70,
                                      decoration:
                                          boxDecorationWithRoundedCorners(
                                              borderRadius: radius(20),
                                              backgroundColor:
                                                  context.cardColor),
                                      padding: EdgeInsets.only(
                                          top: 30,
                                          left: 16,
                                          right: 16,
                                          bottom: 16),
                                      child: AskChangeLocationDialog(
                                          addreses: value,
                                          onSelectLocation: (lat, long, address,
                                              seletedId, isCurrentLocation) {
                                            setValue(
                                                TEMP_CURRENT_ADDRESS, address);
                                            setValue(
                                                TEMP_LATITUDE,
                                                double.parse(
                                                    lat.toStringAsFixed(4)));
                                            setValue(
                                                TEMP_LONGITUDE,
                                                double.parse(
                                                    long.toStringAsFixed(4)));
                                            setValue(TEMP_SELECTED_ADDRESS,
                                                seletedId);
                                            setValue(TEMP_IS_CURRENT_LOCATION,
                                                isCurrentLocation);
                                            setState(() {});
                                          }))
                                ]);
                              }),
                          Positioned(
                              top: MediaQuery.of(context).size.height * 0.41,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CachedImageWidget(
                                      url: ic_spider_handyman,
                                      height: 100,
                                    ),
                                    CachedImageWidget(
                                      url: ic_road_line,
                                      height: 150,
                                      // width: 160,
                                    ),
                                    Column(
                                      children: [
                                        Platform.isIOS ? 20.height : 22.height,
                                        CachedImageWidget(
                                          url: ic_map_pin,
                                          height: 60,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )),
                          Positioned(
                            bottom: 10,
                            left: 16,
                            right: 16,
                            child: Observer(
                                builder: (context) => appStore.isLoading
                                    ? AppButton(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        text: language.pleaseWait,
                                        margin: EdgeInsets.only(right: 10),
                                        color: primaryColor,
                                        textStyle: boldTextStyle(
                                            size: 15, color: Colors.white),
                                      )
                                    : AppButton(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        text: language.lbConfirm,
                                        margin: EdgeInsets.only(right: 10),
                                        color: primaryColor,
                                        textStyle: boldTextStyle(
                                            size: 15, color: Colors.white),
                                        onTap: () async {
                                          int cartItem =
                                              getIntAsync('cart_items');
                                          double currentTempLat =
                                              getDoubleAsync(TEMP_LATITUDE);
                                          double currentTempLong =
                                              getDoubleAsync(TEMP_LONGITUDE);

                                          double currentLate =
                                              getDoubleAsync(LATITUDE);
                                          double currentLong =
                                              getDoubleAsync(LONGITUDE);
                                          bool changeAddressClearCart =
                                              getBoolAsync(
                                                  CHANGE_ADDRESS_CLEAR_CART);

                                          if (firstTimeShow == true) {
                                            appStore
                                                .setAlertChooseLocation(false);
                                          }

                                          if (currentTempLat != currentLate &&
                                              currentTempLong != currentLong) {
                                            if (cartItem > 0) {
                                              if (changeAddressClearCart) {
                                                log("Change Address");
                                                showConfirmClearCart(context);
                                              } else {
                                                String currentTempAddress =
                                                    getStringAsync(
                                                        TEMP_CURRENT_ADDRESS);
                                                bool
                                                    currentTempIsCurrentLocation =
                                                    getBoolAsync(
                                                        TEMP_IS_CURRENT_LOCATION);
                                                int currentTempSelectedAddress =
                                                    getIntAsync(
                                                        TEMP_SELECTED_ADDRESS);

                                                setValue(CURRENT_ADDRESS,
                                                    currentTempAddress);
                                                setValue(
                                                    BOOKING_LATITUDE,
                                                    double.parse(currentTempLat
                                                        .toStringAsFixed(4)));
                                                setValue(
                                                    BOOKING_LONGITUDE,
                                                    double.parse(currentTempLong
                                                        .toStringAsFixed(4)));
                                                setValue(
                                                    LATITUDE,
                                                    double.parse(currentTempLat
                                                        .toStringAsFixed(4)));
                                                setValue(
                                                    LONGITUDE,
                                                    double.parse(currentTempLong
                                                        .toStringAsFixed(4)));
                                                if (currentTempSelectedAddress !=
                                                    0) {
                                                  setValue(SELECTED_ADDRESS,
                                                      currentTempSelectedAddress);
                                                  appStore.selectedAddressId =
                                                      currentTempSelectedAddress;
                                                }
                                                if (currentTempIsCurrentLocation ==
                                                    true) {
                                                  appStore
                                                      .setCurrentLocation(true);
                                                  appStore.setCustomeLocation(
                                                      false);
                                                } else {
                                                  appStore.setCurrentLocation(
                                                      false);
                                                  appStore
                                                      .setCustomeLocation(true);
                                                }
                                                if (currentTempLat == 0.0 &&
                                                    currentTempLong == 0.0) {
                                                  showConfirmDialogCustom(
                                                    context,
                                                    subTitle: language
                                                        .pleaseChooseOneAddress,
                                                    onAccept: (p0) {},
                                                  );
                                                } else {
                                                  // Navigator.of(context).pop();
                                                  DashboardScreen().launch(
                                                      context,
                                                      isNewTask: true);
                                                }
                                              }
                                            } else {
                                              String currentTempAddress =
                                                  getStringAsync(
                                                      TEMP_CURRENT_ADDRESS);
                                              bool
                                                  currentTempIsCurrentLocation =
                                                  getBoolAsync(
                                                      TEMP_IS_CURRENT_LOCATION);
                                              int currentTempSelectedAddress =
                                                  getIntAsync(
                                                      TEMP_SELECTED_ADDRESS);

                                              setValue(CURRENT_ADDRESS,
                                                  currentTempAddress);
                                              setValue(
                                                  BOOKING_LATITUDE,
                                                  double.parse(currentTempLat
                                                      .toStringAsFixed(4)));
                                              setValue(
                                                  BOOKING_LONGITUDE,
                                                  double.parse(currentTempLong
                                                      .toStringAsFixed(4)));
                                              setValue(
                                                  LATITUDE,
                                                  double.parse(currentTempLat
                                                      .toStringAsFixed(4)));
                                              setValue(
                                                  LONGITUDE,
                                                  double.parse(currentTempLong
                                                      .toStringAsFixed(4)));
                                              if (currentTempSelectedAddress !=
                                                  0) {
                                                setValue(SELECTED_ADDRESS,
                                                    currentTempSelectedAddress);
                                                appStore.selectedAddressId =
                                                    currentTempSelectedAddress;
                                              }
                                              if (currentTempIsCurrentLocation ==
                                                  true) {
                                                appStore
                                                    .setCurrentLocation(true);
                                                appStore
                                                    .setCustomeLocation(false);
                                              } else {
                                                appStore
                                                    .setCurrentLocation(false);
                                                appStore
                                                    .setCustomeLocation(true);
                                              }
                                              if (currentTempLat == 0.0 &&
                                                  currentTempLong == 0.0) {
                                                showConfirmDialogCustom(
                                                  context,
                                                  subTitle: language
                                                      .pleaseChooseOneAddress,
                                                  onAccept: (p0) {},
                                                );
                                              } else {
                                                // Navigator.of(context).pop();
                                                DashboardScreen().launch(
                                                    context,
                                                    isNewTask: true);
                                              }
                                            }
                                          } else {
                                            log(111);
                                            String currentTempAddress =
                                                getStringAsync(
                                                    TEMP_CURRENT_ADDRESS);
                                            bool currentTempIsCurrentLocation =
                                                getBoolAsync(
                                                    TEMP_IS_CURRENT_LOCATION);
                                            int currentTempSelectedAddress =
                                                getIntAsync(
                                                    TEMP_SELECTED_ADDRESS);

                                            setValue(CURRENT_ADDRESS,
                                                currentTempAddress);
                                            setValue(
                                                BOOKING_LATITUDE,
                                                double.parse(currentTempLat
                                                    .toStringAsFixed(4)));
                                            setValue(
                                                BOOKING_LONGITUDE,
                                                double.parse(currentTempLong
                                                    .toStringAsFixed(4)));
                                            setValue(
                                                LATITUDE,
                                                double.parse(currentTempLat
                                                    .toStringAsFixed(4)));
                                            setValue(
                                                LONGITUDE,
                                                double.parse(currentTempLong
                                                    .toStringAsFixed(4)));
                                            if (currentTempSelectedAddress !=
                                                0) {
                                              setValue(SELECTED_ADDRESS,
                                                  currentTempSelectedAddress);
                                              appStore.selectedAddressId =
                                                  currentTempSelectedAddress;
                                            }
                                            if (currentTempIsCurrentLocation ==
                                                true) {
                                              appStore.setCurrentLocation(true);
                                              appStore
                                                  .setCustomeLocation(false);
                                            } else {
                                              appStore
                                                  .setCurrentLocation(false);
                                              appStore.setCustomeLocation(true);
                                            }

                                            if (currentTempLat == 0.0 &&
                                                currentTempLong == 0.0) {
                                              showConfirmDialogCustom(
                                                context,
                                                subTitle: language
                                                    .pleaseChooseOneAddress,
                                                onAccept: (p0) {},
                                              );
                                            } else {
                                              if (getDoubleAsync(LATITUDE) ==
                                                      0.0 ||
                                                  getDoubleAsync(LATITUDE)
                                                          .toString() ==
                                                      "") {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          language
                                                              .lblCofirmation,
                                                          style: boldTextStyle(
                                                              size: 16),
                                                        ),
                                                        content: Text(language
                                                            .pleaseChooseOneAddress),
                                                        actions: <Widget>[
                                                          AppButton(
                                                            text:
                                                                language.lblOk,
                                                            textColor:
                                                                Colors.white,
                                                            color: primaryColor,
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              } else {
                                                if (currentIndex == 0) {
                                                  DashboardScreen().launch(
                                                      context,
                                                      isNewTask: true);
                                                } else {
                                                  Navigator.of(context).pop();
                                                }
                                              }
                                            }
                                          }
                                        },
                                      )),
                          )
                        ],
                      ))));
        },
      );
    });
  }

  showConfirmClearCart(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              language.lblCofirmation,
              style: boldTextStyle(size: 16),
            ),
            content: Text(language.changeAddressContainItemInCartAlert),
            actions: <Widget>[
              AppButton(
                text: language.lblNo,
                textColor: Colors.white,
                color: warningColor,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              AppButton(
                text: language.lblOk,
                textColor: Colors.white,
                color: primaryColor,
                onTap: () {
                  appStore.setLoading(true);
                  double currentTempLat = getDoubleAsync(TEMP_LATITUDE);
                  double currentTempLong = getDoubleAsync(TEMP_LONGITUDE);
                  int currentTempSelectedAddress =
                      getIntAsync(TEMP_SELECTED_ADDRESS);
                  String currentTempAddress =
                      getStringAsync(TEMP_CURRENT_ADDRESS);

                  bool currentTempIsCurrentLocation =
                      getBoolAsync(TEMP_IS_CURRENT_LOCATION);

                  setValue(CURRENT_ADDRESS, currentTempAddress);
                  setValue(BOOKING_LATITUDE, currentTempLat);
                  setValue(BOOKING_LONGITUDE, currentTempLong);
                  setValue(LATITUDE, currentTempLat);
                  setValue(LONGITUDE, currentTempLong);
                  setValue(SELECTED_ADDRESS, currentTempSelectedAddress);
                  // appStore.selectedAddressId = currentTempSelectedAddress;
                  if (currentTempIsCurrentLocation == true) {
                    appStore.setCurrentLocation(true);
                    appStore.setCustomeLocation(false);
                  } else {
                    appStore.setCurrentLocation(false);
                    appStore.setCustomeLocation(true);
                  }

                  setValue('cart_items', 0);
                  setValue('item_quantity', 0);
                  setValue('total_price', 0.0);
                  setValue('isButtonEnabled', false);
                  setValue(BOOKING_INFO, "");
                  Navigator.of(context).pop();
                  dbHelper!.deleteAllCartItem().then((value) {
                    appStore.setLoading(false);
                    DashboardScreen().launch(context, isNewTask: true);
                  });
                  appStore.setLoading(false);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      message: language.lblBackPressMsg,
      child: Scaffold(
        body: [
          Observer(
              builder: (context) => appStore.isLoggedIn
                  ? DashboardFragment()
                  : SignInScreen(isFromDashboard: true)),
          Observer(
              builder: (context) => appStore.isLoggedIn
                  ? BookingFragment()
                  : SignInScreen(isFromDashboard: true)),
          Observer(
              builder: (context) => appStore.isLoggedIn
                  ? CategoryScreen()
                  : SignInScreen(isFromDashboard: true)),
          Observer(
              builder: (context) => appStore.isLoggedIn
                  ? CartScreen()
                  // ? UserChatListScreen()
                  : SignInScreen(isFromDashboard: true)),
          Observer(
              builder: (context) => appStore.isLoggedIn
                  ? ProfileFragment()
                  : SignInScreen(isFromDashboard: true)),
        ][currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: ic_home.iconImage(color: appTextSecondaryColor),
              activeIcon: ic_home.iconImage(color: primaryColor),
              label: language.dashboard,
            ),
            BottomNavigationBarItem(
              icon: ic_ticket.iconImage(color: appTextSecondaryColor),
              activeIcon: ic_ticket.iconImage(color: primaryColor),
              label: language.history,
            ),
            BottomNavigationBarItem(
              icon: ic_category.iconImage(color: appTextSecondaryColor),
              activeIcon: ic_category.iconImage(color: primaryColor),
              label: language.category,
            ),
            BottomNavigationBarItem(
              icon: Count(color: appTextSecondaryColor),
              activeIcon: Count(color: primaryColor),
              label: language.lblcart,
            ),
            BottomNavigationBarItem(
              icon: ic_profile2.iconImage(color: appTextSecondaryColor),
              activeIcon: ic_profile2.iconImage(color: primaryColor),
              label: language.profile,
            ),
          ],
          onTap: (index) {
            currentIndex = index;
            setState(() {});
          },
          type: BottomNavigationBarType.fixed,
        ),
        // NavigationBar(
        //   selectedIndex: currentIndex,
        //   height: 60,
        //   destinations: [
        //     NavigationDestination(
        //       icon: ic_home.iconImage(color: appTextSecondaryColor),
        //       selectedIcon: ic_home.iconImage(color: white),
        //       label: language.dashboard,
        //     ),
        //     NavigationDestination(
        //       icon: ic_ticket.iconImage(color: appTextSecondaryColor),
        //       selectedIcon: ic_ticket.iconImage(color: white),
        //       label: language.booking,
        //     ),
        //     NavigationDestination(
        //       icon: ic_category.iconImage(color: appTextSecondaryColor),
        //       selectedIcon: ic_category.iconImage(color: white),
        //       label: language.category,
        //     ),
        //     NavigationDestination(
        //       icon: Count(color: appTextSecondaryColor),
        //       selectedIcon: Count(color: Colors.white),
        //       label: language.lblcart,
        //     ),
        //     NavigationDestination(
        //       icon: ic_profile2.iconImage(color: appTextSecondaryColor),
        //       selectedIcon: ic_profile2.iconImage(color: white),
        //       label: language.profile,
        //     ),
        //   ],
        //   onDestinationSelected: (index) {
        //     currentIndex = index;
        //     setState(() {});
        //   },
        // ),
      ),
    );
  }
}
