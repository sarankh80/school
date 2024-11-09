import 'dart:async';

import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/services/location_service.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

class MapScreenComponent extends StatefulWidget {
  final double? latLong;
  final double? latitude;
  final List<SavedAddress>? savedAddresses;
  final bool? isNewAddress;
  final Function(SavedAddress)? notifyParent;
  MapScreenComponent(
      {this.latLong,
      this.latitude,
      this.savedAddresses,
      this.isNewAddress = false,
      this.notifyParent});

  @override
  MapScreenComponentState createState() => MapScreenComponentState();
}

class MapScreenComponentState extends State<MapScreenComponent> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  // GoogleMapController? mapController;
  Completer<GoogleMapController> _controller = Completer();

  String _currentAddress = '';

  final destinationAddressController = TextEditingController();
  final destinationAddressFocusNode = FocusNode();

  String _destinationAddress = '';
  Set<Marker> markers = {};
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      _getCustomeLocation();

      if (getBoolAsync(IS_CURRENT_LOCATION)) {
        _getCurrentLocation();
      } else if (getBoolAsync(IS_SAVED_LOCATION)) {
        log("widget : ${widget.latitude}");
        if (widget.isNewAddress!) {
          _getCustomeLocation();
        } else {
          _getSetLocation();
        }
      } else {}
    });

    log(widget.notifyParent);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    // controller = await _controller.future;
    _controller.complete(controller);
  }

  // Method for retrieving the current location
  void _getSetLocation() async {
    appStore.setLoading(true);
    final GoogleMapController controller = await _controller.future;
    SavedAddress? savedAddress;
    if (widget.savedAddresses != null) {
      // widget.savedAddresses?.forEach((element) => element.isSelected = false);
      savedAddress = widget.savedAddresses!
          .firstWhere((element) => element.isSelected = true);
      _currentAddress = savedAddress.address.validate();
      destinationAddressController.text = _currentAddress;
      _destinationAddress = _currentAddress;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                  savedAddress.late.validate(), savedAddress.lang.validate()),
              zoom: 18.0),
        ),
      );

      markers.clear();
      markers.add(Marker(
        markerId: MarkerId(_currentAddress),
        position:
            LatLng(savedAddress.late.validate(), savedAddress.lang.validate()),
        infoWindow: InfoWindow(
            title: 'Start $_currentAddress', snippet: _destinationAddress),
        icon: BitmapDescriptor.defaultMarker,
      ));
    }

    setState(() {});
    appStore.setLoading(false);
  }

  // Method for retrieving the current location
  void _getCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    appStore.setLoading(true);

    await getUserLocationPosition().then((position) async {
      setAddress(LatLng(position.latitude, position.longitude));

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
            title: 'Start $_currentAddress', snippet: _destinationAddress),
        icon: BitmapDescriptor.defaultMarker,
      ));

      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  // Method for retrieving the current location
  void _getCustomeLocation() async {
    final GoogleMapController controller = await _controller.future;
    appStore.setLoading(true);

    setAddress(LatLng(widget.latitude!, widget.latLong!));

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(widget.latitude!, widget.latLong!), zoom: 17.0),
      ),
    );

    markers.clear();
    markers.add(Marker(
      markerId: MarkerId(_currentAddress),
      position: LatLng(widget.latitude!, widget.latLong!),
      infoWindow: InfoWindow(
          title: 'Start $_currentAddress', snippet: _destinationAddress),
      icon: BitmapDescriptor.defaultMarker,
    ));
    setState(() {});
    appStore.setLoading(false);
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
      destinationAddressController.text = _currentAddress;
      _destinationAddress = _currentAddress;

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  _handleTap(LatLng point) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: Set<Marker>.from(markers),
            initialCameraPosition: _initialLocation,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: _onMapCreated,
            onTap: _handleTap,
          ),
          Container(
            child: Text(language.search),
          ),
          // Positioned(
          //   right: 0,
          //   left: 0,
          //   bottom: 0,
          //   child:
          //   Container(
          //     padding: EdgeInsets.all(16),
          //     color: context.cardColor,
          //     width: MediaQuery.of(context).size.width,
          //     child: Text(
          //       _currentAddress,
          //       style: boldTextStyle(size: 14),
          //     ),
          //   ),
          // ),
          Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
