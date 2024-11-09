import 'package:com.gogospider.booking/component/price_widget.dart';
import 'package:com.gogospider.booking/model/booking_data_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';

class BookingDetailPriceComponent extends StatelessWidget {
  final BookingData bookingData;
  final bool isShowViewAll;

  BookingDetailPriceComponent(
      {required this.bookingData, this.isShowViewAll = true});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 16),
        width: context.width(),
        decoration: BoxDecoration(
            border: Border.all(color: context.dividerColor),
            borderRadius: radius()),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      '${language.lblSubTotal}',
                      style: primaryTextStyle(),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: PriceWidget(
                          isDiscountedPrice: false,
                          price: bookingData.totalAmount.validate(),
                          color: textPrimaryColorGlobal,
                          size: 15,
                          isBoldText: true,
                          isLineThroughEnabled: false),
                    ))
              ],
            ),
            10.height,
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      '${language.lblDiscount}(${bookingData.discount.validate()}%)',
                      style: primaryTextStyle(),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: PriceWidget(
                          isDiscountedPrice: false,
                          price: (bookingData.discount.validate() *
                              bookingData.totalAmount.validate()),
                          color: primaryColor,
                          size: 15,
                          isBoldText: true,
                          isLineThroughEnabled: false),
                    ))
              ],
            ),
            10.height,
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      '${language.lblTax}(${bookingData.taxes.validate()}%)',
                      style: primaryTextStyle(),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: PriceWidget(
                          isDiscountedPrice: false,
                          price: (bookingData.discount.validate() *
                              bookingData.totalAmount.validate()),
                          color: textPrimaryColorGlobal,
                          size: 15,
                          isBoldText: true,
                          isLineThroughEnabled: false),
                    ))
              ],
            ),
            // 10.height,
            // Row(
            //   children: [
            //     Expanded(
            //         flex: 1,
            //         child: Text(
            //           '${language.lblCoupon}',
            //           style: primaryTextStyle(),
            //         )).onTap(() {
            //       // showInDialog<CouponData>(
            //       //     context,
            //       //     backgroundColor: context.cardColor,
            //       //     contentPadding: EdgeInsets.zero,
            //       //     builder: (p0) {
            //       //       return AppCommonDialog(
            //       //         title: language.lblAvailableCoupons,
            //       //         child: CouponWidget(
            //       //           couponData: bookingData.couponData,
            //       //           appliedCouponData: widget.data.serviceDetail!
            //       //                   .appliedCouponData ??
            //       //               null,
            //       //         ),
            //       //       );
            //       //     },
            //       //   ).then((CouponData? value) {
            //       //     if (value != null) {
            //       //       appliedCouponData = value;
            //       //       getPrice();
            //       //     } else {
            //       //       appliedCouponData = null;
            //       //       widget.data.serviceDetail!.appliedCouponData = null;
            //       //       widget.data.serviceDetail!.couponCode = "";
            //       //       getPrice();
            //       //     }
            //       //   });
            //     }),
            //     Expanded(
            //         flex: 1,
            //         child: Container(
            //           alignment: Alignment.centerRight,
            //           child: PriceWidget(
            //               isDiscountedPrice: false,
            //               price: (bookingData.discount.validate() *
            //                   bookingData.totalAmount.validate()),
            //               color: textPrimaryColorGlobal,
            //               size: 15,
            //               isBoldText: true,
            //               isLineThroughEnabled: false),
            //         ))
            //   ],
            // ),
            10.height,
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      '${language.totalAmount})',
                      style: boldTextStyle(size: 15),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: PriceWidget(
                          isDiscountedPrice: false,
                          price: (bookingData.totalAmount.validate()),
                          color: textPrimaryColorGlobal,
                          size: 15,
                          isBoldText: true,
                          isLineThroughEnabled: false),
                    ))
              ],
            ),
          ],
        ));
  }
}
