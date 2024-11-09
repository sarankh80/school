import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/screens/dont_forget_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class InfoLocationScreen extends StatefulWidget {
  @override
  _InfoLocationScreenState createState() => _InfoLocationScreenState();
}

class _InfoLocationScreenState extends State<InfoLocationScreen> {
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
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ព័ត៌មានបន្ថែមអំពីការប្រើប្រាស់ទីតាំង",
                    style: boldTextStyle(size: 19),
                  ),
                  Text(
                    "Additional Info about​ using Location",
                    style: boldTextStyle(size: 17),
                  ),
                  // 10.height,
                  Center(
                    child: CachedImageWidget(
                      url: ic_location_info,
                      height: MediaQuery.of(context).size.width - 20,
                    ),
                  ),
                  // 15.height,
                  Center(
                    child: RichText(
                      textAlign: TextAlign.left,
                      softWrap: true,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text:
                                "លោកអ្នកអាចកក់ជាង នៅទីតាំងបច្ចុប្បន្ន​ដែលកំពុងប្រើទូរស័ព្ទ ទីតាំងផ្សេង​ៗ និងទីតាំងដែលបានរក្សាទុក តាមរយះ ",
                            style: secondaryTextStyle(color: black, size: 15)),
                        TextSpan(
                            text: "មុខងារខាងលើ",
                            style:
                                TextStyle(color: warningColor, fontSize: 15)),
                      ]),
                    ),
                  ),
                  10.height,
                  Center(
                    child: RichText(
                      textAlign: TextAlign.left,
                      softWrap: true,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                            text:
                                "You can book the handyman by using current location, other location, and saved location by using ",
                            style: secondaryTextStyle(color: black, size: 13)),
                        TextSpan(
                            text: "above functions",
                            style:
                                TextStyle(color: warningColor, fontSize: 13)),
                      ]),
                    ),
                  ),
                  Center(
                    child: CachedImageWidget(
                      url: ic_raod_map,
                      height: 150,
                    ),
                  ),
                  100.height,
                ],
              ),
            ).paddingAll(15),
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
                color: primaryColor,
                child: Text(
                  language.btnNext,
                  style: boldTextStyle(color: white),
                ),
                onTap: () {
                  DontForgetScreen().launch(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
