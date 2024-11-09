import 'dart:async';

import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:com.gogospider.booking/utils/constant.dart';

class ChangeLocationDialog extends StatefulWidget {
  final Function()? onAccept;
  final ScrollController? scrollController;

  ChangeLocationDialog({this.onAccept, this.scrollController});

  @override
  State<ChangeLocationDialog> createState() => _ChangeLocationDialogState();
}

class _ChangeLocationDialogState extends State<ChangeLocationDialog> {
  TextEditingController addressCont = TextEditingController();
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  Completer<GoogleMapController> _controller = Completer();
  String _currentAddress = "";

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      _getSetLocation(
          LatLng(getDoubleAsync(LATITUDE), getDoubleAsync(LONGITUDE)),
          getStringAsync(CURRENT_ADDRESS) != ""
              ? getStringAsync(CURRENT_ADDRESS)
              : language.lblSelectAddress);
    });
  }

  // Method for retrieving the current location
  void _getSetLocation(LatLng latLng, String address) async {
    final GoogleMapController controller = await _controller.future;
    appStore.setLoading(true);
    _currentAddress = address.validate();
    // _destinationAddress = _currentAddress;
    addressCont.text = _currentAddress;
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
      infoWindow:
          InfoWindow(title: 'Start $_currentAddress', snippet: _currentAddress),
      icon: BitmapDescriptor.defaultMarker,
    ));

    // setState(() {
    //   late = latLng.latitude;
    //   long = latLng.longitude;
    // });
    appStore.setLoading(false);
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    // controller = await _controller.future;
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(20), backgroundColor: context.cardColor),
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(children: [
                Container(
                    color: context.cardColor,
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      markers: Set<Marker>.from(markers),
                      initialCameraPosition: _initialLocation,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      mapType: MapType.normal,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      onMapCreated: _onMapCreated,
                      // onTap: _handleTap,
                    )),
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    color: context.dividerColor,
                    width: MediaQuery.of(context).size.width,
                    child: AppTextField(
                      enabled: false,
                      textFieldType: TextFieldType.MULTILINE,
                      controller: addressCont,
                      isValidationRequired: true,
                      validator: (value) {
                        if (value!.isEmpty)
                          return language.lblRequiredValidation;
                        return null;
                      },
                      textStyle: primaryTextStyle(),
                      decoration: inputDecoration(context,
                              labelText: language.hintAddress)
                          .copyWith(fillColor: Colors.white70),
                    ),
                  ),
                ),
              ]),
              16.height,
              Text(
                '${language.changeBookingAddress}',
                style: boldTextStyle(size: 19),
              ).paddingSymmetric(horizontal: 20),
              Text(
                '${language.changeBookingAddressCommon}',
                style: primaryTextStyle(size: 15),
                textAlign: TextAlign.center,
              ).paddingAll(20),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton(
                    text: language.lblNoThank,
                    margin: EdgeInsets.only(right: 10),
                    color: primaryColor,
                    textStyle: boldTextStyle(size: 15, color: Colors.white),
                    onTap: () async {
                      finish(context, false);
                    },
                  ),
                  AppButton(
                    text: language.lblYesChange,
                    margin: EdgeInsets.only(left: 10),
                    color: warningColor,
                    textStyle: boldTextStyle(size: 15, color: Colors.white),
                    onTap: () async {
                      finish(context, true);
                    },
                  )
                ],
              ).paddingSymmetric(horizontal: 20),
              20.height,
            ],
          )),
    );
  }
}
