import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/configs.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('',
          elevation: 0.0, color: transparentColor, backWidget: BackWidget()),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(),
                  backgroundColor: primaryColor),
              child: Image.asset(appLogo, height: 100, width: 100).center(),
            ),
            16.height,
            Text(APP_NAME, style: boldTextStyle()),
            16.height,
            VersionInfoWidget(prefixText: 'v'),
          ],
        ),
      ),
    );
  }
}
