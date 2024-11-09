import 'package:com.gogospider.booking/component/view_all_label_component.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/screens/booking/component/booking_service_location_filter.dart';
import 'package:com.gogospider.booking/screens/dashboard/component/menu_componentList.dart';
import 'package:com.gogospider.booking/screens/dashboard/component/products_widget.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SericesComponent extends StatefulWidget {
  final List<ServiceData> serviceList;
  final List<CategoriesData>? categoryList;

  SericesComponent({required this.serviceList, this.categoryList});

  @override
  State<StatefulWidget> createState() => _SericesComponentState();
}

class _SericesComponentState extends State<SericesComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ViewAllLabel(
                  labelSize: 17,
                  label: language.service,
                  list: widget.serviceList,
                  onTap: () {
                    // SearchListScreen().launch(context);
                    if (getDoubleAsync(BOOKING_LATITUDE) != 0.00 &&
                        getDoubleAsync(BOOKING_LONGITUDE) != 0.00) {
                      // SearchListScreen().launch(context);
                      MenuComponentList(
                              categoryList: widget.categoryList, id: 2)
                          .launch(context);
                    } else {
                      BookingServiceLocationFilter(
                              categoryData: widget.categoryList![1], isCat: 1)
                          .launch(context);
                    }
                  },
                ),
                0.height,
                HorizontalList(
                  itemCount: widget.serviceList.validate().length,
                  spacing: 16,
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                  itemBuilder: (context, index) {
                    return ProductsWidget(
                        isBorderEnabled: true,
                        categoryData: widget.categoryList![1],
                        serviceData: widget.serviceList[index],
                        width: context.width() / 1.7);
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
