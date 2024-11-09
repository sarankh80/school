import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/component/price_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/screens/booking/component/booking_service_location_filter.dart';
import 'package:com.gogospider.booking/screens/service/detail_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ProductsWidget extends StatefulWidget {
  final CategoriesData? categoryData;
  final ServiceData? serviceData;
  final double? width;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;

  final bool isFavouriteService;

  ProductsWidget(
      {this.serviceData,
      this.categoryData,
      this.width,
      this.isBorderEnabled,
      this.isFavouriteService = false,
      this.onUpdate});

  @override
  ProductsWidgettState createState() => ProductsWidgettState();
}

class ProductsWidgettState extends State<ProductsWidget> {
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
        if (getDoubleAsync(BOOKING_LATITUDE) != 0.00 &&
            getDoubleAsync(BOOKING_LONGITUDE) != 0.00) {
          ViewDetail(
                  service: widget.serviceData,
                  serviceId: widget.serviceData!.id)
              .launch(context);
        } else {
          BookingServiceLocationFilter(
                  categoryData: widget.categoryData,
                  isCat: 2,
                  serviceData: widget.serviceData)
              .launch(context);
        }
      },
      child: Container(
        // padding: EdgeInsets.all(8),
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(12),
          backgroundColor: context.scaffoldBackgroundColor,
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
                  widget.width.validate() + (widget.width.validate() * 0.05),
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
                  if (widget.serviceData!.discount.validate() != 0)
                    Positioned(
                      right: 0,
                      top: 10,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: boxDecorationWithShadow(
                          backgroundColor: Colors.green,
                        ),
                        child: Text(
                          '${widget.serviceData!.discount.validate().toInt()}% ${language.lblOff}',
                          style: boldTextStyle(color: Colors.white, size: 16),
                        ),
                      ),
                    ),
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
                  // Positioned(
                  //   bottom: -12,
                  //   right: 12,
                  //   child: Container(
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  //     decoration: boxDecorationWithShadow(
                  //       backgroundColor: primaryColor,
                  //       borderRadius: radius(5),
                  //       border: Border.all(color: crimson, width: 1),
                  //     ),
                  //     child: InkWell(
                  //       onTap: () {
                  //         showModalBottomSheet(
                  //           backgroundColor: Colors.transparent,
                  //           context: context,
                  //           isScrollControlled: true,
                  //           isDismissible: false,
                  //           constraints: BoxConstraints(
                  //               maxHeight:
                  //                   MediaQuery.of(context).size.height - 16),
                  //           shape: RoundedRectangleBorder(
                  //               borderRadius:
                  //                   radiusOnly(topLeft: 15, topRight: 15)),
                  //           builder: (BuildContext context) {
                  //             return DetailComponent(
                  //               serviceId: widget.serviceData!.id.validate(),
                  //             );
                  //           },
                  //         );
                  //       },
                  //       child: Text(
                  //         language.lblAddToCart,
                  //         style: boldTextStyle(size: 13, color: white),
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                Container(
                    child: Text(
                  widget.serviceData!.description.validate(),
                  style:
                      secondaryTextStyle(size: 13, color: textSecondaryColor),
                  maxLines: 1,
                )),
                2.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Expanded(
                    //   child: Text(
                    //     language.lblPrice + ": ",
                    //     style: boldTextStyle(
                    //       size: 14,
                    //     ),
                    //     maxLines: 1,
                    //   ),
                    // ),
                    Expanded(
                      child: PriceWidget(
                        price: widget.serviceData!.price.validate(),
                        isHourlyService: widget.serviceData!.isHourlyService,
                        color: context.primaryColor,
                        hourlyTextColor: Colors.white,
                        size: 18,
                      ),
                    ),
                    if (widget.serviceData!.discount.validate() > 0)
                      Expanded(
                        child:
                            // if (widget.serviceData!.discount.validate() != 0)
                            //   Text(
                            //     '(${widget.serviceData!.discount.validate()}% ${language.lblOff})',
                            //     style: boldTextStyle(color: Colors.green, size: 14),
                            //   ),

                            Container(
                          alignment: Alignment.bottomRight,
                          child: PriceWidget(
                            price: widget.serviceData!.basePrice.validate(),
                            isHourlyService:
                                widget.serviceData!.isHourlyService,
                            color: textSecondaryColor,
                            hourlyTextColor: Colors.white,
                            size: 14,
                            isLineThroughEnabled: true,
                          ),
                        ),
                      ),
                    // Spacer(),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    //   decoration: boxDecorationWithShadow(
                    //     backgroundColor: white,
                    //     borderRadius: radius(15),
                    //     border: Border.all(color: lightGray, width: 1),
                    //   ),
                    //   child: InkWell(
                    //     onTap: () {
                    //       showModalBottomSheet(
                    //         backgroundColor: Colors.transparent,
                    //         context: context,
                    //         isScrollControlled: true,
                    //         isDismissible: false,
                    //         constraints: BoxConstraints(
                    //             maxHeight:
                    //                 MediaQuery.of(context).size.height - 16),
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius:
                    //                 radiusOnly(topLeft: 15, topRight: 15)),
                    //         builder: (BuildContext context) {
                    //           return DetailComponent(
                    //             serviceId: widget.serviceData!.id.validate(),
                    //           );
                    //         },
                    //       );
                    //     },
                    //     child: Text(
                    //       "3 " + language.lblOption,
                    //       style: secondaryTextStyle(size: 9, color: darkBlue),
                    //     ),
                    //   ),
                    // ),
                    // 5.width
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
