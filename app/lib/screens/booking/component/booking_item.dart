import 'package:com.gogospider.booking/component/price_widget.dart';
import 'package:com.gogospider.booking/model/booking_data_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingItems extends StatelessWidget {
  final BookingItem bookingItem;
  final bool isShowViewAll;

  BookingItems({required this.bookingItem, this.isShowViewAll = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookingItem.serviceName.validate(),
                      style: primaryTextStyle(size: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      softWrap: true,
                    ),
                    Row(
                      children: [
                        PriceWidget(
                            price: (bookingItem.price.validate() -
                                ((bookingItem.price.validate() *
                                        bookingItem.discount.validate()) /
                                    100)),
                            color: textPrimaryColorGlobal,
                            isHourlyService: false,
                            size: 15,
                            isBoldText: true),
                        if (bookingItem.discount.validate() > 0)
                          PriceWidget(
                              isDiscountedPrice: true,
                              price: bookingItem.price.validate(),
                              color: blueColor,
                              isHourlyService: false,
                              size: 15,
                              isBoldText: true,
                              isLineThroughEnabled: true),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookingItem.quantity.validate().toString(),
                      style: boldTextStyle(size: 15),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PriceWidget(
                        price: bookingItem.total.validate(),
                        color: textPrimaryColorGlobal,
                        isHourlyService: false,
                        size: 15,
                        isBoldText: true),
                  ],
                ),
              ),
            ),
          ],
        ).paddingSymmetric(vertical: 5),
        5.height,
        Divider(
          height: 1,
          thickness: 0.5,
        ),
      ],
    );
  }
}
