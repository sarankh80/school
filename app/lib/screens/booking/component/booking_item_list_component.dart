import 'package:com.gogospider.booking/model/booking_data_model.dart';
import 'package:com.gogospider.booking/screens/booking/component/booking_item.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';

class BookingItemListComponent extends StatelessWidget {
  final BookingData bookingData;
  final bool isShowViewAll;

  BookingItemListComponent(
      {required this.bookingData, this.isShowViewAll = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(bottom: 16),
      width: context.width(),
      decoration: BoxDecoration(
          border: Border.all(color: context.dividerColor),
          borderRadius: radius(),
          color: context.cardColor),
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${language.item}',
                                style: boldTextStyle(size: 15)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${language.qty}',
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
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${language.amount}',
                              style: boldTextStyle(size: 15),
                              maxLines: 2,
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ).paddingAll(5),
                5.height,
                Divider(
                  height: 1,
                  thickness: 0.5,
                ),
                5.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: isShowViewAll == true
                              ? bookingData.items!.length
                              : (bookingData.items!.length > 2
                                  ? 2
                                  : bookingData.items!.length),
                          itemBuilder: (context, index) {
                            return BookingItems(
                              bookingItem: bookingData.items![index],
                            );
                          }),
                    ).expand()
                  ],
                ),
                if (isShowViewAll == false && bookingData.items!.length > 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${language.viewAllItems} (${bookingData.items!.length})',
                                style: primaryTextStyle(
                                    size: 15, color: verifyAcColor),
                                // overflow: TextOverflow.fade,
                                maxLines: 2,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).paddingAll(5),
              ],
            ).paddingAll(5),
          ),
        ],
      ),
    );
  }
}
