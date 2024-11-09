import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AddressTypeItemComponent extends StatefulWidget {
  final List<AddressType>? data;
  final ScrollController scrollController;

  AddressTypeItemComponent({this.data, required this.scrollController});

  @override
  AddressTypeItemComponentState createState() =>
      AddressTypeItemComponentState();
}

class AddressTypeItemComponentState extends State<AddressTypeItemComponent> {
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
    return Container(
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(20), backgroundColor: context.cardColor),
      // padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            8.height,
            Container(width: 40, height: 2, color: gray.withOpacity(0.3))
                .center(),
            15.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language.chooseAddressType,
                    style: boldTextStyle(size: 18)),
              ],
            ).paddingSymmetric(horizontal: 16),
            16.height,
            Divider(
              color: borderColor,
            ),
            // 16.height,
            widget.data!.length != 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.data!.length,
                    itemBuilder: (_, i) {
                      AddressType data = widget.data![i];
                      return GestureDetector(
                        onTap: () {
                          finish(context, data.type);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              child: Text(
                                data.type.validate(),
                                style: boldTextStyle(size: 17),
                              ),
                            ),
                            Divider(
                              color: borderColor,
                            )
                          ],
                        ),
                      );
                    },
                  )
                : Text(language.noDataAvailable).center().paddingAll(16),
          ],
        ),
      ),
    );
  }
}
