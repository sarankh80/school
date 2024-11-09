import 'package:com.gogospider.booking/component/view_all_label_component.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/screens/dashboard/component/products_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FrequentlyComponent extends StatefulWidget {
  final List<ServiceData> serviceList;
  FrequentlyComponent({required this.serviceList});

  @override
  State<StatefulWidget> createState() => _FrequentlyComponentState();
}

class _FrequentlyComponentState extends State<FrequentlyComponent> {
  @override
  Widget build(BuildContext context) {
    if (widget.serviceList != [])
      return Container();
    else
      return Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ViewAllLabel(
                    label: language.lblFrequentlyAddedTogether,
                    labelSize: 16,
                    onTap: () {
                      // SearchListScreen().launch(context);
                    },
                  ),
                  0.height,
                  HorizontalList(
                    itemCount: widget.serviceList.validate().length,
                    spacing: 16,
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                    itemBuilder: (context, index) {
                      return ProductsWidget(
                          serviceData: widget.serviceList[index],
                          width: context.width() / 1.9);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      );
  }
}
