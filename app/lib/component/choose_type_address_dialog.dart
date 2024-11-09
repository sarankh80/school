import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ChooseTypeAddressDialog extends StatefulWidget {
  final Function()? onAccept;

  ChooseTypeAddressDialog({this.onAccept});

  @override
  State<ChooseTypeAddressDialog> createState() =>
      _ChooseTypeAddressDialogState();
}

class _ChooseTypeAddressDialogState extends State<ChooseTypeAddressDialog> {
  List<AddressType>? addressType = [
    AddressType(type: "Home", selected: true),
    AddressType(type: "Condo", selected: false),
    AddressType(type: "Company", selected: false),
    AddressType(type: "Organization", selected: false)
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: addressType?.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              AddressType value = addressType![index];
              return Container(
                  alignment: Alignment.centerLeft,
                  color: context.cardColor,
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  child: Text(value.type.validate()).onTap(() {
                    setState(() {
                      addressType!
                          .forEach((element) => element.selected = false);
                      value.selected = true;
                    });
                    finish(context);
                  }));
            },
          ),
        ));
  }
}
