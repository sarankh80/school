import 'package:com.gogospider.booking/component/view_all_label_component.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/screens/dashboard/component/cleaning_widget.dart';
import 'package:com.gogospider.booking/screens/service/search_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class InstallationComponent extends StatefulWidget {
  final List<ServiceData> serviceList;

  InstallationComponent({required this.serviceList});

  @override
  State<StatefulWidget> createState() => _InstallationComponentState();
}

class _InstallationComponentState extends State<InstallationComponent> {
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
                  label: language.lblInstallationServices,
                  list: widget.serviceList,
                  onTap: () {
                    SearchListScreen().launch(context);
                  },
                ),
                0.height,
                HorizontalList(
                  itemCount: widget.serviceList.validate().length,
                  spacing: 16,
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                  itemBuilder: (context, index) {
                    return CleaningWidget(
                        isBorderEnabled: true,
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
