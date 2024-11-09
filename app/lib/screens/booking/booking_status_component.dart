import 'package:async/async.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../model/booking_status_model.dart';
import '../../network/rest_apis.dart';

class BookingStatusComponent extends StatefulWidget {
  final String? defaultValue;
  final Function(BookingStatusResponse value) onValueChanged;
  final ScrollController scrollController;
  final bool isValidate;

  BookingStatusComponent(
      {this.defaultValue,
      required this.onValueChanged,
      required this.scrollController,
      required this.isValidate});

  @override
  BookingStatusComponentState createState() => BookingStatusComponentState();
}

class BookingStatusComponentState extends State<BookingStatusComponent> {
  BookingStatusResponse? selectedData;
  String? defaultValue;
  AsyncMemoizer<List<BookingStatusResponse>> _asyncMemoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
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
          return Container(
            decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(20), backgroundColor: context.cardColor),
            // padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  8.height,
                  Container(width: 40, height: 2, color: gray.withOpacity(0.3))
                      .center(),
                  24.height,
                  snap.data!.length != 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snap.data!.length,
                          itemBuilder: (_, i) {
                            BookingStatusResponse data = snap.data![i];
                            return Container(
                                decoration: BoxDecoration(
                                    color: context.cardColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                            data.id == 0 ? 15 : 0),
                                        topRight: Radius.circular(
                                            data.id == 0 ? 15 : 0))),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        // Icon(
                                        //   Icons.list_alt,
                                        //   color: textPrimaryColorGlobal,
                                        //   size: 30,
                                        // ),
                                        10.width,
                                        Text('${data.label}',
                                            style: boldTextStyle(
                                                color: textPrimaryColorGlobal,
                                                size: 15)),
                                      ],
                                    ).onTap(() {
                                      log('data: ${data.label}');
                                      widget.onValueChanged.call(data);
                                      Navigator.pop(context);
                                    }).paddingAll(15),
                                    Divider(
                                      height: 0.5,
                                      thickness: 0.5,
                                    ),
                                  ],
                                ));
                          },
                        )
                      : Text(language.noDataAvailable).center().paddingAll(16),
                ],
              ),
            ),
          );
        }
        return snapWidgetHelper(snap,
            defaultErrorMessage: "", loadingWidget: Offstage());
      },
    );
  }
}
