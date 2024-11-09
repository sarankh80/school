import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/services/location_service.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class AllowPermissionScreen extends StatefulWidget {
  @override
  _AllowPermissionScreenState createState() => _AllowPermissionScreenState();
}

class _AllowPermissionScreenState extends State<AllowPermissionScreen> {
  int currentPosition = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(locationAccess, width: context.width() * 0.50),
              50.height,
              Text(
                language.enableLocationAccess,
                style: boldTextStyle(size: 20),
              ),
              20.height,
              Text(
                language.enableLocationServiceDetail,
                style: secondaryTextStyle(size: 15),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Positioned(
            bottom: 16,
            left: 32,
            right: 32,
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              onPressed: () async {
                LocationPermissions.locationPermissionsGranted()
                    .then((value) async {
                  await setValue(PERMISSION_STATUS, value);

                  if (value) {
                    appStore.setLoading(true);
                    await setValue(PERMISSION_STATUS, value);
                    await getUserLocation(setLatLong: true).then((value) async {
                      await appStore
                          .setCurrentLocation(true)
                          .then((value) async {
                        await setValue(IS_FIRST_TIME, false);
                        appStore.setLoading(false);
                        // DashboardScreen().launch(context,
                        //     isNewTask: true,
                        //     pageRouteAnimation: PageRouteAnimation.Fade);
                      });
                    }).catchError((e) {
                      appStore.setLoading(false);
                      toast(e.toString(), print: true);
                    });
                  } else {
                    // DashboardScreen().launch(context,
                    //     isNewTask: true,
                    //     pageRouteAnimation: PageRouteAnimation.Fade);
                    // MapScreen(
                    //   latitude: getDoubleAsync(LATITUDE),
                    //   latLong: getDoubleAsync(LONGITUDE),
                    //   newAddress: false,
                    //   firstTimeAddress: true,
                    // ).launch(context);
                  }
                }).catchError((e) {
                  toast(e.toString(), print: true);
                });
              },
              child: Text(language.allow,
                  style: boldTextStyle(color: Colors.white)),
            ),
          ),
          Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ).paddingAll(16),
    );
  }
}
