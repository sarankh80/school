import 'package:com.gogospider.booking/component/ask_change_location_dialog.dart';
import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/component/error_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/booking_data_model.dart';
import 'package:com.gogospider.booking/model/dashboard_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/dashboard/component/service_component.dart';
import 'package:com.gogospider.booking/screens/dashboard/component/menu_component.dart';
import 'package:com.gogospider.booking/screens/dashboard/component/products_component.dart';
import 'package:com.gogospider.booking/screens/dashboard/component/slider_and_location_component.dart';
import 'package:com.gogospider.booking/screens/dashboard/component/top_component.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/services/location_service.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class DashboardFragment extends StatefulWidget {
  @override
  _DashboardFragmentState createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  Future<DashboardResponse>? future;
  List<BookingInfo>? bookingInfo = [];
  CollectionReference? ref;
  DBHelper? dbHelper = DBHelper();

  String isError = '';

  @override
  void initState() {
    super.initState();
    init();

    setStatusBarColor(
      transparentColor,
      delayInMilliSeconds: 1000,
    );

    LiveStream().on(LIVESTREAM_UPDATE_DASHBOARD, (p0) {
      setState(() {});
    });
  }

  void init() async {
    if (appStore.isAlertChooseLocation == true) {
      if (getDoubleAsync(LATITUDE) == 0.0 ||
          getDoubleAsync(LATITUDE).toString() == "") {
        log("Current Late ${getBoolAsync(PERMISSION_STATUS)}");
        await LocationPermissions.locationPermissionsGranted()
            .then((value) async {
          if (value) {
            await setValue(PERMISSION_STATUS, value);
            await getUserLocation(setLatLong: true).then((value) async {
              await appStore.setCurrentLocation(true).then((value) async {});
            }).catchError((e) {
              toast(language.somethingWentWrong);
            });
            // InfoLocationScreen().launch(context);
          }
        }).catchError((e) async {
          await getUserLocation(setLatLong: true).then((value) async {
            await appStore.setCurrentLocation(true).then((value) async {});
          }).catchError((e) {
            toast(language.somethingWentWrong);
          });
          toast(language.somethingWentWrong, print: true);
        });
      }
      showBottomSheetChooseLocation(context, firstTimeShow: true);
    }
    future = userDashboard(
        isCurrentLocation: !appStore.isCurrentLocation,
        lat: getDoubleAsync(bookingInfo!.isNotEmpty
            ? bookingInfo![0].latitude.toString()
            : LATITUDE),
        long: getDoubleAsync(bookingInfo!.isNotEmpty
            ? bookingInfo![0].latitude.toString()
            : LONGITUDE));
    log("UUID : ${appStore.uid}");
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(LIVESTREAM_UPDATE_DASHBOARD);
  }

  @override
  Widget build(BuildContext context) {
    context.read<CartProvider>().getData();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          init();
          setState(() {});
          return await 2.seconds.delay;
        },
        child: Stack(
          children: [
            FutureBuilder<DashboardResponse>(
              future: future,
              builder: (context, snap) {
                if (snap.hasError || isError != '') {
                  return Center(
                      child: ErrorsWidget(
                    errortext: isError != '' ? isError : snap.error.toString(),
                    onPressed: () async {
                      init();
                      setState(() {});
                      return await 2.seconds.delay;
                    },
                  ));
                }
                if (snap.hasData) {
                  appStore.isLoading = false;
                  appStore.setNotificationCount(
                      snap.data!.notificationUnreadCount.validate());
                  return AnimatedScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    listAnimationType: ListAnimationType.FadeIn,
                    children: [
                      TopBarComponent(
                        notificationReadCount: appStore.notificationCount,
                        callback: () async {
                          init();
                          await 300.milliseconds.delay;
                          setState(() {});
                        },
                      ),
                      SliderLocationComponent(
                        sliderList: snap.data!.slider.validate(),
                        notificationReadCount: appStore.notificationCount,
                        callback: () async {
                          init();
                          await 300.milliseconds.delay;
                          setState(() {});
                        },
                      ),
                      10.height,
                      MenuComponent(
                          categoryList: snap.data!.categories.validate()),
                      10.height,
                      // MenuComponent(
                      //     categoryList: snap.data!.categories.validate(),
                      //     id: 2),
                      // 10.height,
                      // MenuComponent(
                      //     categoryList: snap.data!.categories.validate(),
                      //     id: 1),
                      // 10.height,
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 218, 215, 215),
                        ),
                      ),
                      SericesComponent(
                          serviceList: snap.data!.discountService.validate(),
                          categoryList: snap.data!.categories.validate()),
                      10.height,
                      ProductsComponent(
                          serviceList: snap.data!.discountProducts.validate(),
                          categoryList: snap.data!.categories.validate()),
                      10.height,

                      // RepairComponent(
                      //     serviceList: snap.data!.service.validate()),
                      // 10.height,
                      // InstallationComponent(
                      //     serviceList: snap.data!.service.validate()),
                      // 10.height,
                      // CategoryComponent(
                      //     categoryList: snap.data!.category.validate()),
                      // 24.height,
                      // FeaturedServiceListComponent(
                      //     serviceList: snap.data!.featuredServices.validate()),
                      // ServiceListComponent(
                      //     serviceList: snap.data!.service.validate()),
                      // 16.height,
                      // CustomerRatingsComponent(
                      //     reviewData:
                      //         snap.data!.dashboardCustomerReview.validate()),
                    ],
                  );
                }
                return snapWidgetHelper(snap, loadingWidget: Offstage());
              },
            ),
            Observer(
                builder: (context) =>
                    LoaderWidget().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }

  Future<void> showBottomSheetChooseLocation(BuildContext context,
      {firstTimeShow = false}) async {
    appStore.isLoading = true;
    await getSavedAddress().then((value) async {
      appStore.isLoading = false;
      if (appStore.isCustomeLocation == true) {
        if (value.data!
            .where((element) =>
                element.late == getDoubleAsync(LATITUDE) &&
                element.lang == getDoubleAsync(LONGITUDE))
            .isNotEmpty) {
          value.data!
              .where((element) =>
                  element.late == getDoubleAsync(LATITUDE) &&
                  element.lang == getDoubleAsync(LONGITUDE))
              .first
              .isSelected = true;
          setState(() {});
        }
      }
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        // barrierColor: Colors.transparent.withOpacity(0),
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius: radiusOnly(topLeft: 0, topRight: 0)),
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
                                return Stack(
                                  children: [
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
                                            showWelcomeBack: false,
                                            addreses: value,
                                            onSelectLocation: (lat,
                                                long,
                                                address,
                                                seletedId,
                                                isCurrentLocation) {
                                              setValue(TEMP_CURRENT_ADDRESS,
                                                  address);
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
                                  ],
                                );
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
                                        22.height,
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
                            child: AppButton(
                              width: MediaQuery.of(context).size.width,
                              text: language.lbConfirm,
                              margin: EdgeInsets.only(right: 10),
                              color: primaryColor,
                              textStyle:
                                  boldTextStyle(size: 15, color: Colors.white),
                              onTap: () async {
                                int cartItem = getIntAsync('cart_items');
                                double currentTempLat =
                                    getDoubleAsync(TEMP_LATITUDE);
                                double currentTempLong =
                                    getDoubleAsync(TEMP_LONGITUDE);

                                double currentLate = getDoubleAsync(LATITUDE);
                                double currentLong = getDoubleAsync(LONGITUDE);
                                // bool currentTempIsCurrentLocation =
                                //     getBoolAsync(TEMP_IS_CURRENT_LOCATION);
                                bool changeAddressClearCart =
                                    getBoolAsync(CHANGE_ADDRESS_CLEAR_CART);

                                if (firstTimeShow = true) {
                                  appStore.setAlertChooseLocation(false);
                                }

                                if (currentTempLat != currentLate &&
                                    currentTempLong != currentLong) {
                                  if (cartItem > 0) {
                                    if (changeAddressClearCart) {
                                      showConfirmClearCart(context);
                                    } else {
                                      String currentTempAddress =
                                          getStringAsync(TEMP_CURRENT_ADDRESS);
                                      bool currentTempIsCurrentLocation =
                                          getBoolAsync(
                                              TEMP_IS_CURRENT_LOCATION);
                                      int currentTempSelectedAddress =
                                          getIntAsync(TEMP_SELECTED_ADDRESS);

                                      setValue(
                                          CURRENT_ADDRESS, currentTempAddress);
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
                                      if (currentTempSelectedAddress != 0) {
                                        setValue(SELECTED_ADDRESS,
                                            currentTempSelectedAddress);
                                        appStore.selectedAddressId =
                                            currentTempSelectedAddress;
                                      }
                                      if (currentTempIsCurrentLocation ==
                                          true) {
                                        appStore.setCurrentLocation(true);
                                        appStore.setCustomeLocation(false);
                                      } else {
                                        appStore.setCurrentLocation(false);
                                        appStore.setCustomeLocation(true);
                                      }
                                      if (currentTempLat == 0.0 &&
                                          currentTempLong == 0.0) {
                                        showConfirmDialogCustom(
                                          context,
                                          subTitle:
                                              language.pleaseChooseOneAddress,
                                          onAccept: (p0) {},
                                        );
                                      } else {
                                        Navigator.of(context).pop();
                                        DashboardScreen()
                                            .launch(context, isNewTask: true);
                                      }
                                    }
                                  } else {
                                    String currentTempAddress =
                                        getStringAsync(TEMP_CURRENT_ADDRESS);
                                    bool currentTempIsCurrentLocation =
                                        getBoolAsync(TEMP_IS_CURRENT_LOCATION);
                                    int currentTempSelectedAddress =
                                        getIntAsync(TEMP_SELECTED_ADDRESS);

                                    setValue(
                                        CURRENT_ADDRESS, currentTempAddress);
                                    setValue(
                                        BOOKING_LATITUDE,
                                        double.parse(
                                            currentTempLat.toStringAsFixed(4)));
                                    setValue(
                                        BOOKING_LONGITUDE,
                                        double.parse(currentTempLong
                                            .toStringAsFixed(4)));
                                    setValue(
                                        LATITUDE,
                                        double.parse(
                                            currentTempLat.toStringAsFixed(4)));
                                    setValue(
                                        LONGITUDE,
                                        double.parse(currentTempLong
                                            .toStringAsFixed(4)));
                                    if (currentTempSelectedAddress != 0) {
                                      setValue(SELECTED_ADDRESS,
                                          currentTempSelectedAddress);
                                      appStore.selectedAddressId =
                                          currentTempSelectedAddress;
                                    }
                                    if (currentTempIsCurrentLocation == true) {
                                      appStore.setCurrentLocation(true);
                                      appStore.setCustomeLocation(false);
                                    } else {
                                      appStore.setCurrentLocation(false);
                                      appStore.setCustomeLocation(true);
                                    }
                                    setState(() {});
                                    Navigator.of(context).pop();
                                    DashboardScreen()
                                        .launch(context, isNewTask: true);
                                  }
                                } else {
                                  String currentTempAddress =
                                      getStringAsync(TEMP_CURRENT_ADDRESS);
                                  bool currentTempIsCurrentLocation =
                                      getBoolAsync(TEMP_IS_CURRENT_LOCATION);
                                  int currentTempSelectedAddress =
                                      getIntAsync(TEMP_SELECTED_ADDRESS);

                                  setValue(CURRENT_ADDRESS, currentTempAddress);
                                  setValue(
                                      BOOKING_LATITUDE,
                                      double.parse(
                                          currentTempLat.toStringAsFixed(4)));
                                  setValue(
                                      BOOKING_LONGITUDE,
                                      double.parse(
                                          currentTempLong.toStringAsFixed(4)));
                                  setValue(
                                      LATITUDE,
                                      double.parse(
                                          currentTempLat.toStringAsFixed(4)));
                                  setValue(
                                      LONGITUDE,
                                      double.parse(
                                          currentTempLong.toStringAsFixed(4)));
                                  if (currentTempSelectedAddress != 0) {
                                    setValue(SELECTED_ADDRESS,
                                        currentTempSelectedAddress);
                                    appStore.selectedAddressId =
                                        currentTempSelectedAddress;
                                  }
                                  if (currentTempIsCurrentLocation == true) {
                                    appStore.setCurrentLocation(true);
                                    appStore.setCustomeLocation(false);
                                  } else {
                                    appStore.setCurrentLocation(false);
                                    appStore.setCustomeLocation(true);
                                  }
                                  setState(() {});

                                  if (getDoubleAsync(LATITUDE) == 0.0 ||
                                      getDoubleAsync(LATITUDE).toString() ==
                                          "") {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              language.lblCofirmation,
                                              style: boldTextStyle(size: 16),
                                            ),
                                            content: Text(language
                                                .pleaseChooseOneAddress),
                                            actions: <Widget>[
                                              AppButton(
                                                text: language.lblOk,
                                                textColor: Colors.white,
                                                color: primaryColor,
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  } else {
                                    Navigator.of(context).pop();
                                    DashboardScreen()
                                        .launch(context, isNewTask: true);
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ))));
        },
      );
    }).onError((error, stackTrace) {
      appStore.isLoading = false;
      isError = error.toString();
      setState(() {});
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
}
