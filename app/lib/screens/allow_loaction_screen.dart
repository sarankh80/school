import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/screens/info_loaction_screen.dart';
import 'package:com.gogospider.booking/screens/map/map_screen.dart';
import 'package:com.gogospider.booking/services/location_service.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:location/location.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:permission_handler/permission_handler.dart';

class AllowLocationScreen extends StatefulWidget {
  @override
  _AllowLocationScreenState createState() => _AllowLocationScreenState();
}

class _AllowLocationScreenState extends State<AllowLocationScreen> {
  // _AllowLocationScreenState(this._permission);

  // PermissionStatus? _permission;
  final Location location = Location();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> _requestPermission() async {
  //   if (_permission != PermissionStatus.granted) {
  //     final permissionRequestedResult = await location.requestPermission();
  //     setState(() {
  //       _permission = permissionRequestedResult;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "សូមបើកទីតាំង ដើម្បីកំណត់ការកក់ត្រឹមត្រូវ",
              style: boldTextStyle(size: 19),
            ),
            Text(
              "Allow Location to Book Handyman",
              style: boldTextStyle(size: 17),
            ),
            10.height,
            Center(
              child: CachedImageWidget(
                url: ic_allow_location,
                height: MediaQuery.of(context).size.width - 10,
              ),
            ),
            Center(
                child: CachedImageWidget(
              url: ic_map,
              height: 150,
            )),
            15.height,
            Center(
              child: Text(
                "គោលបំណងនៃការ សុំទីតាំង​កន្លែងនេះ គឺសម្រាប់អនុញ្ញាត អោយជាងអាចងាយស្រួលស្វែងទីតាំងរបស់លោកអ្នក",
                style: secondaryTextStyle(size: 16, color: black),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
                child: Text(
              "The purpose of the location is to find where we can provide the services.",
              textAlign: TextAlign.center,
            )),
            100.height,
          ],
        )).paddingAll(15),
        Positioned(
            bottom: 20,
            left: 20,
            child: AppButton(
              textColor: black,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: cardColor,
              child: Text(
                language.back,
                style: boldTextStyle(color: black),
              ),
              onTap: () {
                finish(context);
              },
            )),
        Positioned(
            bottom: 20,
            right: 20,
            child: AppButton(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: appStore.isLoading
                  ? primaryColor.withOpacity(50)
                  : primaryColor,
              child: Observer(
                  builder: (context) => appStore.isLoading
                      ? Text(
                          language.pleaseWait,
                          style: boldTextStyle(color: white),
                        )
                      : Text(
                          language.allow,
                          style: boldTextStyle(color: white),
                        )),
              onTap: () async {
                appStore.setLoading(true);
                LocationPermissions.locationPermissionsGranted()
                    .then((value) async {
                  if (value) {
                    await setValue(PERMISSION_STATUS, value);
                    await getUserLocation(setLatLong: true).then((value) async {
                      await appStore
                          .setCurrentLocation(true)
                          .then((value) async {
                        appStore.setLoading(false);
                        InfoLocationScreen().launch(context);
                      });
                    }).catchError((e) {
                      appStore.setLoading(false);
                      InfoLocationScreen().launch(context);
                    });
                    // InfoLocationScreen().launch(context);
                  } else {
                    appStore.setLoading(false);
                    MapScreen(
                      latitude: getDoubleAsync(LATITUDE),
                      latLong: getDoubleAsync(LONGITUDE),
                      newAddress: false,
                      firstTimeAddress: true,
                    ).launch(context);
                  }
                }).catchError((e) {
                  InfoLocationScreen().launch(context);
                  appStore.setLoading(false);
                  toast(language.somethingWentWrong, print: true);
                });
              },
            )),
        // Observer(
        //     builder: (context) => LoaderWidget().visible(appStore.isLoading)),
      ]),
    ));
  }
}
