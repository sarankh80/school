// import 'dart:html';

import 'package:async/async.dart';
// import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/booking_status_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
// import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class StatusBottomSheetComponent extends StatefulWidget {
  final String? defaultValue;
  final Function(BookingStatusResponse value) onValueChanged;
  final bool isValidate;

  StatusBottomSheetComponent(
      {this.defaultValue,
      required this.onValueChanged,
      required this.isValidate});

  @override
  _StatusBottomSheetComponentState createState() =>
      _StatusBottomSheetComponentState();
}

class _StatusBottomSheetComponentState
    extends State<StatusBottomSheetComponent> {
  BookingStatusResponse? selectedData;
  String? defaultValue;

  AsyncMemoizer<List<BookingStatusResponse>> _asyncMemoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookingStatusResponse>>(
      future: _asyncMemoizer.runOnce(() => bookingStatus()),
      builder: (context, snap) {
        if (snap.hasData) {
          if (!snap.data!.any((element) => element.id == 0)) {
            snap.data!.insert(
                0,
                BookingStatusResponse(
                    label: BOOKING_TYPE_ALL,
                    id: 0,
                    status: 0,
                    value: BOOKING_TYPE_ALL));
            selectedData = snap.data!.first;
          }
          return ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: snap.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    decoration: BoxDecoration(
                        color: selectedData?.id == snap.data![index].id
                            ? Colors.grey[100]
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                                snap.data![index].id == 0 ? 15 : 0),
                            topRight: Radius.circular(
                                snap.data![index].id == 0 ? 15 : 0))),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.list_alt,
                              color: appTextPrimaryColor,
                              size: 30,
                            ),
                            10.width,
                            Text('${snap.data![index].label}',
                                style: boldTextStyle(
                                    color: appTextPrimaryColor, size: 15)),
                          ],
                        ).onTap(() {
                          log('data: ${snap.data![index].label}');
                          widget.onValueChanged.call(snap.data![index]);
                          Navigator.pop(context);
                        }).paddingAll(15),
                        Divider(
                          height: 3,
                          thickness: 1,
                          color: Colors.grey[100],
                        ),
                      ],
                    ));
              });
        }

        return snapWidgetHelper(snap,
            defaultErrorMessage: "", loadingWidget: Offstage());
      },
    );
  }
}
