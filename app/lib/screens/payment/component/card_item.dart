import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/cached_image_widget.dart';
import '../../../main.dart';
import '../../../model/credit_card_model.dart';
import '../../../utils/images.dart';

class CardItemComponent extends StatelessWidget {
  final CareditCardData cardData;

  CardItemComponent({required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        // margin: EdgeInsets.only(bottom: 16),
        width: context.width(),
        decoration: BoxDecoration(
          border: Border.all(
              color: cardData.isSelected == true
                  ? context.primaryColor
                  : context.scaffoldBackgroundColor),
          borderRadius: radius(),
          color: context.scaffoldBackgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(16),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: context.cardColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cardData.icon != null
                      ? CachedImageWidget(
                          url: '',
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                          radius: 60,
                        )
                      : Image.asset(ic_credit_card,
                          height: 27, width: 45, fit: BoxFit.cover)
                ],
              ),
            ),
            16.width,
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  5.height,
                  Text(
                    '${cardData.cardNumber.validate()}',
                    style: boldTextStyle(size: 16),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  6.height,
                  Text(
                    '${language.lblExpireOn} ${cardData.expireDate.validate()}',
                    style: secondaryTextStyle(size: 15),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (cardData.isPrimary == 1)
              Expanded(
                child: Container(
                  // color: Colors.red,
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      27.height,
                      Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: boxDecorationWithRoundedCorners(
                            backgroundColor: context.cardColor,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: context.dividerColor)),
                        child: Text(
                          '${language.lblPrimary}',
                          style: boldTextStyle(size: 12),
                          maxLines: 2,
                          textAlign: TextAlign.right,
                        ),
                      )
                    ],
                  ),
                ),
              )
          ],
        ).paddingAll(5));
  }
}
