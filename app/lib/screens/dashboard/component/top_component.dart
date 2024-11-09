import 'package:com.gogospider.booking/component/ask_change_location_dialog.dart';
import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/screens/auth/sign_in_screen.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/screens/notification/notification_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class TopBarComponent extends StatefulWidget {
  final int? notificationReadCount;
  final VoidCallback? callback;
  final ScrollController scrollController = ScrollController();
  TopBarComponent({required this.notificationReadCount, this.callback});
  @override
  State<TopBarComponent> createState() => _TopBarComponentState();
}

class _TopBarComponentState extends State<TopBarComponent> {
  late final UserData handymanData;
  FocusNode myFocusNode = FocusNode();
  late List<SavedAddress> savedAddresses = [];
  Future<List<SavedAddress>>? future;
  int count = 0;
  DBHelper? dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    var strinAddress = getStringAsync(SAVED_ADDRESS);
    if (strinAddress != "") {
      savedAddresses = SavedAddress.decode(strinAddress);
    }
    // init();
  }

  // void init() async {
  //   count = await chatMessageService.getAllUnReadCount(senderId: appStore.uid);
  //   log("Count${count}");
  // }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          ic_servicesAddress.iconImage(size: 20, color: cardColor).center(),
      titleSpacing: 0,
      title: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          children: [
            Marquee(
                child: Text(
              getStringAsync(CURRENT_ADDRESS) != ""
                  ? getStringAsync(CURRENT_ADDRESS)
                  : language.lblSelectAddress,
              style: secondaryTextStyle(color: appBarBackgroundColorGlobal),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )).expand(),
          ],
        ),
      ).onTap(() async {
        await getSavedAddress().then((value) async {
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
            // barrierColor: Colors.transparent,
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
                          // padding: EdgeInsets.all(16),
                          child: Stack(children: [
                            DraggableScrollableSheet(
                              initialChildSize: 0.50,
                              minChildSize: 0.50,
                              maxChildSize: 1,
                              builder: (context, scrollController) =>
                                  Stack(children: [
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.70,
                                    decoration: boxDecorationWithRoundedCorners(
                                        borderRadius: radius(20),
                                        backgroundColor: context.cardColor),
                                    padding: EdgeInsets.only(
                                        top: 30,
                                        left: 16,
                                        right: 16,
                                        bottom: 16),
                                    child: AskChangeLocationDialog(
                                      showWelcomeBack: false,
                                      addreses: value,
                                      onSelectLocation: (lat, long, address,
                                          seletedId, isCurrentLocation) {
                                        setValue(TEMP_CURRENT_ADDRESS, address);
                                        setValue(
                                            TEMP_LATITUDE,
                                            double.parse(
                                                lat.toStringAsFixed(4)));
                                        setValue(
                                            TEMP_LONGITUDE,
                                            double.parse(
                                                long.toStringAsFixed(4)));
                                        setValue(
                                            TEMP_SELECTED_ADDRESS, seletedId);
                                        setValue(TEMP_IS_CURRENT_LOCATION,
                                            isCurrentLocation);
                                        setState(() {});
                                      },
                                    ))
                              ]),
                            ),
                            Positioned(
                                top: MediaQuery.of(context).size.height * 0.41,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                textStyle: boldTextStyle(
                                    size: 15, color: Colors.white),
                                onTap: () async {
                                  int cartItem = getIntAsync('cart_items');
                                  double currentTempLat =
                                      getDoubleAsync(TEMP_LATITUDE);
                                  double currentTempLong =
                                      getDoubleAsync(TEMP_LONGITUDE);
                                  double currentLate = getDoubleAsync(LATITUDE);
                                  double currentLong =
                                      getDoubleAsync(LONGITUDE);
                                  bool changeAddressClearCart =
                                      getBoolAsync(CHANGE_ADDRESS_CLEAR_CART);
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
                                        bool currentTempIsCurrentLocation =
                                            getBoolAsync(
                                                TEMP_IS_CURRENT_LOCATION);
                                        int currentTempSelectedAddress =
                                            getIntAsync(TEMP_SELECTED_ADDRESS);

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
                                        if (currentTempSelectedAddress != 0) {
                                          setValue(SELECTED_ADDRESS,
                                              currentTempSelectedAddress);
                                          // appStore.selectedAddressId =
                                          //     currentTempSelectedAddress;
                                        }
                                        appStore.isCurrentLocation =
                                            currentTempIsCurrentLocation;
                                        Navigator.of(context).pop();
                                        DashboardScreen()
                                            .launch(context, isNewTask: true);
                                      }
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
                                        // appStore.selectedAddressId =
                                        //     currentTempSelectedAddress;
                                      }
                                      appStore.isCurrentLocation =
                                          currentTempIsCurrentLocation;
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
                                      // appStore.selectedAddressId =
                                      //     currentTempSelectedAddress;
                                    }

                                    appStore.isCurrentLocation =
                                        currentTempIsCurrentLocation;
                                    DashboardScreen()
                                        .launch(context, isNewTask: true);
                                  }
                                },
                              ),
                            )
                          ]))));
            },
          );
        });
      }),
      actions: [
        // Container(
        //   decoration: boxDecorationDefault(
        //       color: context.cardColor, shape: BoxShape.circle),
        //   height: 36,
        //   padding: EdgeInsets.all(8),
        //   width: 36,
        //   child: Stack(
        //     clipBehavior: Clip.none,
        //     children: [
        //       ic_chat.iconImage(size: 20, color: primaryColor).center(),
        //       Positioned(
        //         top: -10,
        //         right: -10,
        //         child: widget.notificationReadCount.validate() > 0
        //             ? Container(
        //                 padding: EdgeInsets.all(4),
        //                 child: FittedBox(
        //                   child: Text(widget.notificationReadCount.toString(),
        //                       style: primaryTextStyle(
        //                           size: 12, color: Colors.white)),
        //                 ),
        //                 decoration: boxDecorationDefault(
        //                     color: Colors.red,
        //                     shape: BoxShape.circle,
        //                     border: Border.all(color: context.primaryColor)),
        //               )
        //             : Offstage(),
        //       )
        //     ],
        //   ),
        // ).onTap(() {
        //   appStore.isLoggedIn
        //       ? UserChatListScreen().launch(context)
        //       : SignInScreen().launch(context);
        // }),
        10.width,
        Container(
          // decoration: boxDecorationDefault(
          //     color: context.cardColor, shape: BoxShape.circle),
          height: 36,
          padding: EdgeInsets.all(8),
          width: 36,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ic_notification.iconImage(size: 20, color: Colors.white).center(),
              Observer(
                  builder: (context) => Positioned(
                        top: -10,
                        right: -10,
                        child: appStore.notificationCount > 0
                            ? Container(
                                padding: EdgeInsets.all(4),
                                child: FittedBox(
                                  child: Text(
                                      appStore.notificationCount.toString(),
                                      style: primaryTextStyle(
                                          size: 12, color: Colors.red)),
                                ),
                                decoration: boxDecorationDefault(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: context.primaryColor)),
                              )
                            : Offstage(),
                      ))
            ],
          ),
        ).onTap(() {
          appStore.isLoggedIn
              ? NotificationScreen().launch(context)
              : SignInScreen().launch(context);
        }),
        16.width,
      ],
      backgroundColor: Colors.red,
    );
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
                  setValue(BOOKING_LATITUDE,
                      double.parse(currentTempLat.toStringAsFixed(4)));
                  setValue(BOOKING_LONGITUDE,
                      double.parse(currentTempLong.toStringAsFixed(4)));
                  setValue(LATITUDE,
                      double.parse(currentTempLat.toStringAsFixed(4)));
                  setValue(LONGITUDE,
                      double.parse(currentTempLong.toStringAsFixed(4)));
                  setValue(SELECTED_ADDRESS, currentTempSelectedAddress);
                  // appStore.selectedAddressId = currentTempSelectedAddress;
                  appStore.isCurrentLocation = currentTempIsCurrentLocation;

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
