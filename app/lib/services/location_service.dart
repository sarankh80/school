import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter_credit_card/extension.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

Future<Position> getUserLocationPosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  LocationPermission permission = await Geolocator.checkPermission();
  if (!serviceEnabled) {
    log("serviceEnabled");
    //
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.openAppSettings();
      throw 'Location permissions are denied.';
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw 'Location permissions are permanently denied, we cannot request permissions.';
  }

  return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
      .then((value) {
    return value;
  }).catchError((e) async {
    return await Geolocator.getLastKnownPosition().then((value) async {
      if (value != null) {
        return value;
      } else {
        throw 'Please make sure Location services are enabled.';
      }
    }).catchError((e) {
      toast(e.toString());
      return e;
    });
  });
}

Future<String> getUserLocation({bool setLatLong = false}) async {
  Position position = await getUserLocationPosition().catchError((e) {
    throw e.toString();
  });

  return await buildFullAddressFromLatLong(
      position.latitude, position.longitude,
      setLatLong: setLatLong);
}

Future<String> buildFullAddressFromLatLong(double latitude, double longitude,
    {bool setLatLong = false}) async {
  List<Placemark> placeMark =
      await placemarkFromCoordinates(latitude, longitude).catchError((e) async {
    log(e.toString());
    throw language.errorSomethingWentWrong;
  });

  Placemark place = placeMark[0];

  log("place ${place.toJson()}");

  String address = '';

  if (!place.name.isEmptyOrNull && place.name != place.street)
    address = '${place.name.validate()}, ';
  if (!place.street.isEmptyOrNull)
    address = '$address${place.street.validate()}';
  if (place.subLocality.isNotNullAndNotEmpty) {
    address = '$address, ${place.subLocality}';
  } else if (!place.locality.isEmptyOrNull) {
    address = '$address, ${place.locality.validate()}';
  } else {
    address = '$address, ${place.subAdministrativeArea.validate()}';
  }
  if (!place.administrativeArea.isEmptyOrNull)
    address = '$address, ${place.administrativeArea.validate()}';
  if (!place.postalCode.isEmptyOrNull)
    address = '$address, ${place.postalCode.validate()}';
  if (!place.country.isEmptyOrNull)
    address = '$address, ${place.country.validate()}';
  if (setLatLong) {
    setValue(LATITUDE, double.parse(latitude.toStringAsFixed(4)));
    setValue(LONGITUDE, double.parse(longitude.toStringAsFixed(4)));
    setValue(CURRENT_ADDRESS, address);
    setValue(BOOKING_LATITUDE, double.parse(latitude.toStringAsFixed(4)));
    setValue(BOOKING_LONGITUDE, double.parse(longitude.toStringAsFixed(4)));
    setValue(TEMP_LATITUDE, double.parse(latitude.toStringAsFixed(4)));
    setValue(TEMP_LONGITUDE, double.parse(longitude.toStringAsFixed(4)));
    setValue(TEMP_CURRENT_ADDRESS, address);
  }

  return address;
}
