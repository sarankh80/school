import 'dart:async';

import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/screens/dashboard/component/saved_address_item.dart';
import 'package:com.gogospider.booking/screens/map/map_screen.dart';
import 'package:com.gogospider.booking/services/location_service.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

class AskChangeLocationDialog extends StatefulWidget {
  final Function(BuildContext)? onNewAddress;
  final Function(double lat, double long, String address, int? selectedId,
      bool? isCurrentLocation)? onSelectLocation;
  final ScrollController? scrollController;
  final SavedAddressListResponse addreses;
  final bool showWelcomeBack;
  final bool newAddressWithBottomSheet;
  final bool? moveCamera;

  AskChangeLocationDialog(
      {this.onNewAddress,
      this.onSelectLocation,
      this.scrollController,
      required this.addreses,
      this.showWelcomeBack = true,
      this.newAddressWithBottomSheet = false,
      this.moveCamera = false});

  @override
  State<AskChangeLocationDialog> createState() =>
      _AskChangeLocationDialogState();
}

class _AskChangeLocationDialogState extends State<AskChangeLocationDialog> {
  Completer<GoogleMapController> controller = Completer();
  String? currentAddress;
  LocationPermission? permission;
  int selectedAddressId = 0;

  @override
  void initState() {
    super.initState();
    selectedAddressId = getIntAsync(SELECTED_ADDRESS);
    widget.addreses.data!.sort(
      (a, b) {
        if (b.isSelected == true) {
          return 1;
        }
        return -1;
      },
    );
    _getCurrentLocation();
  }

  // Method for retrieving the current location
  void _getCurrentLocation({moveCamera = false, setLatLan = false}) async {
    appStore.setLoading(true);
    await getUserLocationPosition().then((position) async {
      if (appStore.isCurrentLocation == true) {
        setAddress(LatLng(position.latitude, position.longitude),
            setLatLan: true);
      } else {
        setAddress(LatLng(position.latitude, position.longitude),
            setLatLan: setLatLan);
      }
    }).catchError((e) {
      appStore.setCurrentLocation(false);
      appStore.setCustomeLocation(false);
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  // Method for retrieving the address
  void setAddress(LatLng position, {setLatLan = false}) async {
    try {
      currentAddress = await buildFullAddressFromLatLong(
              position.latitude, position.longitude)
          .catchError((e) {
        log(e);
        return e;
      });
      log("Current Address : $currentAddress");
      if (setLatLan) {
        // setValue(CURRENT_ADDRESS, currentAddress);
        if (widget.onSelectLocation != null) {
          widget.onSelectLocation!.call(
              double.parse(position.latitude.toStringAsFixed(4)),
              double.parse(position.longitude.toStringAsFixed(4)),
              currentAddress!,
              0,
              true);
        }
      }

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: widget.scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                5.height,
                Container(
                  child: Column(children: [
                    widget.showWelcomeBack == true
                        ? Text(
                            '${language.welcomeBack}',
                            style: boldTextStyle(size: 15),
                          ).paddingSymmetric(horizontal: 5)
                        : SizedBox(),
                    Text(
                      '${language.whatAddressDoYouWantBooking}',
                      style: boldTextStyle(size: 17),
                      textAlign: TextAlign.center,
                    ).paddingSymmetric(horizontal: 16, vertical: 5),
                    5.height,
                  ]),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: (appStore.isCurrentLocation == true &&
                                appStore.isCustomeLocation == false)
                            ? cardColor
                            : context.dividerColor),
                    borderRadius: radius(),
                    color: (appStore.isCurrentLocation == true &&
                            appStore.isCustomeLocation == false)
                        ? Colors.red[100]
                        : context.scaffoldBackgroundColor,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ic_telegram.iconImage(size: 15),
                          10.width,
                          Text(
                            language.bookingWithYourCurrentLocation,
                            style: boldTextStyle(size: 15),
                          ),
                          Spacer(),
                          if (appStore.isCurrentLocation == true &&
                              appStore.isCustomeLocation == false)
                            RoundedCheckBox(
                              borderColor: context.primaryColor,
                              checkedColor: context.primaryColor,
                              isChecked: true,
                              textStyle: secondaryTextStyle(),
                              size: 20,
                            ),
                        ],
                      ),
                      if (currentAddress == "" && currentAddress == null)
                        Text(language
                            .allowYourLocationPermissionToAccessYourCurrentLocation)
                    ],
                  ),
                ).onTap(() async {
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
                  }
                  if (permission == LocationPermission.deniedForever) {
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
                    _getCurrentLocation(
                        moveCamera: widget.moveCamera, setLatLan: true);
                  }
                  appStore.setCurrentLocation(true);
                  appStore.setCustomeLocation(false);
                  // DashboardScreen().launch(context, isNewTask: true);
                }),
                10.height,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: radius(),
                    color: context.scaffoldBackgroundColor,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: radius(),
                          color: primaryColor,
                        ),
                        child: ic_plus
                            .iconImage(size: 13, color: Colors.white)
                            .paddingAll(7),
                      ),
                      Text(
                        language.bookingDifferentLocationsUsingmap,
                        style: primaryTextStyle(size: 15),
                      ).paddingLeft(10),
                      // Spacer(),
                      // ic_arrow_right.iconImage(size: 18, color: primaryColor),
                    ],
                  ),
                ).onTap(() async {
                  if (widget.newAddressWithBottomSheet) {
                    widget.onNewAddress!.call(context);
                  } else {
                    MapScreen(
                      newAddress: true,
                      firstTimeAddress: false,
                    ).launch(context);
                  }
                }),
                10.height,
                (appStore.isCurrentLocation == false &&
                        appStore.isCustomeLocation == false &&
                        getStringAsync(CURRENT_ADDRESS) != "" &&
                        getIntAsync(SELECTED_ADDRESS) == 0)
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: (appStore.isCurrentLocation == false &&
                                      appStore.isCustomeLocation == false &&
                                      getStringAsync(CURRENT_ADDRESS) != "")
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(getStringAsync(CURRENT_ADDRESS))],
                        ),
                      ).onTap(() async {
                        setState(() {});
                        appStore.isCurrentLocation = false;
                        appStore.isCustomeLocation = false;
                      })
                    : SizedBox(),
                3.height,
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(language.bookingWithSavedLocations,
                      textAlign: TextAlign.left, style: boldTextStyle()),
                ),
                Container(
                    child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.addreses.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (conftext, index) {
                    return widget.addreses.data![index].title !=
                            "Current Address"
                        ? Container(
                            alignment: Alignment.center,
                            color: context.cardColor,
                            padding: EdgeInsets.only(top: 3, bottom: 3),
                            child: SavedAddressItemComponent(
                              adress: widget.addreses.data![index],
                            )).onTap(() {
                            appStore.setCustomeLocation(true);
                            appStore.setCurrentLocation(false);
                            var late = double.parse(widget
                                .addreses.data![index].late!
                                .toStringAsFixed(4));
                            var long = double.parse(widget
                                .addreses.data![index].lang!
                                .toStringAsFixed(4));
                            var address = widget.addreses.data![index].title
                                    .validate() +
                                " - " +
                                widget.addreses.data![index].address.validate();
                            int selectedId =
                                widget.addreses.data![index].id.validate();
                            if (widget.onSelectLocation != null) {
                              widget.onSelectLocation!
                                  .call(late, long, address, selectedId, false);
                            }
                            widget.addreses.data!.forEach(
                                (element) => element.isSelected = false);
                            widget.addreses.data![index].isSelected = true;
                            selectedAddressId =
                                widget.addreses.data![index].id.validate();
                            log("seleted ID ${widget.addreses.data![index]}");
                            setState(() {});
                          })
                        : SizedBox();
                  },
                )),
                55.height,
              ],
            )),
        Observer(
            builder: (context) => LoaderWidget().visible(appStore.isLoading)),
      ],
    );
  }
}
