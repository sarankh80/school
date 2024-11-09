import 'package:com.gogospider.booking/component/price_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/booking_data_model.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'booking_item_list_component.dart';

class BookingItemComponent extends StatelessWidget {
  final BookingData bookingData;
  final bool showTotal;

  BookingItemComponent({required this.bookingData, this.showTotal = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.only(bottom: 16),
      width: context.width(),
      // decoration: cardDecoration(context),
      decoration: BoxDecoration(
        border: Border.all(color: context.dividerColor),
        borderRadius: radius(),
      ),

      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('#${bookingData.id.validate()}',
                  style: boldTextStyle(color: primaryColor, size: 15)),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                                color: bookingData.statusLabel
                                    .validate()
                                    .getPaymentStatusBackgroundColor
                                    .withOpacity(0.1),
                                borderRadius: radius(8),
                                border: Border.all(
                                    color: bookingData.statusLabel
                                        .validate()
                                        .getPaymentStatusBackgroundColor)),
                            child: Text(
                              bookingData.statusLabel.validate(),
                              style: boldTextStyle(
                                  color: bookingData.statusLabel
                                      .validate()
                                      .getPaymentStatusBackgroundColor,
                                  size: 12),
                            ),
                          ),
                          // _buildEditBookingWidget(),
                        ],
                      ),
                      Text(
                        "${formatDate(bookingData.date.validate(), format: DATE_FORMAT_2)} At ${formatDate(bookingData.date.validate(), format: HOUR_12_FORMAT)}",
                        style: primaryTextStyle(size: 15),
                        maxLines: 2,
                        textAlign: TextAlign.right,
                      ).expand(),
                    ],
                  ),
                  4.height,
                ],
              ).expand(),
            ],
          ).paddingAll(8),
          BookingItemListComponent(
            bookingData: bookingData,
          ).paddingSymmetric(horizontal: 8),
          if (showTotal == true)
            Container(
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: context.cardColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              // margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language.amount, style: secondaryTextStyle()),
                      8.width,
                      PriceWidget(
                        price: bookingData.totalAmount.validate(),
                        color: primaryColor,
                        isHourlyService: bookingData.isHourlyService,
                        size: 15,
                      ),
                    ],
                  ).paddingAll(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language.lblAddress, style: secondaryTextStyle()),
                      8.width,
                      Marquee(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bookingData.address != null &&
                                    bookingData.address!.title !=
                                        "Current Address"
                                ? Text(
                                    bookingData.address!.title.validate(),
                                    style: boldTextStyle(size: 14),
                                  )
                                : SizedBox(),
                            Text(
                              bookingData.address != null
                                  ? bookingData.address!.address.validate()
                                  : language.notAvailable,
                              style: primaryTextStyle(size: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ).flexible(),
                    ],
                  ).paddingAll(8),
                  if (bookingData.handyman.validate().isNotEmpty)
                    Column(
                      children: [
                        // Divider(height: 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language.textHandyman,
                                style: secondaryTextStyle()),
                            Text(
                                    bookingData.handyman
                                        .validate()
                                        .first
                                        .handyman!
                                        .displayName
                                        .validate(),
                                    style: boldTextStyle(size: 14))
                                .flexible(),
                          ],
                        ).paddingAll(8),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(language.payment, style: secondaryTextStyle()),
                      8.width,
                      Text(
                        '${bookingData.paymentStatus.validate() != '' ? bookingData.paymentStatus.validate() : language.unPaid}',
                        style: primaryTextStyle(color: primaryColor, size: 15),
                        overflow: TextOverflow.fade,
                      )
                    ],
                  ).paddingAll(8),
                ],
              ).paddingSymmetric(horizontal: 8),
            ).paddingOnly(left: 10, right: 10, bottom: 10)
        ],
      ),
    );
  }
}
