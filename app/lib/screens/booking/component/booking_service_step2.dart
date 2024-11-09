import 'dart:async';
import 'dart:convert';

import 'package:another_stepper/another_stepper.dart';
import 'package:com.gogospider.booking/component/ask_change_location_dialog.dart';
import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/component/price_widget.dart';
import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/booking_data_model.dart';
import 'package:com.gogospider.booking/model/service_detail_response.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/network/network_utils.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/cart/component/booking_successful_dialog.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/screens/map/map_screen.dart';
import 'package:com.gogospider.booking/screens/map/new_address.dart';
import 'package:com.gogospider.booking/services/location_service.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/model_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class BookingServiceStep2 extends StatefulWidget {
  final ServiceDetailResponse? data;

  BookingServiceStep2({this.data});

  @override
  _BookingServiceStep2State createState() => _BookingServiceStep2State();
}

class _BookingServiceStep2State extends State<BookingServiceStep2> {
  int itemCount = 1;
  CouponData? appliedCouponData;
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  Set<Marker> markers = {};
  Completer<GoogleMapController> _controller = Completer();
  String _currentAddress = "";
  TextEditingController addressCont = TextEditingController();
  List<BookingInfo>? bookingInfo = [];

  String? finalDate;
  DBHelper? dbHelper = DBHelper();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setAddress();
    bookingInfo = BookingInfo.decode(getStringAsync(BOOKING_INFO));
    if (bookingInfo!.isNotEmpty) {
      finalDate = bookingInfo![0].bookingDateFormat;
      // log("PrintFinalDate ${finalDate}");
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // Method for retrieving the address
  Future<void> setAddress() async {
    appStore.isLoading = true;
    final GoogleMapController controller = await _controller.future;
    try {
      double late = getDoubleAsync(LATITUDE);
      double long = getDoubleAsync(LONGITUDE);
      _currentAddress = getStringAsync(TEMP_CURRENT_ADDRESS);
      await buildFullAddressFromLatLong(late, long).catchError((e) {
        log(e);
        return e;
      });
      addressCont.text = _currentAddress;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(late, long), zoom: 16.0),
        ),
      );

      markers.clear();
      markers.add(Marker(
        markerId: MarkerId(_currentAddress),
        position: LatLng(late, long),
        infoWindow: InfoWindow(
            title: 'Start $_currentAddress', snippet: _currentAddress),
        icon: BitmapDescriptor.defaultMarker,
      ));
      appStore.isLoading = false;
      setState(() {});
    } catch (e) {
      appStore.isLoading = false;
      print(e);
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
  }

  _handleTap(LatLng point) async {
    MapScreen(
      latitude: getDoubleAsync(LATITUDE),
      latLong: getDoubleAsync(LONGITUDE),
      newAddress: true,
      firstTimeAddress: false,
      fromBookingDate: true,
    ).launch(context);
  }

  Future<void> saveAddress(double late, double long) async {
    hideKeyboard(context);
    _currentAddress =
        await buildFullAddressFromLatLong(late, long).catchError((e) {
      log(e);
      return e;
    });
    int userID = getIntAsync(USER_ID);
    MultipartRequest multiPartRequest =
        await getMultiPartRequest('customers/$userID/addresses');
    multiPartRequest.fields[SaveAddressKey.title] = "Current Address";
    multiPartRequest.fields[SaveAddressKey.type] = "Home";
    multiPartRequest.fields[SaveAddressKey.floor] = "";
    multiPartRequest.fields[SaveAddressKey.note] = "";
    multiPartRequest.fields[SaveAddressKey.address] = _currentAddress;
    multiPartRequest.fields[SaveAddressKey.defualt] = '0';
    multiPartRequest.fields[SaveAddressKey.status] = '1';
    multiPartRequest.fields[SaveAddressKey.latitude] = late.toString();
    multiPartRequest.fields[SaveAddressKey.longitude] = long.toString();

    Map<String, dynamic> req = {
      SaveAddressKey.title: "Current Address",
      SaveAddressKey.address: _currentAddress,
      SaveAddressKey.floor: "",
      SaveAddressKey.note: "",
      SaveAddressKey.latitude: late.toString(),
      SaveAddressKey.longitude: long.toString(),
      SaveAddressKey.addressImage: Image.asset(ic_home, fit: BoxFit.cover),
      SaveAddressKey.uid: getStringAsync(UID),
      SaveAddressKey.type: "home",
      'createdAt': Timestamp.now(),
    };
    log('req: $req');
    multiPartRequest.headers.addAll(buildHeaderTokens());
    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        SavedAddress address = SavedAddress.fromJsonData(json.decode(data));
        log("Address ID ${address.id}");
        // appStore.selectedAddressId = address.id.validate();
        setValue(SELECTED_ADDRESS, address.id.validate());
      },
      onError: (error) {
        toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    List<StepperData> stepperData = [
      StepperData(
          title: StepperText(
            language.lblcart,
          ),
          iconWidget: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: const Text(
              "1",
              style: TextStyle(color: Colors.white),
            ),
          )),
      StepperData(
          title: StepperText(language.dateTime),
          iconWidget: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: const Text(
              "2",
              style: TextStyle(color: Colors.white),
            ),
          )),
      StepperData(
          title: StepperText(
            language.lblAddress,
          ),
          iconWidget: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: const Text(
              "3",
              style: TextStyle(color: Colors.white),
            ),
          )),
    ];
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(
        language.lblReviewAddress,
        textColor: Colors.white,
        color: primaryColor,
        showBack: Navigator.canPop(context),
        backWidget: BackWidget(),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      AnotherStepper(
                        stepperList: stepperData,
                        stepperDirection: Axis.horizontal,
                        iconWidth: 30,
                        iconHeight: 30,
                        activeBarColor: primaryColor,
                        inActiveBarColor: Colors.grey,
                        inverted: true,
                        verticalGap: 40,
                        activeIndex: 2,
                        barThickness: 4,
                      ),
                      // 15.height,
                      // Text(language.lblStepper1Title,
                      //     style: boldTextStyle(size: 20)),
                      32.height,
                      Row(
                        children: [
                          Text(language.lblBookingAddress,
                              style: boldTextStyle()),
                          Spacer(),
                          Text(language.lblEdit).onTap(() async {
                            await showChooseAddreeBottomSheet(context);
                          })
                        ],
                      ),
                      16.height,
                      Container(
                          height: 150,
                          decoration:
                              boxDecorationDefault(color: context.cardColor),
                          child: GoogleMap(
                            markers: Set<Marker>.from(markers),
                            initialCameraPosition: _initialLocation,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            mapType: MapType.normal,
                            zoomGesturesEnabled: false,
                            zoomControlsEnabled: false,
                            onMapCreated: _onMapCreated,
                            onTap: _handleTap,
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: cardColor,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          getStringAsync(CURRENT_ADDRESS),
                          style: boldTextStyle(size: 15),
                        ),
                      ),
                      16.height,
                      Text(language.lblBookingDate, style: boldTextStyle()),
                      16.height,
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration:
                            boxDecorationDefault(color: context.cardColor),
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "${formatDate(finalDate.toString(), format: DATE_FORMAT_2)} At ${formatDate(finalDate.toString(), format: HOUR_12_FORMAT)}",
                          style: boldTextStyle(),
                        ),
                      ),
                      15.height,
                      Text(language.bookingSummary, style: boldTextStyle()),
                      16.height,
                      Container(
                        decoration:
                            boxDecorationDefault(color: context.cardColor),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Consumer<CartProvider>(
                            builder: (BuildContext context, provider, widget) {
                          if (provider.cart.length == 0) {
                            return Container();
                          } else {
                            return AnimatedListView(
                                // controller: scrollController,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: provider.cart.length,
                                shrinkWrap: true,
                                listAnimationType: ListAnimationType.Slide,
                                slideConfiguration:
                                    SlideConfiguration(verticalOffset: 400),
                                disposeScrollController: false,
                                itemBuilder: (_, index) {
                                  return Row(
                                    children: [
                                      ValueListenableBuilder<int>(
                                          valueListenable:
                                              provider.cart[index].quantity!,
                                          builder: (context, val, child) {
                                            return Text(val.toString());
                                          }),
                                      Text(" x "),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          provider.cart[index].productName
                                              .validate(),
                                          maxLines: 1,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          style: secondaryTextStyle(size: 15),
                                        ),
                                      ),
                                      20.width,
                                      PriceWidget(
                                          color: textPrimaryColor,
                                          size: 14,
                                          isBoldText: false,
                                          price: provider
                                              .cart[index].productPrice
                                              .validate())
                                    ],
                                  ).paddingSymmetric(vertical: 5);
                                });
                          }
                        }),
                      ),
                      16.height,
                      Row(
                        children: [
                          Text(language.totalAmount, style: boldTextStyle()),
                          Spacer(),
                          Consumer<CartProvider>(builder:
                              (BuildContext context, value, Widget? child) {
                            final ValueNotifier<double?> totalPrice =
                                ValueNotifier(null);
                            for (var element in value.cart) {
                              totalPrice.value =
                                  (element.productPrice!.toDouble() *
                                          element.quantity!.value) +
                                      (totalPrice.value ?? 0.0);
                            }
                            return ValueListenableBuilder<double?>(
                                valueListenable: totalPrice,
                                builder: (context, val, child) {
                                  return PriceWidget(
                                    price: val.validate(),
                                    color: textPrimaryColor,
                                  );
                                });
                          })
                        ],
                      ),
                      100.height
                    ],
                  )).paddingBottom(5),
              Positioned(
                  bottom: 10,
                  child: AppButton(
                    onTap: () async {
                      appStore.setLoading(true);
                      if (appStore.isLoading) {
                        appStore.setLoading(true);
                        // if (getStringAsync(CURRENT_ADDRESS) == "") {
                        double currentLate = getDoubleAsync(LATITUDE);
                        double currentLong = getDoubleAsync(LONGITUDE);
                        await getSavedAddress().then((value) async {
                          if (value.data != null) {
                            List<SavedAddress>? existAddress = value.data!
                                .where((element) =>
                                    element.late == currentLate &&
                                    element.lang == currentLong)
                                .toList();
                            if (existAddress.isNotEmpty) {
                              appStore.selectedAddressId = existAddress[0].id!;
                              setValue(SELECTED_ADDRESS, existAddress[0].id!);
                            } else {
                              await saveAddress(currentLate, currentLong);
                            }
                          } else {
                            await saveAddress(currentLate, currentLong);
                          }
                        });
                        // }
                        hideKeyboard(context);

                        for (var i = 0; i < getIntAsync('cart_items'); i++) {
                          Map? requset = {
                            "quantity": provider.cart[i].quantity!.value,
                            "product_id": provider.cart[i].id
                          };
                          await insertCartResponse(requset, provider.cart[i].id)
                              .then((value) {})
                              .catchError((onError) {
                            showErrorDialog(context, onError);
                          });
                        }
                        // appStore.setLoading(false);
                        await showInDialog(
                          context,
                          builder: (p0) {
                            return BookingSuccessfulDialog();
                          },
                        );
                      }
                    },
                    text: (appStore.isLoading
                        ? language.lblLoading
                        : language.lblBookNow),
                    textColor: Colors.white,
                    width: MediaQuery.of(context).size.width - 32,
                    color: context.primaryColor,
                  )),
              Observer(
                  builder: (context) =>
                      LoaderWidget().visible(appStore.isLoading)),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //     padding: EdgeInsets.all(15),
      //     child: Stack(
      //       children: [
      //         // Row(
      //         //   children: [
      //         //     Text(language.totalAmount, style: boldTextStyle()),
      //         //     Spacer(),
      //         //     Consumer<CartProvider>(
      //         //         builder: (BuildContext context, value, Widget? child) {
      //         //       final ValueNotifier<double?> totalPrice =
      //         //           ValueNotifier(null);
      //         //       for (var element in value.cart) {
      //         //         totalPrice.value = (element.productPrice!.toDouble() *
      //         //                 element.quantity!.value) +
      //         //             (totalPrice.value ?? 0.0);
      //         //       }
      //         //       return ValueListenableBuilder<double?>(
      //         //           valueListenable: totalPrice,
      //         //           builder: (context, val, child) {
      //         //             return PriceWidget(
      //         //               price: val.validate(),
      //         //               color: textPrimaryColor,
      //         //             );
      //         //           });
      //         //     })
      //         //   ],
      //         // ),

      //       ],
      //     )),
    );
  }

  showChooseAddreeBottomSheet(BuildContext context) async {
    appStore.isLoading = true;
    await getSavedAddress().then((value) async {
      appStore.isLoading = false;
      int selectedAddressId = getIntAsync(SELECTED_ADDRESS);

      if (selectedAddressId != 0) {
        if (value.data!
            .where((element) => element.id == selectedAddressId)
            .isNotEmpty) {
          value.data!
              .where((element) => element.id == selectedAddressId)
              .first
              .isSelected = true;
          setState(() {});
        } else {
          appStore.isCurrentLocation = true;
        }
      }
      showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        isDismissible: true,
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius:
                radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Stack(children: [
                DraggableScrollableSheet(
                  initialChildSize: 0.50,
                  minChildSize: 0.30,
                  maxChildSize: 0.50,
                  builder: (context, scrollController) => Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: AskChangeLocationDialog(
                      showWelcomeBack: false,
                      addreses: value,
                      newAddressWithBottomSheet: true,
                      onNewAddress: (c) {
                        Navigator.of(context).pop();

                        showSelectMapBottomSheet(context);
                      },
                      onSelectLocation:
                          (lat, long, address, selectedId, isCurrentLocation) {
                        setValue(TEMP_CURRENT_ADDRESS, address);
                        setValue(TEMP_LATITUDE,
                            double.parse(lat.toStringAsFixed(4)));
                        setValue(TEMP_LONGITUDE,
                            double.parse(long.toStringAsFixed(4)));
                        setValue(TEMP_IS_CURRENT_LOCATION, isCurrentLocation);
                        setValue(TEMP_SELECTED_ADDRESS, selectedId);
                        setState(() {});
                      },
                      moveCamera: true,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 16,
                  right: 16,
                  child: AppButton(
                    width: MediaQuery.of(context).size.width,
                    text: language.lbConfirm,
                    margin: EdgeInsets.only(right: 10),
                    color: primaryColor,
                    textStyle: boldTextStyle(size: 15, color: Colors.white),
                    onTap: () async {
                      double currentLate = getDoubleAsync(LATITUDE);
                      double currentLong = getDoubleAsync(LONGITUDE);
                      double currentTempLat = getDoubleAsync(TEMP_LATITUDE);
                      double currentTempLong = getDoubleAsync(TEMP_LONGITUDE);
                      bool changeAddressClearCart =
                          getBoolAsync(CHANGE_ADDRESS_CLEAR_CART);
                      // log("Change Address ${changeAddressClearCart}");
                      int cartItem = getIntAsync('cart_items');

                      if (currentLate != currentTempLat &&
                          currentTempLong != currentLong) {
                        if (cartItem > 0) {
                          if (changeAddressClearCart) {
                            log("Change Address");
                            showConfirmClearCart(context);
                          } else {
                            appStore.setLoading(true);
                            double currentTempLat =
                                getDoubleAsync(TEMP_LATITUDE);
                            double currentTempLong =
                                getDoubleAsync(TEMP_LONGITUDE);
                            String currentTempAddress =
                                getStringAsync(TEMP_CURRENT_ADDRESS);
                            bool currentTempIsCurrentLocation =
                                getBoolAsync(TEMP_IS_CURRENT_LOCATION);
                            int currentSelectedAddress =
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
                            setValue(SELECTED_ADDRESS, currentSelectedAddress);
                            // appStore.selectedAddressId = currentSelectedAddress;
                            appStore.isCurrentLocation =
                                currentTempIsCurrentLocation;
                            appStore.setLoading(false);
                            await setAddress().then((value) {
                              double currentTempLat =
                                  getDoubleAsync(TEMP_LATITUDE);
                              double currentTempLong =
                                  getDoubleAsync(TEMP_LONGITUDE);
                              String currentTempAddress =
                                  getStringAsync(TEMP_CURRENT_ADDRESS);
                              bool currentTempIsCurrentLocation =
                                  getBoolAsync(TEMP_IS_CURRENT_LOCATION);
                              int currentSelectedAddress =
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
                              setValue(
                                  SELECTED_ADDRESS, currentSelectedAddress);
                              // appStore.selectedAddressId = currentSelectedAddress;
                              appStore.isCurrentLocation =
                                  currentTempIsCurrentLocation;
                              Navigator.pop(context);
                            });
                            // Navigator.of(context).pop();
                          }
                        }
                      } else {
                        await setAddress().then((value) {
                          double currentTempLat = getDoubleAsync(TEMP_LATITUDE);
                          double currentTempLong =
                              getDoubleAsync(TEMP_LONGITUDE);
                          String currentTempAddress =
                              getStringAsync(TEMP_CURRENT_ADDRESS);
                          bool currentTempIsCurrentLocation =
                              getBoolAsync(TEMP_IS_CURRENT_LOCATION);
                          int currentSelectedAddress =
                              getIntAsync(TEMP_SELECTED_ADDRESS);

                          setValue(CURRENT_ADDRESS, currentTempAddress);
                          setValue(BOOKING_LATITUDE,
                              double.parse(currentTempLat.toStringAsFixed(4)));
                          setValue(BOOKING_LONGITUDE,
                              double.parse(currentTempLong.toStringAsFixed(4)));
                          setValue(LATITUDE,
                              double.parse(currentTempLat.toStringAsFixed(4)));
                          setValue(LONGITUDE,
                              double.parse(currentTempLong.toStringAsFixed(4)));
                          setValue(SELECTED_ADDRESS, currentSelectedAddress);
                          // appStore.selectedAddressId = currentSelectedAddress;
                          appStore.isCurrentLocation =
                              currentTempIsCurrentLocation;
                          Navigator.pop(context);
                        });
                      }
                    },
                  ),
                )
              ]));
        },
      );
    }).catchError((onError) {
      showErrorDialog(context, onError.toString());
    });
  }

  showSelectMapBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      enableDrag: false,
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Stack(children: [
          DraggableScrollableSheet(
              initialChildSize: 1,
              minChildSize: 1,
              maxChildSize: 1,
              builder: (context, scrollController) => Container(
                      child: MapScreen(
                    newAddress: true,
                    onNewAddress: (address, late, long, image) async {
                      log("Iamge $image");
                      final GoogleMapController controller =
                          await _controller.future;
                      controller.animateCamera(
                          CameraUpdate.newLatLngZoom(LatLng(late, long), 14));
                      // _initialLocation =
                      //     CameraPosition(target: LatLng(late, long));
                      // setState(() {});
                      Navigator.of(context).pop();
                      showNewAddressBottomSheet(scaffoldKey.currentContext!,
                          address, late, long, image);
                    },
                    onClose: (context) {
                      Navigator.of(context).pop();
                    },
                  )))
        ]);
      },
    );
  }

  showNewAddressBottomSheet(BuildContext context1, String address, double late,
      double long, String image) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      enableDrag: false,
      context: context1,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Stack(children: [
          DraggableScrollableSheet(
              initialChildSize: 1,
              minChildSize: 1,
              maxChildSize: 1,
              builder: (context, scrollController) => Container(
                  color: primaryColor,
                  child: NewAddressScreen(
                    latitude: late,
                    longitude: long,
                    address: address,
                    onClose: (context) {
                      Navigator.of(context).pop();
                    },
                    onSave: (c, address) async {
                      Navigator.of(context).pop();
                      await showChooseAddreeBottomSheet(context1);
                      log(address.address);
                    },
                    image: image,
                  )))
        ]);
      },
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
                  String currentTempAddress =
                      getStringAsync(TEMP_CURRENT_ADDRESS);
                  bool currentTempIsCurrentLocation =
                      getBoolAsync(TEMP_IS_CURRENT_LOCATION);
                  int currentSelectedAddress =
                      getIntAsync(TEMP_SELECTED_ADDRESS);

                  setValue(CURRENT_ADDRESS, currentTempAddress);
                  setValue(BOOKING_LATITUDE,
                      double.parse(currentTempLat.toStringAsFixed(4)));
                  setValue(BOOKING_LONGITUDE,
                      double.parse(currentTempLong.toStringAsFixed(4)));
                  setValue(LATITUDE,
                      double.parse(currentTempLat.toStringAsFixed(4)));
                  setValue(LONGITUDE,
                      double.parse(currentTempLong.toStringAsFixed(4)));
                  setValue(SELECTED_ADDRESS, currentSelectedAddress);
                  // appStore.selectedAddressId = currentSelectedAddress;
                  appStore.isCurrentLocation = currentTempIsCurrentLocation;
                  setValue('cart_items', 0);
                  setValue('item_quantity', 0);
                  setValue('total_price', 0.0);
                  setValue('isButtonEnabled', false);

                  setValue(BOOKING_INFO, "");

                  dbHelper!.deleteAllCartItem().then((value) {
                    appStore.setLoading(false);
                    DashboardScreen().launch(context, isNewTask: true);
                  });
                  appStore.setLoading(false);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
