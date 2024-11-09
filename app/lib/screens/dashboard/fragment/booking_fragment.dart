import 'package:com.gogospider.booking/component/ask_change_location_dialog.dart';
import 'package:com.gogospider.booking/component/background_component.dart';
import 'package:com.gogospider.booking/component/error_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/booking_data_model.dart';
// import 'package:com.gogospider.booking/model/booking_status_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/booking/booking_detail_screen.dart';
import 'package:com.gogospider.booking/screens/booking/component/booking_item_component.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
// import 'package:com.gogospider.booking/screens/booking/component/status_dropdown_component.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

// import 'package:com.gogospider.booking/screens/filter/filter_screen.dart';

import '../../../component/cached_image_widget.dart';
import '../../../model/booking_status_model.dart';
import '../../../utils/common.dart';
import '../../../utils/images.dart';
import '../../booking/booking_status_component.dart';
// import '../../booking/component/status_dropdown_component.dart';

class BookingFragment extends StatefulWidget {
  @override
  _BookingFragmentState createState() => _BookingFragmentState();
}

class _BookingFragmentState extends State<BookingFragment> {
  FocusNode myFocusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  TextEditingController searchCont = TextEditingController();

  Future<List<BookingData>>? future;
  List<BookingData> bookings = [];

  int page = 1;
  bool isLastPage = false;
  bool isBookingTypeChanged = false;

  bool isRefresh = false;

  String selectedValue = BOOKING_TYPE_ALL;
  DBHelper? dbHelper = DBHelper();
  String? isError = "";

  @override
  void initState() {
    super.initState();
    init();

    afterBuildCreated(() {
      if (appStore.isLoggedIn) {
        setStatusBarColor(context.primaryColor);
      }
    });

    LiveStream().on(LIVESTREAM_UPDATE_BOOKING_LIST, (p0) {
      page = 1;
      init();
    });
    log("BookingUID :${appStore.uid}");
  }

  void init() async {
    // if (appStore.isAlertChooseLocation == true) {
    //   showBottomSheetChooseLocation(context, firstTimeShow: true);
    // }
    future = getBookingList(appStore.userId.validate(), page,
        status: selectedValue, bookings: bookings, lastPageCallback: (b) {
      isLastPage = b;
      log("last page $isLastPage");
      isRefresh = false;
      setState(() {});
    }).catchError((error) {
      // maybe do something here
      isRefresh = true;
      setState(() {});
      throw error;
    });
    isBookingTypeChanged = false;
  }

  String get setSearchString {
    // if (!widget.categoryName.isEmptyOrNull) {
    //   return widget.categoryName!;
    // } else if (widget.isFeatured == "1") {
    //   return language.lblFeatured;
    // } else {
    return language.enterYourBookingId;
    // }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(LIVESTREAM_UPDATE_BOOKING_LIST);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<CartProvider>().getData();
    return Scaffold(
      appBar: appBarWidget(
        language.booking,
        textColor: white,
        showBack: false,
        elevation: 3.0,
        color: context.primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          page = 1;
          init();

          setState(() {});
          return await 3.seconds.delay;
        },
        child: Stack(
          children: [
            SnapHelperWidget<List<BookingData>>(
              future: future,
              loadingWidget: LoaderWidget(),
              errorWidget: ErrorsWidget(
                errortext: language.connectionTimeOut,
                onPressed: () async {
                  isRefresh = true;
                  init();
                  setState(() {});
                  return await 10.seconds.delay;
                },
              ),
              onSuccess: (list) {
                if (list.isEmpty) {
                  return BackgroundComponent(
                    text: language.lblNoBookingsFound,
                  );
                }

                return AnimatedListView(
                  controller: scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  padding:
                      EdgeInsets.only(bottom: 60, top: 8, right: 16, left: 16),
                  itemCount: list.length,
                  shrinkWrap: true,
                  listAnimationType: ListAnimationType.Slide,
                  slideConfiguration: SlideConfiguration(verticalOffset: 400),
                  disposeScrollController: false,
                  itemBuilder: (_, index) {
                    BookingData? data = list[index];

                    return GestureDetector(
                      onTap: () {
                        BookingDetailScreen(bookingId: data.id.validate())
                            .launch(context);
                      },
                      child: BookingItemComponent(bookingData: data),
                    );
                  },
                  onNextPage: () {
                    if (!isLastPage) {
                      page++;
                      init();
                      setState(() {});
                    }
                  },
                ).paddingOnly(left: 0, right: 0, bottom: 0, top: 76);
              },
            ),
            // Positioned(
            //   left: 16,
            //   right: 16,
            //   top: 16,
            //   child: StatusDropdownComponent(
            //     isValidate: false,
            //     onValueChanged: (BookingStatusResponse value) {
            //       selectedValue = value.value.toString();
            //       isBookingTypeChanged = true;

            //       page = 1;
            //       init();

            //       setState(() {});

            //       if (bookings.isNotEmpty) {
            //         scrollController.animateTo(0,
            //             duration: 1.seconds, curve: Curves.easeOutQuart);
            //       }
            //     },
            //   ),
            // ),
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  AppTextField(
                    textFieldType: TextFieldType.OTHER,
                    focus: myFocusNode,
                    controller: searchCont,
                    suffix: CloseButton(
                      onPressed: () {
                        page = 1;
                        searchCont.clear();
                        filterStore.setSearch('');
                        // fetchAllServiceData();
                      },
                    ).visible(searchCont.text.isNotEmpty),
                    onFieldSubmitted: (s) {
                      page = 1;

                      filterStore.setSearch(s);
                      // fetchAllServiceData();
                    },
                    decoration: inputDecoration(context).copyWith(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      border: OutlineInputBorder(),
                      hintText: language.enterYourBookingId,
                      // prefixIcon: ic_search.iconImage(size: 10).paddingAll(14),
                      hintStyle: secondaryTextStyle(),
                    ),
                  ).expand(),
                  16.width,
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration:
                        boxDecorationDefault(color: context.primaryColor),
                    child:
                        // Row(
                        //   children: [
                        //     StatusDropdownComponent(
                        //       isValidate: false,
                        //       onValueChanged: (BookingStatusResponse value) {
                        //         selectedValue = value.value.toString();
                        //         isBookingTypeChanged = true;

                        //         page = 1;
                        //         init();

                        //         setState(() {});

                        //         if (bookings.isNotEmpty) {
                        //           scrollController.animateTo(0,
                        //               duration: 1.seconds,
                        //               curve: Curves.easeOutQuart);
                        //         }
                        //       },
                        //     ),
                        //   ],
                        // )
                        CachedImageWidget(
                      url: ic_filter,
                      height: 26,
                      width: 26,
                      color: Colors.white,
                    ),
                  ).onTap(() {
                    hideKeyboard(context);
                    // showModalBottomSheet<void>(
                    //   backgroundColor: Colors.transparent,
                    //   context: context,
                    //   isScrollControlled: true,
                    //   isDismissible: true,
                    //   builder: (BuildContext context) {
                    //     return Container(
                    //         alignment: Alignment.bottomLeft,
                    //         decoration: boxDecorationWithRoundedCorners(
                    //             borderRadius: radius(20),
                    //             backgroundColor: context.cardColor),
                    //         height: MediaQuery.of(context).size.height * 0.75,
                    //         // color: Colors.white,
                    //         child: StatusBottomSheetComponent(
                    //           isValidate: false,
                    //           defaultValue: selectedValue,
                    //           onValueChanged: (BookingStatusResponse value) {
                    //             selectedValue = value.value.toString();
                    //             isBookingTypeChanged = true;
                    //             page = 1;
                    //             init();

                    //             setState(() {});

                    //             if (bookings.isNotEmpty) {
                    //               scrollController.animateTo(0,
                    //                   duration: 1.seconds,
                    //                   curve: Curves.easeOutQuart);
                    //             }
                    //           },
                    //         ));
                    //   },
                    // );
                    // FilterScreen().launch(context).then((value) {
                    //   if (value != null) {
                    //     page = 1;
                    //     // fetchAllServiceData();
                    //   }
                    // });
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      isDismissible: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: radiusOnly(
                              topLeft: defaultRadius, topRight: defaultRadius)),
                      builder: (_) {
                        return DraggableScrollableSheet(
                          initialChildSize: 0.50,
                          minChildSize: 0.2,
                          maxChildSize: 0.70,
                          builder: (context, scrollController) =>
                              BookingStatusComponent(
                            scrollController: scrollController,
                            isValidate: false,
                            defaultValue: selectedValue,
                            onValueChanged: (BookingStatusResponse value) {
                              selectedValue = value.value.toString();
                              isBookingTypeChanged = true;
                              page = 1;
                              init();

                              setState(() {});

                              if (bookings.isNotEmpty) {
                                scrollController.animateTo(0,
                                    duration: 1.seconds,
                                    curve: Curves.easeOutQuart);
                              }
                            },
                          ),
                        );
                      },
                    );
                  }, borderRadius: radius())
                ],
              ),
            ),
            Observer(
                builder: (context) =>
                    LoaderWidget().visible(appStore.isLoading && isRefresh)),
            Positioned(
              bottom: isBookingTypeChanged ? 100 : 8,
              left: 0,
              right: 0,
              child: Observer(
                  builder: (_) => LoaderWidget()
                      .visible(appStore.isLoading &&
                          (page != 1 || isBookingTypeChanged))
                      .center()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showBottomSheetChooseLocation(BuildContext context,
      {firstTimeShow = false}) async {
    appStore.isLoading = true;
    await getSavedAddress().then((value) async {
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
      appStore.isLoading = false;
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
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.50,
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(20),
                      backgroundColor: context.cardColor),
                  padding: EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      DraggableScrollableSheet(
                          initialChildSize: 0.98,
                          minChildSize: 0.98,
                          maxChildSize: 0.98,
                          builder: (context, scrollController) {
                            return AskChangeLocationDialog(
                                addreses: value,
                                onSelectLocation: (lat, long, address,
                                    seletedId, isCurrentLocation) {
                                  setValue(TEMP_CURRENT_ADDRESS, address);
                                  setValue(TEMP_LATITUDE,
                                      double.parse(lat.toStringAsFixed(4)));
                                  setValue(TEMP_LONGITUDE,
                                      double.parse(long.toStringAsFixed(4)));
                                  setValue(TEMP_SELECTED_ADDRESS, seletedId);
                                  setValue(TEMP_IS_CURRENT_LOCATION,
                                      isCurrentLocation);
                                  setState(() {});
                                });
                          }),
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
                            bool changeAddressClearCart =
                                getBoolAsync(CHANGE_ADDRESS_CLEAR_CART);

                            if (firstTimeShow = true) {
                              appStore.setAlertChooseLocation(false);
                            }

                            if (currentTempLat != currentLate &&
                                currentTempLong != currentLong) {
                              log(123456);
                              if (cartItem > 0) {
                                if (changeAddressClearCart) {
                                  log("Change Address");
                                  showConfirmClearCart(context);
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
                                  if (currentTempLat == 0.0 &&
                                      currentTempLong == 0.0) {
                                    showConfirmDialogCustom(
                                      context,
                                      subTitle: language.pleaseChooseOneAddress,
                                      onAccept: (p0) {},
                                    );
                                  } else {
                                    // Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }
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
                                Navigator.of(context).pop();
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
                              Navigator.of(context).pop();
                              log(123456);
                            }
                          },
                        ),
                      )
                    ],
                  )));
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
                  });
                  appStore.setLoading(false);
                },
              ),
            ],
          );
        });
  }
}
