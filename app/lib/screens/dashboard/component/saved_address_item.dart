import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';

class SavedAddressItemComponent extends StatelessWidget {
  final SavedAddress adress;

  SavedAddressItemComponent({required this.adress});

  @override
  Widget build(BuildContext context) {
    log("Selected : ${adress.isSelected}");
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        // margin: EdgeInsets.only(bottom: 16),
        width: context.width(),
        decoration: BoxDecoration(
          border: Border.all(
              color: (adress.isSelected == true &&
                      (appStore.isCurrentLocation == false &&
                          appStore.isCustomeLocation == true))
                  ? cardColor
                  : context.dividerColor),
          borderRadius: radius(),
          color: (adress.isSelected == true &&
                  (appStore.isCurrentLocation == false &&
                      appStore.isCustomeLocation == true))
              ? Colors.red[100]
              : context.scaffoldBackgroundColor,
        ),
        child: Row(
          children: [
            Expanded(
                child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //         alignment: Alignment.centerLeft,
                  //         child: adress.image != null
                  //             ? !Utility.validUrl(adress.image.validate())
                  //                 ? ClipRRect(
                  //                     borderRadius: BorderRadius.circular(22.5),
                  //                     child: Utility.imageFromBase64String(
                  //                         adress.image.validate(),
                  //                         45,
                  //                         45,
                  //                         BoxFit.fill),
                  //                   )
                  //                 : CachedImageWidget(
                  //                     url: adress.image.validate(),
                  //                     height: 45,
                  //                     width: 45,
                  //                     fit: BoxFit.fill,
                  //                   ).cornerRadiusWithClipRRect(45)
                  //             : Image.asset(appLogo,
                  //                 height: 45, width: 45, fit: BoxFit.cover)),
                  //     6.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${adress.title}",
                        textAlign: TextAlign.left,
                        style: boldTextStyle(
                          size: 15,
                        ),
                      ),
                      if (adress.isDefault == 1)
                        Text(
                          '${language.defaultAddress}',
                          textAlign: TextAlign.left,
                          style:
                              secondaryTextStyle(size: 13, color: warningColor),
                        )
                    ],
                  ),
                  //   ],
                  // ),
                  // 5.height,
                  Text(
                    "${adress.address}",
                    textAlign: TextAlign.left,
                    style: primaryTextStyle(size: 14),
                  ),
                ],
              ),
            )),
            if (adress.isSelected == true &&
                (appStore.isCurrentLocation == false &&
                    appStore.isCustomeLocation == true))
              RoundedCheckBox(
                borderColor: context.primaryColor,
                checkedColor: context.primaryColor,
                isChecked: true,
                textStyle: secondaryTextStyle(),
                size: 20,
              ),
          ],
        ));
  }
}
