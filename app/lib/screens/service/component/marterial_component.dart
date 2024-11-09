import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class MarterialComponent extends StatefulWidget {
  final List<ServiceData> marterialList;
  MarterialComponent({required this.marterialList});
  @override
  State<StatefulWidget> createState() => _MarterialComponentState();
}

class _MarterialComponentState extends State<MarterialComponent> {
  @override
  Widget build(BuildContext context) {
    if (widget.marterialList.isEmpty)
      return Container();
    else
      return Container(
        child: Column(
          children: [
            10.height,
            Container(
              width: context.width(),
              height: 5,
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 215, 215),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16, top: 10),
              child: Text(
                language.lblOurMarterialRate,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: appStore.isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            Container(
              width: context.width(),
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: appStore.isDarkMode
                                ? Colors.white
                                : Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 5),
                          child: Text(
                            language.item,
                            style: boldTextStyle(
                                color: appStore.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 5),
                          child: Text(
                            language.lblUnit,
                            style: boldTextStyle(
                                color: appStore.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 5),
                          child: Text(
                            language.lblPrice,
                            style: boldTextStyle(
                                color: appStore.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ]),
                  for (var rowData in widget.marterialList)
                    TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: appStore.isDarkMode
                                ? Colors.white
                                : Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            rowData.name!,
                            style: TextStyle(
                                fontSize: 15.0,
                                color: appStore.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            rowData.unit!,
                            style: TextStyle(
                                fontSize: 15.0,
                                color: appStore.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Text(
                            "${isCurrencyPositionLeft ? appStore.currencySymbol : ''}${rowData.price.validate().toStringAsFixed(DECIMAL_POINT).formatNumberWithComma()}${isCurrencyPositionRight ? appStore.currencySymbol : ''}",
                            style: TextStyle(
                                fontSize: 15.0,
                                color: appStore.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
            10.height,
          ],
        ),
      );
  }
}
