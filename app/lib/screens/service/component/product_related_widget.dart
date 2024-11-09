import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/component/price_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/screens/service/detail_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductRelatedWidget extends StatefulWidget {
  final ServiceData? serviceData;
  final double? width;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;

  final bool isFavouriteService;

  ProductRelatedWidget(
      {this.serviceData,
      this.width,
      this.isBorderEnabled,
      this.isFavouriteService = false,
      this.onUpdate});

  @override
  ProductRelatedState createState() => ProductRelatedState();
}

class ProductRelatedState extends State<ProductRelatedWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ViewDetail(
                service: widget.serviceData, serviceId: widget.serviceData!.id)
            .launch(context);
      },
      child: Container(
        // padding: EdgeInsets.all(8),
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(12),
          backgroundColor: context.cardColor,
          border: widget.isBorderEnabled.validate(value: false)
              ? appStore.isDarkMode
                  ? Border.all(color: context.dividerColor)
                  : null
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
              offset: Offset(0, 0), // Shadow position
            ),
          ],
        ),
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height:
                  widget.width.validate() + (widget.width.validate() * 0.001),
              width: widget.width,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    // color: Colors.black12,
                    child: CachedImageWidget(
                      url: widget.isFavouriteService
                          ? widget.serviceData!.serviceAttachments
                                  .validate()
                                  .isNotEmpty
                              ? widget.serviceData!.serviceAttachments!.first
                                  .validate()
                              : ''
                          : widget.serviceData!.attachments
                                  .validate()
                                  .isNotEmpty
                              ? widget.serviceData!.attachments!.first
                                  .validate()
                              : '',
                      fit: BoxFit.fill,
                      height: widget.width.validate() +
                          (widget.width.validate() * 0.05),
                      width: widget.width,
                      circle: false,
                    ),
                  ).cornerRadiusWithClipRRectOnly(topLeft: 12, topRight: 12),
                  if (widget.isFavouriteService)
                    Positioned(
                      top: 10,
                      right: 0,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: boxDecorationWithShadow(
                            boxShape: BoxShape.circle,
                            backgroundColor: context.cardColor),
                        child: widget.serviceData!.isFavourite == false
                            ? ic_fill_heart.iconImage(
                                color: favouriteColor, size: 18)
                            : ic_heart.iconImage(
                                color: unFavouriteColor, size: 18),
                      ).onTap(() async {
                        if (widget.serviceData!.isFavourite == false) {
                          widget.serviceData!.isFavourite = false;
                          setState(() {});
                          await removeToWishList(
                                  serviceId: widget.serviceData!.serviceId
                                      .validate()
                                      .toInt())
                              .then((value) {
                            if (!value) {
                              widget.serviceData!.isFavourite = false;
                              setState(() {});
                            }
                          });
                        } else {
                          widget.serviceData!.isFavourite = false;
                          setState(() {});

                          await addToWishList(
                                  serviceId: widget.serviceData!.serviceId
                                      .validate()
                                      .toInt())
                              .then((value) {
                            if (!value) {
                              widget.serviceData!.isFavourite = false;
                              setState(() {});
                            }
                          });
                        }
                        widget.onUpdate?.call();
                      }),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 10.height,
                Marquee(
                  directionMarguee: DirectionMarguee.oneDirection,
                  child: Text(widget.serviceData!.name.validate(),
                      style: boldTextStyle(size: 15)),
                ),
                2.height,
                2.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      language.lblPrice,
                      style: boldTextStyle(
                        size: 13,
                      ),
                      maxLines: 1,
                    ),
                    3.width,
                    PriceWidget(
                      price: widget.serviceData!.price.validate(),
                      isHourlyService: widget.serviceData!.isHourlyService,
                      color: context.primaryColor,
                      hourlyTextColor: Colors.white,
                      size: 13,
                    ),
                    3.width,
                    if (widget.serviceData!.discount.validate() != 0)
                      Text(
                        '(${widget.serviceData!.discount.validate()}% ${language.lblOff})',
                        style: boldTextStyle(color: Colors.green, size: 9),
                      ),
                    Spacer(),
                    5.width
                  ],
                ),
                6.height,
              ],
            ).paddingAll(8),
          ],
        ),
      ),
    );
  }
}
