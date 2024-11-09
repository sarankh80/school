import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ClearBookingAlertDialog extends StatefulWidget {
  final Function()? onAccept;
  final Function()? onKeeping;

  ClearBookingAlertDialog({this.onAccept, this.onKeeping});

  @override
  State<ClearBookingAlertDialog> createState() =>
      _ClearBookingAlertDialogState();
}

class _ClearBookingAlertDialogState extends State<ClearBookingAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          16.height,
          Text(
            '${language.changeBookingAddress}',
            style: boldTextStyle(size: 19),
          ),
          Text(
            '${language.changeBookingAddressCommon}',
            style: primaryTextStyle(size: 15),
            textAlign: TextAlign.center,
          ).paddingAll(16),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppButton(
                text: language.lblNoThank,
                margin: EdgeInsets.only(right: 10),
                color: primaryColor,
                textStyle: boldTextStyle(size: 15, color: Colors.white),
                onTap: () async {
                  finish(context, false);
                },
              ),
              AppButton(
                text: language.lblYesChange,
                margin: EdgeInsets.only(left: 10),
                color: warningColor,
                textStyle: boldTextStyle(size: 15, color: Colors.white),
                onTap: () async {
                  finish(context, true);
                },
              )
            ],
          ),
          6.height,
        ],
      ),
    );
  }
}
