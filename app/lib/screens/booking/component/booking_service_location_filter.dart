import 'dart:async';
import 'dart:convert';
import 'package:com.gogospider.booking/app_theme.dart';
import 'package:com.gogospider.booking/component/background_component.dart';
// import 'package:com.gogospider.booking/component/custom_stepper.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/booking_data_model.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
// import 'package:com.gogospider.booking/model/service_detail_response.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/network/network_utils.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
// import 'package:com.gogospider.booking/screens/dashboard/component/map_screen.dart';
import 'package:com.gogospider.booking/screens/dashboard/component/saved_address_item.dart';
import 'package:com.gogospider.booking/screens/map/map_screen.dart';
import 'package:com.gogospider.booking/screens/service/detail_screen.dart';
import 'package:com.gogospider.booking/screens/service/search_list_screen.dart';
import 'package:com.gogospider.booking/services/location_service.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/model_keys.dart';
// import 'package:com.gogospider.booking/utils/permissions.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class BookingServiceLocationFilter extends StatefulWidget {
  final CategoriesData? categoryData;
  final ServiceData? serviceData;
  final bool? isFromCategory;
  final int? isCat;
  late DateTime? selectedDate;
  late Time? pickupTime;

  BookingServiceLocationFilter(
      {this.categoryData,
      this.isFromCategory,
      this.serviceData,
      this.isCat,
      this.selectedDate,
      this.pickupTime});

  @override
  _BookingServiceLocationFilterState createState() =>
      _BookingServiceLocationFilterState();
}

class _BookingServiceLocationFilterState
    extends State<BookingServiceLocationFilter> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<BookingInfo>? bookingInfo = [];

  TextEditingController dateTimeCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();

  DateTime currentDateTime = DateTime.now();
  DateTime? finalDate;
  TimeOfDay? pickedTime;

  late List<SavedAddress> savedAddresses = [];
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  Set<Marker> markers = {};
  Completer<GoogleMapController> _controller = Completer();
  String _currentAddress = "";
  double? late;
  double? long;
  //1=Current Location, 2=SavedLocation,3=Custome Location
  DateTime now = DateTime.now();
  late Time _time;
  bool iosStyle = true;
  Future<SavedAddressListResponse>? future;

  bool locationPermission = false;
  LocationPermission? permission;
  final ScrollController scrollController = ScrollController();

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
      log("time debug :$_time");
    });
  }

  @override
  void initState() {
    super.initState();
    _time = Time(hour: now.hour, minute: now.minute);

    init();
    afterBuildCreated(() {
      if (appStore.isCurrentLocation == false &&
          appStore.isCustomeLocation == false) {
        _getSetLocation(
            LatLng(getDoubleAsync(LATITUDE), getDoubleAsync(LONGITUDE)),
            getStringAsync(CURRENT_ADDRESS) != ""
                ? getStringAsync(CURRENT_ADDRESS)
                : language.lblSelectAddress);
      }
      if (widget.selectedDate != null && widget.pickupTime != null) {
        dateTimeCont.text =
            "${formatDate(widget.selectedDate.toString(), format: DATE_FORMAT_3)} ${widget.pickupTime!.format(context).toString()}";
      }
    });
  }

  void init() async {
    _getCurrentLocation(moveCamera: true);
    future = getSavedAddress();
  }

  void selectDateAndTime(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? currentDateTime,
      firstDate: currentDateTime,
      lastDate: currentDateTime.add(30.days),
      builder: (_, child) {
        return Theme(
          data: appStore.isDarkMode
              ? ThemeData.dark()
              : AppTheme.lightTheme().copyWith(
                  colorScheme: ColorScheme.light(
                    background: Colors.white,
                    primary: primaryColor, // header background color
                    // onPrimary: Colors.black, // header text color
                    // onSurface: Colors.green, // body text color
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red, // button text color
                    ),
                  ),
                ),
          child: child!,
        );
      },
    ).then((date) async {
      if (date != null) {
        Navigator.of(context).push(showPicker(
          width: MediaQuery.of(context).size.width,
          hourLabel: ":",
          minuteLabel: "",
          iosStylePicker: true,
          // showSecondSelector: true,
          context: context,
          value: _time,
          accentColor: primaryColor,
          okStyle: primaryTextStyle(color: primaryColor),
          cancelStyle: primaryTextStyle(color: primaryColor),
          onChange: (Time newTime) {
            finalDate = DateTime(date.year, date.month, date.day,
                newTime.hour.validate(), newTime.minute.validate());

            DateTime now = DateTime.now().subtract(1.minutes);
            if (date.isToday &&
                finalDate!.millisecondsSinceEpoch <
                    now.millisecondsSinceEpoch) {
              return toast(
                  'You cannot select booking time ahead of current time');
            }

            widget.selectedDate = date;
            pickedTime = newTime;
            widget.pickupTime = newTime;
            log("pickedTime : $finalDate");

            dateTimeCont.text =
                "${formatDate(widget.selectedDate.toString(), format: DATE_FORMAT_3)} ${pickedTime!.format(context).toString()}";
            setState(() {
              _time = newTime;
              log("time debug :$_time");
            });
          },
          minuteInterval: TimePickerInterval.ONE,
          // Optional onChange to receive value as DateTime

          onChangeDateTime: (DateTime dateTime) {
            log("[debug datetime]:  $dateTime");
            // debugPrint("[debug datetime]:  $dateTime");
          },
        ));
      }
    });
  }

  // Method for retrieving the current location
  void _getSetLocation(LatLng latLng, String address) async {
    appStore.setLoading(true);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(latLng.latitude, latLng.longitude), zoom: 18.0),
      ),
    );

    markers.clear();
    markers.add(Marker(
      markerId: MarkerId(_currentAddress),
      position: LatLng(latLng.latitude, latLng.longitude),
      infoWindow: InfoWindow(title: 'Start $address', snippet: address),
      icon: BitmapDescriptor.defaultMarker,
    ));

    setState(() {
      late = latLng.latitude;
      long = latLng.longitude;
      setValue(BOOKING_LATITUDE, latLng.latitude);
      setValue(BOOKING_LONGITUDE, latLng.longitude);
      _currentAddress = address;
    });
    appStore.setLoading(false);
  }

  // Method for retrieving the current location
  void _getCurrentLocation({bool moveCamera = false}) async {
    // if (appStore.isCurrentLocation == true) {
    final GoogleMapController controller = await _controller.future;
    appStore.setLoading(true);

    await getUserLocationPosition().then((position) async {
      setAddress(LatLng(position.latitude, position.longitude));
      if (moveCamera) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 18.0),
          ),
        );

        markers.clear();
        markers.add(Marker(
          markerId: MarkerId(_currentAddress),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
              title: 'Start $_currentAddress', snippet: _currentAddress),
          icon: BitmapDescriptor.defaultMarker,
        ));
      }
      if (appStore.isCustomeLocation == false) {
        appStore.setCurrentLocation(true);
      }
      setState(() {
        late = position.latitude;
        long = position.longitude;
        setValue(BOOKING_LATITUDE, position.latitude);
        setValue(BOOKING_LONGITUDE, position.longitude);
      });
    }).catchError((e) {
      // appStore.setCurrentLocation(false);
      // appStore.setCustomeLocation(false);
      toast(e.toString());
    });

    appStore.setLoading(false);
    // }
  }

  // Method for retrieving the address
  Future<void> setAddress(LatLng position) async {
    try {
      _currentAddress = await buildFullAddressFromLatLong(
              position.latitude, position.longitude)
          .catchError((e) {
        log(e);
        return e;
      });
      addressCont.text = _currentAddress;

      setState(() {});
    } catch (e) {
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
      bookingDate: widget.selectedDate,
      pickupTime: widget.pickupTime,
      categoryData: widget.categoryData,
      isCat: widget.isCat,
      isFromCategory: widget.isFromCategory,
      serviceData: widget.serviceData,
    ).launch(context);
  }

  Future<void> saveAddress() async {
    hideKeyboard(context);
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
    appStore.setLoading(true);

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        SavedAddress address = SavedAddress.fromJsonData(json.decode(data));
        log("Address ID ${address.id}");
        setValue(SELECTED_ADDRESS, address.id.validate());
        // appStore.selectedAddressId = address.id.validate();
        appStore.setLoading(false);
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
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        widget.categoryData!.name.validate(),
        textColor: Colors.white,
        color: context.primaryColor,
        // backWidget: BackWidget(
        //     // onPressed: () {
        //     //   DashboardScreen().launch(context, isNewTask: true);
        //     // },
        //     ),
      ),
      body: Container(
          // padding: EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          // decoration:
                          //     boxDecorationDefault(color: context.cardColor),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.lblStepper1Title,
                                    style: boldTextStyle(size: 18)),
                                Text(
                                    language
                                        .selectLocationToFilterHandymanNearBy,
                                    style: secondaryTextStyle(size: 15)),
                                6.height,
                                Text(language.lblDateAndTime,
                                    style: boldTextStyle()),
                                6.height,
                                AppTextField(
                                  textFieldType: TextFieldType.OTHER,
                                  controller: dateTimeCont,
                                  isValidationRequired: true,
                                  validator: (value) {
                                    if (value!.isEmpty)
                                      return language.lblRequiredValidation;
                                    return null;
                                  },
                                  readOnly: true,
                                  onTap: () {
                                    selectDateAndTime(context);
                                  },
                                  decoration: inputDecoration(context,
                                          prefixIcon: ic_calendar
                                              .iconImage(size: 10)
                                              .paddingAll(14))
                                      .copyWith(
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    fillColor: context.scaffoldBackgroundColor,
                                    filled: true,
                                    hintText: language.lblEnterDateAndTime,
                                    hintStyle: secondaryTextStyle(),
                                  ),
                                ),
                                6.height,
                                Text(language.bookingAddress,
                                    style: boldTextStyle()),
                              ])),
                      Stack(
                        children: [
                          Container(
                              color: context.cardColor,
                              height: 270,
                              width: MediaQuery.of(context).size.width,
                              child: GoogleMap(
                                markers: Set<Marker>.from(markers),
                                initialCameraPosition: _initialLocation,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,
                                mapType: MapType.normal,
                                zoomGesturesEnabled: true,
                                zoomControlsEnabled: false,
                                onMapCreated: _onMapCreated,
                                onTap: _handleTap,
                              )),
                        ],
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: (appStore.isCurrentLocation == true &&
                                        appStore.isCustomeLocation == false)
                                    ? warningColor
                                    : context.dividerColor),
                            borderRadius: radius(),
                            color: (appStore.isCurrentLocation == true &&
                                    appStore.isCustomeLocation == false)
                                ? Colors.red[100]
                                : context.scaffoldBackgroundColor,
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${language.lblUseCurrentLocation}",
                                style: boldTextStyle(
                                  size: 14,
                                ),
                              ),
                              addressCont.text != ""
                                  ? Text(addressCont.text)
                                  : Text(language
                                      .allowYourLocationPermissionToAccessYourCurrentLocation)
                            ],
                          )).onTap(() async {
                        LocationPermission permission =
                            await Geolocator.checkPermission();

                        if (permission == LocationPermission.denied) {
                          showConfirmDialogCustom(
                            context,
                            dialogType: DialogType.CONFIRMATION,
                            primaryColor: context.primaryColor,
                            negativeText: language.lblClose,
                            positiveText: language.lblSetting,
                            title: language.lblEnableLocationServiceTitle,
                            subTitle: language.lblConfirmEnableLocationService,
                            onAccept: (c) async {
                              await Geolocator.openAppSettings();
                            },
                          );
                        } else if (permission ==
                            LocationPermission.deniedForever) {
                          showConfirmDialogCustom(
                            context,
                            dialogType: DialogType.CONFIRMATION,
                            primaryColor: context.primaryColor,
                            negativeText: language.lblClose,
                            positiveText: language.lblSetting,
                            title: language.lblEnableLocationServiceTitle,
                            subTitle: language.lblConfirmEnableLocationService,
                            onAccept: (c) async {
                              await Geolocator.openAppSettings();
                            },
                          );
                        } else {
                          appStore.setCurrentLocation(true);
                          appStore.setCustomeLocation(false);
                          _getCurrentLocation(moveCamera: true);
                        }
                      }),
                      2.height,
                      (appStore.isCurrentLocation == false &&
                              appStore.isCustomeLocation == false &&
                              getStringAsync(CURRENT_ADDRESS) != "")
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        (appStore.isCurrentLocation == false &&
                                                appStore.isCustomeLocation ==
                                                    false &&
                                                getStringAsync(
                                                        CURRENT_ADDRESS) !=
                                                    "")
                                            ? warningColor
                                            : context.dividerColor),
                                borderRadius: radius(),
                                color: (appStore.isCurrentLocation == false &&
                                        appStore.isCustomeLocation == false &&
                                        getStringAsync(CURRENT_ADDRESS) != "")
                                    ? Colors.red[100]
                                    : context.scaffoldBackgroundColor,
                              ),
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getStringAsync(CURRENT_ADDRESS))
                                ],
                              ),
                            ).onTap(() async {
                              setState(() {});
                              appStore.isCurrentLocation = false;
                              appStore.isCustomeLocation = false;
                            })
                          : SizedBox(),
                      Container(
                        color: context.cardColor,
                        child: Column(children: [
                          Container(
                              child: SnapHelperWidget<SavedAddressListResponse>(
                            future: future,
                            loadingWidget: LoaderWidget(),
                            onSuccess: (addreses) {
                              if (addreses.data!.isEmpty) {
                                return BackgroundComponent(
                                  text: language.lblNoBookingsFound,
                                );
                              }
                              savedAddresses = addreses.data.validate();
                              return AnimatedListView(
                                      // controller: scrollController,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.only(
                                          top: 5, right: 16, left: 16),
                                      itemCount: addreses.data!.length,
                                      shrinkWrap: true,
                                      listAnimationType: ListAnimationType.Slide,
                                      slideConfiguration: SlideConfiguration(
                                          verticalOffset: 400),
                                      disposeScrollController: false,
                                      itemBuilder: (_, index) {
                                        SavedAddress? data =
                                            addreses.data![index];

                                        // int selectedLocation =
                                        //     appStore.selectedAddressId;
                                        int selectedLocation =
                                            getIntAsync(SELECTED_ADDRESS);
                                        if ((addreses.data!
                                                .where((element) =>
                                                    element.isSelected == true)
                                                .isEmpty) &&
                                            (addreses.data![index].id ==
                                                selectedLocation)) {
                                          addreses.data![index].isSelected =
                                              true;
                                          if (appStore.isCustomeLocation ==
                                              true) {
                                            _getSetLocation(
                                                LatLng(
                                                    addreses.data![index].late
                                                        .validate(),
                                                    addreses.data![index].lang
                                                        .validate()),
                                                addreses.data![index].address
                                                    .validate());
                                          }
                                        }

                                        return Container(
                                            alignment: Alignment.center,
                                            color: context.cardColor,
                                            padding: EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 5,
                                                bottom: 5),
                                            child: SavedAddressItemComponent(
                                              adress: data,
                                            ).onTap(() {
                                              appStore.setCustomeLocation(true);
                                              appStore
                                                  .setCurrentLocation(false);

                                              addreses.data!.forEach(
                                                  (element) => element
                                                      .isSelected = false);
                                              data.isSelected = true;

                                              setValue(SELECTED_ADDRESS,
                                                  data.id.validate());
                                              // appStore.selectedAddressId =
                                              //     data.id.validate();
                                              setValue(CURRENT_ADDRESS,
                                                  data.address.validate());
                                              _getSetLocation(
                                                  LatLng(data.late.validate(),
                                                      data.lang.validate()),
                                                  data.address.validate());
                                              setState(() {});
                                            }));
                                      })
                                  .paddingOnly(
                                      left: 0, right: 0, bottom: 0, top: 0);
                            },
                          )),
                        ]),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ic_plus.iconImage(size: 13, color: warningColor),
                            5.width,
                            Text(
                              "${language.selectDifferentLocation}",
                              style: boldTextStyle(size: 15),
                            ).paddingLeft(10),
                            Spacer(),
                            ic_arrow_right.iconImage(size: 18),
                          ]).onTap(() {
                        MapScreen(
                          latitude: getDoubleAsync(LATITUDE),
                          latLong: getDoubleAsync(LONGITUDE),
                          newAddress: true,
                          firstTimeAddress: false,
                          fromBookingDate: true,
                          bookingDate: widget.selectedDate,
                          categoryData: widget.categoryData,
                          isCat: widget.isCat,
                          isFromCategory: widget.isFromCategory,
                          serviceData: widget.serviceData,
                        ).launch(context);
                      }).paddingAll(16),
                    ],
                  ),
                ),
                50.height,
              ],
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
                padding: EdgeInsets.all(16),
                // color: context.cardColor,
                width: MediaQuery.of(context).size.width,
                child: AppButton(
                  onTap: () async {
                    hideKeyboard(context);
                    log("formkey ${formKey.currentState!.validate()}");
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      // appStore.isLoading = true;

                      BookingInfo v = BookingInfo(
                          date: DateTime.now().toIso8601String(),
                          address: _currentAddress,
                          latitude: late,
                          longtitude: long,
                          bookingDate: widget.selectedDate.toString(),
                          bookingDateTime: finalDate?.toIso8601String(),
                          bookingTime: pickedTime?.format(context),
                          bookingDateFormat: finalDate.toString());
                      bookingInfo?.add(v);
                      await showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        isScrollControlled: true,
                        isDismissible: false,
                        enableDrag: false,
                        useSafeArea: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: radiusOnly(
                                topLeft: defaultRadius,
                                topRight: defaultRadius)),
                        builder: (_) {
                          return Stack(children: [
                            DraggableScrollableSheet(
                                initialChildSize: 0.80,
                                minChildSize: 0.50,
                                maxChildSize: 0.80,
                                builder: (context, scrollController) =>
                                    Container(
                                      decoration:
                                          boxDecorationWithRoundedCorners(
                                              borderRadius: radius(20),
                                              backgroundColor:
                                                  context.cardColor),
                                      height:
                                          MediaQuery.of(context).size.height,
                                      padding: EdgeInsets.all(16),
                                      alignment: Alignment.topLeft,
                                      child: SingleChildScrollView(
                                          controller: scrollController,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              18.height,
                                              Text(
                                                language
                                                    .lblAreyouSureBookingThisInfo,
                                                style: boldTextStyle(size: 18),
                                                textAlign: TextAlign.center,
                                              ),
                                              25.height,
                                              Text(
                                                language.lblBookingDate,
                                                style: boldTextStyle(size: 16),
                                              ),
                                              10.height,
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration:
                                                    boxDecorationWithRoundedCorners(
                                                  backgroundColor: context
                                                      .scaffoldBackgroundColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(16)),
                                                ),
                                                padding: EdgeInsets.all(15),
                                                child: Text(
                                                    "${formatDate(finalDate.toString(), format: DATE_FORMAT_2)} At ${formatDate(finalDate.toString(), format: HOUR_12_FORMAT)}"),
                                              ),
                                              15.height,
                                              Text(
                                                language.bookingAddress,
                                                style: boldTextStyle(size: 16),
                                              ),
                                              10.height,
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration:
                                                      boxDecorationWithRoundedCorners(
                                                    backgroundColor: context
                                                        .scaffoldBackgroundColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                16)),
                                                  ),
                                                  padding: EdgeInsets.all(15),
                                                  child: Text(_currentAddress)),
                                              15.height,
                                              Stack(children: [
                                                Container(
                                                    height: 300,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: GoogleMap(
                                                      markers: Set<Marker>.from(
                                                          markers),
                                                      initialCameraPosition:
                                                          CameraPosition(
                                                              target: LatLng(
                                                                  late.validate(),
                                                                  long.validate())),
                                                      myLocationEnabled: true,
                                                      myLocationButtonEnabled:
                                                          false,
                                                      mapType: MapType.normal,
                                                      zoomGesturesEnabled: true,
                                                      zoomControlsEnabled:
                                                          false,
                                                      onMapCreated:
                                                          (controller) {
                                                        controller.animateCamera(
                                                            CameraUpdate.newLatLngZoom(
                                                                LatLng(
                                                                    late.validate(),
                                                                    long.validate()),
                                                                18));
                                                      },
                                                      // onTap: _handleTap,
                                                    ))
                                              ]),
                                              50.height
                                            ],
                                          )),
                                    )),
                            Positioned(
                                bottom: 30,
                                left: 16,
                                right: 16,
                                child: Row(
                                  children: [
                                    AppButton(
                                      // width: MediaQuery.of(context).size.width,
                                      text: language.lblNo,
                                      margin: EdgeInsets.only(right: 10),
                                      color: holdColor,
                                      textStyle: boldTextStyle(
                                          size: 15, color: Colors.white),
                                      onTap: () async {
                                        finish(context);
                                      },
                                    ).expand(),
                                    15.width,
                                    AppButton(
                                      // width: MediaQuery.of(context).size.width,
                                      text: language.lblYes,
                                      margin: EdgeInsets.only(right: 10),
                                      color: primaryColor,
                                      textStyle: boldTextStyle(
                                          size: 15, color: Colors.white),
                                      onTap: () async {
                                        if (appStore.isCurrentLocation ==
                                                false &&
                                            appStore.isCustomeLocation ==
                                                false) {
                                          log("isCurrentLocation == false && appStore.isCustomeLocation == false");
                                          if (savedAddresses.isNotEmpty) {
                                            List<SavedAddress>? exitAddress =
                                                savedAddresses
                                                    .where((element1) =>
                                                        element1.late == late &&
                                                        element1.lang == long)
                                                    .toList();
                                            if (exitAddress.isEmpty) {
                                              appStore.isLoading = true;
                                              await saveAddress()
                                                  .then((value) async {
                                                appStore.isLoading = false;
                                                final String encodedData =
                                                    BookingInfo.encode(
                                                        bookingInfo!);
                                                await setValue(BOOKING_INFO,
                                                        encodedData)
                                                    .then((value) {
                                                  if (widget.isCat == 1) {
                                                    SearchListScreen()
                                                        .launch(context);
                                                  } else if (widget.isCat ==
                                                      2) {
                                                    ViewDetail(
                                                            service: widget
                                                                .serviceData,
                                                            serviceId: widget
                                                                .serviceData!
                                                                .id)
                                                        .launch(context);
                                                  } else
                                                    SearchListScreen(
                                                      categoryId: widget
                                                          .categoryData!.id
                                                          .validate(),
                                                      categoryName: widget
                                                          .categoryData!.name,
                                                      categoriesData:
                                                          widget.categoryData,
                                                    ).launch(context);
                                                });
                                              });
                                            } else {
                                              setValue(
                                                  SELECTED_ADDRESS,
                                                  exitAddress.first.id
                                                      .validate());
                                              // appStore.selectedAddressId =
                                              //     exitAddress.first.id
                                              //         .validate();
                                              final String encodedData =
                                                  BookingInfo.encode(
                                                      bookingInfo!);
                                              await setValue(
                                                      BOOKING_INFO, encodedData)
                                                  .then((value) {
                                                if (widget.isCat == 1) {
                                                  SearchListScreen()
                                                      .launch(context);
                                                } else if (widget.isCat == 2) {
                                                  ViewDetail(
                                                          service: widget
                                                              .serviceData,
                                                          serviceId: widget
                                                              .serviceData!.id)
                                                      .launch(context);
                                                } else
                                                  SearchListScreen(
                                                    categoryId: widget
                                                        .categoryData!.id
                                                        .validate(),
                                                    categoryName: widget
                                                        .categoryData!.name,
                                                    categoriesData:
                                                        widget.categoryData,
                                                  ).launch(context);
                                              });
                                            }
                                          } else {
                                            appStore.isLoading = true;
                                            await saveAddress()
                                                .then((value) async {
                                              appStore.isLoading = false;
                                              final String encodedData =
                                                  BookingInfo.encode(
                                                      bookingInfo!);
                                              await setValue(
                                                      BOOKING_INFO, encodedData)
                                                  .then((value) {
                                                if (widget.isCat == 1) {
                                                  SearchListScreen()
                                                      .launch(context);
                                                } else if (widget.isCat == 2) {
                                                  ViewDetail(
                                                          service: widget
                                                              .serviceData,
                                                          serviceId: widget
                                                              .serviceData!.id)
                                                      .launch(context);
                                                } else
                                                  SearchListScreen(
                                                    categoryId: widget
                                                        .categoryData!.id
                                                        .validate(),
                                                    categoryName: widget
                                                        .categoryData!.name,
                                                    categoriesData:
                                                        widget.categoryData,
                                                  ).launch(context);
                                              });
                                            });
                                          }
                                        } else {
                                          if (appStore.isCurrentLocation ==
                                              true) {
                                            log("isCurrentLocation == true");
                                            if (savedAddresses.isNotEmpty) {
                                              List<SavedAddress>? exitAddress =
                                                  savedAddresses
                                                      .where((element) =>
                                                          element.late ==
                                                              late &&
                                                          element.lang == long)
                                                      .toList();

                                              if (exitAddress.isEmpty) {
                                                appStore.isLoading = true;
                                                await saveAddress()
                                                    .then((value) async {
                                                  appStore.isLoading = false;
                                                  final String encodedData =
                                                      BookingInfo.encode(
                                                          bookingInfo!);
                                                  await setValue(BOOKING_INFO,
                                                          encodedData)
                                                      .then((value) {
                                                    if (widget.isCat == 1) {
                                                      SearchListScreen()
                                                          .launch(context);
                                                    } else if (widget.isCat ==
                                                        2) {
                                                      ViewDetail(
                                                              service: widget
                                                                  .serviceData,
                                                              serviceId: widget
                                                                  .serviceData!
                                                                  .id)
                                                          .launch(context);
                                                    } else
                                                      SearchListScreen(
                                                        categoryId: widget
                                                            .categoryData!.id
                                                            .validate(),
                                                        categoryName: widget
                                                            .categoryData!.name,
                                                        categoriesData:
                                                            widget.categoryData,
                                                      ).launch(context);
                                                  });
                                                });
                                              } else {
                                                setValue(
                                                    SELECTED_ADDRESS,
                                                    exitAddress.first.id
                                                        .validate());
                                                // appStore.selectedAddressId =
                                                //     exitAddress.first.id
                                                //         .validate();
                                                final String encodedData =
                                                    BookingInfo.encode(
                                                        bookingInfo!);
                                                await setValue(BOOKING_INFO,
                                                        encodedData)
                                                    .then((value) {
                                                  if (widget.isCat == 1) {
                                                    SearchListScreen()
                                                        .launch(context);
                                                  } else if (widget.isCat ==
                                                      2) {
                                                    ViewDetail(
                                                            service: widget
                                                                .serviceData,
                                                            serviceId: widget
                                                                .serviceData!
                                                                .id)
                                                        .launch(context);
                                                  } else
                                                    SearchListScreen(
                                                      categoryId: widget
                                                          .categoryData!.id
                                                          .validate(),
                                                      categoryName: widget
                                                          .categoryData!.name,
                                                      categoriesData:
                                                          widget.categoryData,
                                                    ).launch(context);
                                                });
                                              }
                                            } else {
                                              appStore.isLoading = true;
                                              await saveAddress()
                                                  .then((value) async {
                                                appStore.isLoading = false;
                                                final String encodedData =
                                                    BookingInfo.encode(
                                                        bookingInfo!);
                                                await setValue(BOOKING_INFO,
                                                        encodedData)
                                                    .then((value) {
                                                  if (widget.isCat == 1) {
                                                    SearchListScreen()
                                                        .launch(context);
                                                  } else if (widget.isCat ==
                                                      2) {
                                                    ViewDetail(
                                                            service: widget
                                                                .serviceData,
                                                            serviceId: widget
                                                                .serviceData!
                                                                .id)
                                                        .launch(context);
                                                  } else
                                                    SearchListScreen(
                                                      categoryId: widget
                                                          .categoryData!.id
                                                          .validate(),
                                                      categoryName: widget
                                                          .categoryData!.name,
                                                      categoriesData:
                                                          widget.categoryData,
                                                    ).launch(context);
                                                });
                                              });
                                            }
                                          }

                                          if (appStore.isCustomeLocation ==
                                              true) {
                                            log("isCustomeLocation == true");
                                            if (getIntAsync(SELECTED_ADDRESS) ==
                                                0) {
                                              if (savedAddresses.isNotEmpty) {
                                                int selectId = savedAddresses
                                                    .firstWhere((element) =>
                                                        element.isSelected ==
                                                        true)
                                                    .id
                                                    .validate();
                                                setValue(
                                                    SELECTED_ADDRESS, selectId);

                                                final String encodedData =
                                                    BookingInfo.encode(
                                                        bookingInfo!);
                                                await setValue(BOOKING_INFO,
                                                        encodedData)
                                                    .then((value) {
                                                  if (widget.isCat == 1) {
                                                    SearchListScreen()
                                                        .launch(context);
                                                  } else if (widget.isCat ==
                                                      2) {
                                                    ViewDetail(
                                                            service: widget
                                                                .serviceData,
                                                            serviceId: widget
                                                                .serviceData!
                                                                .id)
                                                        .launch(context);
                                                  } else
                                                    SearchListScreen(
                                                      categoryId: widget
                                                          .categoryData!.id
                                                          .validate(),
                                                      categoryName: widget
                                                          .categoryData!.name,
                                                      categoriesData:
                                                          widget.categoryData,
                                                    ).launch(context);
                                                });
                                              }
                                            } else {
                                              final String encodedData =
                                                  BookingInfo.encode(
                                                      bookingInfo!);
                                              await setValue(
                                                      BOOKING_INFO, encodedData)
                                                  .then((value) {
                                                if (widget.isCat == 1) {
                                                  SearchListScreen()
                                                      .launch(context);
                                                } else if (widget.isCat == 2) {
                                                  ViewDetail(
                                                          service: widget
                                                              .serviceData,
                                                          serviceId: widget
                                                              .serviceData!.id)
                                                      .launch(context);
                                                } else
                                                  SearchListScreen(
                                                    categoryId: widget
                                                        .categoryData!.id
                                                        .validate(),
                                                    categoryName: widget
                                                        .categoryData!.name,
                                                    categoriesData:
                                                        widget.categoryData,
                                                  ).launch(context);
                                              });
                                            }
                                          }
                                        }
                                      },
                                    ).expand(),
                                  ],
                                ))
                          ]);
                        },
                      );
                    }
                  },
                  text: language.btnNext,
                  textColor: Colors.white,
                  width: context.width(),
                  color: context.primaryColor,
                )),
          ),
          Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      )),
    );
  }
}
