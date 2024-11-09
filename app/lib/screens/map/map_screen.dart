import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/screens/info_loaction_screen.dart';
import 'package:com.gogospider.booking/screens/map/new_address.dart';
import 'package:com.gogospider.booking/services/location_service.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:screenshot/screenshot.dart';

class MapScreen extends StatefulWidget {
  final Function(String address, double late, double long, String image)?
      onNewAddress;
  final Function(BuildContext context)? onClose;
  final double? latLong;
  final double? latitude;
  final bool? newAddress;
  final bool? firstTimeAddress;
  final bool? fromBookingDate;
  final DateTime? bookingDate;
  final Time? pickupTime;
  final CategoriesData? categoryData;
  final ServiceData? serviceData;
  final bool? isFromCategory;
  final int? isCat;

  MapScreen(
      {this.onNewAddress,
      this.onClose,
      this.latLong,
      this.latitude,
      this.newAddress,
      this.firstTimeAddress = false,
      this.fromBookingDate = false,
      this.bookingDate,
      this.pickupTime,
      this.categoryData,
      this.isCat,
      this.isFromCategory,
      this.serviceData});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  String _currentAddress = '';

  final destinationAddressController = TextEditingController();
  final destinationAddressFocusNode = FocusNode();
  double latitude = 0.0;
  double longitude = 0.0;
  CameraPosition? _cameraPosition;
  late LatLng _defaultLatLng;
  late LatLng _draggedLatlng;
  String _destinationAddress = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Uint8List? imageBytes;
  String? base64image;
  ScreenshotController screenshotController = ScreenshotController();

  bool isCameraMoving = false;
  bool showTip = true;
  MapType mapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _init();
    afterBuildCreated(() {
      _getCurrentLocation();
    });
  }

  _init() {
    //set default latlng for camera position
    _defaultLatLng = LatLng(11.5566, 104.9282);
    _draggedLatlng = _defaultLatLng;
    _cameraPosition =
        CameraPosition(target: _defaultLatLng, zoom: 17.5 // number of map view
            );

    //map will redirect to my current location when loaded
    // _gotoUserCurrentPosition();
  }

  void takeSnapShot() async {
    GoogleMapController controller = await _controller.future;
    Future<void>.delayed(const Duration(milliseconds: 1000), () async {
      imageBytes = await controller.takeSnapshot();
      base64image = base64Encode(imageBytes!);
      setState(() {});
    });
  }

  // Method for retrieving the current location
  void _getCurrentLocation() async {
    final GoogleMapController mapController = await _controller.future;
    if (widget.firstTimeAddress != true) {
      appStore.setLoading(true);
      await getUserLocationPosition().then((position) async {
        setAddress();
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 18.0),
          ),
        );
        setState(() {});
      }).catchError((e) {
        // toast(e.toString());
      });

      appStore.setLoading(false);
    }
    if (widget.firstTimeAddress == true) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(11.556659, 104.928211), zoom: 18.0),
        ),
      );
    }
    if (widget.newAddress == true) {
      await getUserLocationPosition().then((position) async {
        setAddress();

        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 18.0),
          ),
        );

        setState(() {});
      }).catchError((e) async {
        _currentAddress =
            await buildFullAddressFromLatLong(11.556659, 104.928211)
                .catchError((e) {
          log(e);
          return e;
        });
        destinationAddressController.text = _currentAddress;
        _destinationAddress = _currentAddress;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(11.556659, 104.928211), zoom: 18.0),
          ),
        );
      });
    }
  }

  // Method for retrieving the address
  Future<void> setAddress() async {
    try {
      Position position = await getUserLocationPosition().catchError((e) {
        return e;
      });
      latitude = position.latitude;
      longitude = position.longitude;
      _currentAddress = await buildFullAddressFromLatLong(
              position.latitude, position.longitude)
          .catchError((e) {
        log(e);
        return e;
      });
      destinationAddressController.text = _currentAddress;
      _destinationAddress = _currentAddress;

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Widget _getCustomPin() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 30),
        width: 100,
        child: Lottie.asset("assets/pin.json"),
      ),
    );
  }

  Widget _popUpTip(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Platform.isIOS ? 110 : 90,
      ),
      padding: EdgeInsets.all(30),
      child: Stack(children: [
        Container(
          // height: 160,
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: Colors.yellow[300]!,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 0.75))
            ],
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
          ),
          margin: EdgeInsets.only(left: 17, right: 17, top: 60),
          padding: EdgeInsets.all(25),
          child: Text(language.lblMapTipString),
        ),
        Positioned(
          child: Container(
            height: 60,
            decoration: boxDecorationWithRoundedCorners(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black54,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 0.75))
              ],
              borderRadius: radius(25),
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ic_notification.iconImage(size: 30, color: Colors.red).center(),
              Spacer(),
              Text(
                language.lblTip,
                style: boldTextStyle(size: 17),
              ),
              Spacer(),
              Container(
                height: 40,
                width: 40,
                decoration: boxDecorationWithRoundedCorners(
                  // backgroundColor: redColor,
                  borderRadius: radius(25),
                ),
                // padding: EdgeInsets.all(5),
                child: Center(
                    child:
                        // ic_close_animate
                        //     .iconImage(size: 10, color: Colors.white)
                        //     .center(),
                        CachedImageWidget(
                  url: ic_close_animate,
                  height: 41,
                )),
              ).onTap(() {
                showTip = false;
                setState(() {});
              })
            ]),
          ),
        ),
      ]),
    );
  }

  //get address from dragged pin
  Future _getAddress(LatLng position) async {
    //this will list down all address around the position
    // List<Placemark> placemarks =
    //     await placemarkFromCoordinates(position.latitude, position.longitude);
    // Placemark address = placemarks[0]; // get only first and closest address
    // String addresStr =
    //     "${address.street}, ${address.locality}, ${address.administrativeArea}, ${address.country}";
    String addresStr =
        await buildFullAddressFromLatLong(position.latitude, position.longitude)
            .catchError((e) {
      log(e);
      return e;
    });
    destinationAddressController.text = addresStr;
    latitude = position.latitude;
    longitude = position.longitude;
    _currentAddress = addresStr;
    _destinationAddress = addresStr;
    setState(() {});
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: "AIzaSyDdD209nIWUuR7qIKbJ9Rd30-ueoDuIoJM",
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    setState(() {});

    mapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: "AIzaSyDdD209nIWUuR7qIKbJ9Rd30-ueoDuIoJM",
        onError: onError,
        mode: Mode.overlay,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [
          Component(Component.country, "km"),
          Component(Component.country, "kh")
        ]);

    displayPrediction(p!, _scaffoldKey.currentState);
  }

  Widget map() {
    return Stack(
      children: [
        GoogleMap(
          // liteModeEnabled: true,
          initialCameraPosition: _cameraPosition!,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: mapType,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            //this function will trigger when map is fully loaded
            if (!_controller.isCompleted) {
              //set controller to google map when it is fully loaded
              _controller.complete(controller);
              mapController = controller;
            }
          },
          onCameraIdle: () {
            //this function will trigger when user stop dragging on map
            //every time user drag and stop it will display address
            _getAddress(_draggedLatlng);
            isCameraMoving = false;

            setState(() {});
          },
          onCameraMove: (cameraPosition) {
            //this function will trigger when user keep dragging on map
            //every time user drag this will get value of latlng
            isCameraMoving = true;
            _draggedLatlng = cameraPosition.target;
            setState(() {});
          },
          onTap: (argument) {
            showTip = false;
            setState(() {});
          },
        ),
        30.height,
        if (showTip) _popUpTip(context),
        _getCustomPin(),
        30.height,
        SafeArea(
            child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15),
              width: 35,
              height: 35,
              child: Icon(
                Icons.arrow_back,
                color: redColor,
                size: 25,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ).onTap(() {
              if (widget.onClose != null) {
                widget.onClose!.call(context);
              } else {
                Navigator.of(context).pop();
              }
            }),
            Container(
              margin: EdgeInsets.only(
                left: 15,
              ),
              // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 13, horizontal: 13),
                width: MediaQuery.of(context).size.width - 90,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(25),
                    color: white,
                    border: Border.all(width: 1, color: cardColor)),
                child: Row(children: [Text(language.searchLocationNearByYou)]),
              ).onTap(() {
                _handlePressButton();
              }),
            ),
          ],
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body:
            // SafeArea(
            //   child:
            Stack(
          children: <Widget>[
            Screenshot(controller: screenshotController, child: map()),
            // SafeArea(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       ClipOval(
            //         child: Material(
            //           color: Colors.blue.shade100,
            //           child: InkWell(
            //             splashColor: context.primaryColor.withOpacity(0.8),
            //             child: SizedBox(
            //                 width: 50, height: 50, child: Icon(Icons.add)),
            //             onTap: () {
            //               mapController.animateCamera(CameraUpdate.zoomIn());
            //             },
            //           ),
            //         ),
            //       ),
            //       SizedBox(height: 20),
            //       ClipOval(
            //         child: Material(
            //           color: Colors.blue.shade100,
            //           child: InkWell(
            //             splashColor: context.primaryColor.withOpacity(0.8),
            //             child: SizedBox(
            //                 width: 50, height: 50, child: Icon(Icons.remove)),
            //             onTap: () {
            //               mapController.animateCamera(CameraUpdate.zoomOut());
            //             },
            //           ),
            //         ),
            //       ),
            //     ],
            //   ).paddingLeft(10),
            // ),
            // Positioned(
            //   bottom: 100,
            //   right: 10,
            //   child: ClipOval(
            //     child: Material(
            //       color: Colors.blue.shade100,
            //       child: InkWell(
            //         splashColor: context.primaryColor.withOpacity(0.8),
            //         child: SizedBox(
            //             width: 50, height: 50, child: Icon(Icons.gps_fixed)),
            //         onTap: () {
            //           _getCurrentLocation();
            //         },
            //       ),
            //     ),
            //   ),
            // ),

            Positioned(
              right: 0,
              left: 0,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(3),
                    child: InkWell(
                      splashColor: context.primaryColor.withOpacity(0.8),
                      child: SizedBox(
                          width: 50, height: 50, child: Icon(Icons.gps_fixed)),
                      onTap: () {
                        _getCurrentLocation();
                      },
                    ),
                  ),
                  10.height,
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(25),
                      color: white,
                    ),
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(3),
                    child: InkWell(
                      splashColor: context.primaryColor.withOpacity(0.8),
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CachedImageWidget(
                            radius: 50,
                            url: ic_default_map,
                            height: 41,
                          )),
                      onTap: () {
                        mapType = MapType.normal;

                        setState(() {});
                      },
                    ),
                  ),
                  5.height,
                  Text(
                    "Normal",
                    style: TextStyle(
                      fontWeight: fontWeightPrimaryGlobal,
                      fontFamily: fontFamilySecondaryGlobal,
                      color: textPrimaryColorGlobal,
                      fontSize: 12,
                      shadows: [
                        Shadow(
                          color: Colors.white,
                          offset: Offset(0, 1),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  5.height,
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(3),
                    child: InkWell(
                      splashColor: context.primaryColor.withOpacity(0.8),
                      child: CachedImageWidget(
                        radius: 20,
                        url: ic_satellite,
                        height: 20,
                        width: 20,
                      ),
                      onTap: () {
                        mapType = MapType.hybrid;

                        setState(() {});
                      },
                    ),
                  ),
                  5.height,
                  Text(
                    "Satellite",
                    style: primaryTextStyle(size: 12),
                  ),
                  10.height,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: context.width(),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        color: cardColor,
                        child: Text(_destinationAddress),
                      ),
                      // AppTextField(
                      //   textFieldType: TextFieldType.MULTILINE,
                      //   controller: destinationAddressController,
                      //   focus: destinationAddressFocusNode,
                      //   textStyle: primaryTextStyle(),
                      //   decoration: inputDecoration(context,
                      //           labelText: language.hintAddress)
                      //       .copyWith(
                      //           fillColor: context.scaffoldBackgroundColor),
                      // ),
                    ],
                  ),
                  8.height,
                  Row(
                    children: [
                      AppButton(
                        width: context.width() - 40,
                        height: 16,
                        color: isCameraMoving
                            ? primaryColor.withOpacity(0.9)
                            : primaryColor,
                        text: isCameraMoving
                            ? language.lblLoading
                            : language.addDetailAddress.toUpperCase(),
                        textStyle: boldTextStyle(color: white, size: 15),
                        onTap: () async {
                          if (!isCameraMoving) {
                            if (destinationAddressController.text.isNotEmpty) {
                              if (widget.newAddress!) {
                                appStore.isLoading = true;

                                GoogleMapController controller =
                                    await _controller.future;
                                Future<void>.delayed(
                                    const Duration(milliseconds: 1000),
                                    () async {
                                  imageBytes = await controller.takeSnapshot();
                                  base64image = base64Encode(imageBytes!);
                                  setState(() {});
                                }).then((value) {
                                  appStore.isLoading = false;
                                  if (widget.onNewAddress != null) {
                                    widget.onNewAddress!.call(
                                        _destinationAddress,
                                        latitude,
                                        longitude,
                                        base64image!);
                                  } else {
                                    NewAddressScreen(
                                      latitude: latitude,
                                      longitude: longitude,
                                      address: _destinationAddress,
                                      bookingDate: widget.bookingDate,
                                      pickupTime: widget.pickupTime,
                                      isFromBooking: widget.fromBookingDate,
                                      categoryData: widget.categoryData,
                                      isCat: widget.isCat,
                                      isFromCategory: widget.isFromCategory,
                                      serviceData: widget.serviceData,
                                      image: base64image,
                                    ).launch(context);
                                  }
                                });
                              } else {
                                if (widget.firstTimeAddress == true) {
                                  await setValue(CURRENT_ADDRESS,
                                      destinationAddressController.text);
                                  setValue(
                                      LATITUDE,
                                      double.parse(
                                          latitude.toStringAsFixed(4)));
                                  setValue(
                                      LONGITUDE,
                                      double.parse(
                                          longitude.toStringAsFixed(4)));
                                  setValue(
                                      BOOKING_LATITUDE,
                                      double.parse(
                                          latitude.toStringAsFixed(4)));
                                  setValue(
                                      BOOKING_LONGITUDE,
                                      double.parse(
                                          longitude.toStringAsFixed(4)));
                                  await setValue(IS_FIRST_TIME, false);
                                  // DashboardScreen().launch(context,
                                  //     isNewTask: true,
                                  //     pageRouteAnimation:
                                  //         PageRouteAnimation.Fade);
                                  InfoLocationScreen().launch(context);
                                  // finish(context);
                                } else {
                                  finish(context,
                                      destinationAddressController.text);
                                }
                              }
                            } else {
                              toast(language.lblPickAddress);
                            }
                          }
                        },
                      ),
                      // Spacer(),
                      // widget.firstTimeAddress == false
                      //     ? AppButton(
                      //         width: (context.width() / 2) - 20,
                      //         height: 16,
                      //         color: isCameraMoving
                      //             ? warningColor.withOpacity(0.9)
                      //             : warningColor,
                      //         text: isCameraMoving
                      //             ? language.lblLoading
                      //             : language.chooseThisAddress.toUpperCase(),
                      //         textStyle: boldTextStyle(color: white, size: 15),
                      //         onTap: () async {
                      //           if (!isCameraMoving) {
                      //             if (destinationAddressController
                      //                 .text.isNotEmpty) {
                      //               if (widget.newAddress!) {
                      //                 appStore.isLoading = true;

                      //                 GoogleMapController controller =
                      //                     await _controller.future;
                      //                 Future<void>.delayed(
                      //                     const Duration(milliseconds: 1000),
                      //                     () async {
                      //                   imageBytes =
                      //                       await controller.takeSnapshot();
                      //                   base64image = base64Encode(imageBytes!);
                      //                   setState(() {});
                      //                 }).then((value) {
                      //                   appStore.isLoading = false;
                      //                   if (widget.onNewAddress != null) {
                      //                     widget.onNewAddress!.call(
                      //                         _destinationAddress,
                      //                         latitude,
                      //                         longitude,
                      //                         base64image!);
                      //                   } else {
                      //                     setValue(SELECTED_ADDRESS, 0);
                      //                     // appStore.selectedAddressId = address.id.validate();

                      //                     appStore.setCurrentLocation(false);
                      //                     appStore.setCustomeLocation(true);
                      //                     // appStore.setAlertChooseLocation(false);

                      //                     setValue(TEMP_CURRENT_ADDRESS,
                      //                         _destinationAddress);
                      //                     setValue(
                      //                         TEMP_LATITUDE,
                      //                         double.parse(
                      //                             latitude.toStringAsFixed(4)));
                      //                     setValue(
                      //                         TEMP_LONGITUDE,
                      //                         double.parse(longitude
                      //                             .toStringAsFixed(4)));
                      //                     setValue(TEMP_SELECTED_ADDRESS, 0);
                      //                     setValue(
                      //                         TEMP_IS_CURRENT_LOCATION, false);

                      //                     setValue(CURRENT_ADDRESS,
                      //                         _destinationAddress);
                      //                     setValue(
                      //                         LATITUDE,
                      //                         double.parse(
                      //                             latitude.toStringAsFixed(4)));
                      //                     setValue(
                      //                         LONGITUDE,
                      //                         double.parse(longitude
                      //                             .toStringAsFixed(4)));
                      //                     setValue(
                      //                         BOOKING_LATITUDE,
                      //                         double.parse(
                      //                             latitude.toStringAsFixed(4)));
                      //                     setValue(
                      //                         BOOKING_LONGITUDE,
                      //                         double.parse(longitude
                      //                             .toStringAsFixed(4)));
                      //                     setValue(SELECTED_ADDRESS, 0);
                      //                     appStore.selectedAddressId = 0;
                      //                     DashboardScreen().launch(context,
                      //                         isNewTask: true,
                      //                         pageRouteAnimation:
                      //                             PageRouteAnimation.Fade);
                      //                   }
                      //                 });
                      //               } else {
                      //                 if (widget.firstTimeAddress == true) {
                      //                   await setValue(CURRENT_ADDRESS,
                      //                       destinationAddressController.text);
                      //                   setValue(
                      //                       LATITUDE,
                      //                       double.parse(
                      //                           latitude.toStringAsFixed(4)));
                      //                   setValue(
                      //                       LONGITUDE,
                      //                       double.parse(
                      //                           longitude.toStringAsFixed(4)));
                      //                   setValue(
                      //                       BOOKING_LATITUDE,
                      //                       double.parse(
                      //                           latitude.toStringAsFixed(4)));
                      //                   setValue(
                      //                       BOOKING_LONGITUDE,
                      //                       double.parse(
                      //                           longitude.toStringAsFixed(4)));
                      //                   await setValue(IS_FIRST_TIME, false);
                      //                   // DashboardScreen().launch(context,
                      //                   //     isNewTask: true,
                      //                   //     pageRouteAnimation:
                      //                   //         PageRouteAnimation.Fade);
                      //                   InfoLocationScreen().launch(context);
                      //                   // finish(context);
                      //                 } else {
                      //                   finish(context,
                      //                       destinationAddressController.text);
                      //                 }
                      //               }
                      //             } else {
                      //               toast(language.lblPickAddress);
                      //             }
                      //           }
                      //         },
                      //       )
                      //     : SizedBox(),
                    ],
                  ),
                  8.height,
                ],
              ).paddingAll(16),
            ),
            // Observer(
            //     builder: (context) =>
            //         LoaderWidget().visible(appStore.isLoading))
          ],
          // ),
        ));
  }
}
