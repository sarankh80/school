// ignore_for_file: unnecessary_statements

import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/component/price_widget.dart';
import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/cart_model.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/auth/sign_in_screen.dart';
import 'package:com.gogospider.booking/screens/cart/plus_minus_button.dart';
import 'package:com.gogospider.booking/screens/service/detail_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ServiceComponent extends StatefulWidget {
  final ServiceData? serviceData;
  final double? width;
  final bool? isBorderEnabled;
  final VoidCallback? onUpdate;

  final bool isFavouriteService;

  ServiceComponent(
      {this.serviceData,
      this.width,
      this.isBorderEnabled,
      this.isFavouriteService = false,
      this.onUpdate});

  @override
  ServiceComponentState createState() => ServiceComponentState();
}

class ServiceComponentState extends State<ServiceComponent> {
  DBHelper dbHelper = DBHelper();
  bool isAddCart = false;
  int count = 1;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final getCart = dbHelper.getCartList();
    getCart.toString();
    // setValue('isButtonEnabled', false);
    // context.read<CartProvider>().getData();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    int? serviceId = widget.serviceData!.id! > 0 ? widget.serviceData!.id : 0;
    // int? plus = 0;
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        ViewDetail(service: widget.serviceData, serviceId: serviceId)
            .launch(context);
        // ServiceDetailScreen(
        //         serviceId: widget.isFavouriteService
        //             ? widget.serviceData!.serviceId.validate().toInt()
        //             : widget.serviceData!.id.validate())
        //     .launch(context);
      },
      child: Container(
        decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(),
          backgroundColor: appStore.isDarkMode
              ? context.scaffoldBackgroundColor
              : Colors.white,
          border: widget.isBorderEnabled.validate(value: false)
              ? appStore.isDarkMode
                  ? Border.all(color: context.dividerColor)
                  : null
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 0), // Shadow position
            ),
          ],
        ),
        width: widget.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // height: 100,
              // width: context.width(),
              height:
                  widget.width.validate() + (widget.width.validate() * 0.0001),
              width: context.width(),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CachedImageWidget(
                    url: widget.isFavouriteService
                        ? widget.serviceData!.serviceAttachments
                                .validate()
                                .isNotEmpty
                            ? widget.serviceData!.serviceAttachments!.first
                                .validate()
                            : ''
                        : widget.serviceData!.attachments.validate().isNotEmpty
                            ? widget.serviceData!.attachments!.first.validate()
                            : '',
                    fit: BoxFit.fill,
                    height: widget.width.validate() +
                        (widget.width.validate() * 0.05),
                    width: context.width(),
                    circle: false,
                  ).cornerRadiusWithClipRRect(8),
                  if (widget.serviceData!.discount.validate() != 0)
                    Positioned(
                      right: 0,
                      top: 5,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: boxDecorationWithShadow(
                          backgroundColor: Colors.green,
                        ),
                        child: Text(
                          '${widget.serviceData!.discount.validate().toInt()}% ${language.lblOff}',
                          style: boldTextStyle(color: Colors.white, size: 14),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Marquee(
                  animationDuration: Duration(milliseconds: 6000),
                  directionMarguee: DirectionMarguee.oneDirection,
                  child: Text(widget.serviceData!.name.validate(),
                      style: boldTextStyle(size: 15)),
                ),
                1.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: PriceWidget(
                        price: widget.serviceData!.price.validate(),
                        isHourlyService: widget.serviceData!.isHourlyService,
                        color: primaryColor,
                        hourlyTextColor: Colors.white,
                        size: 14,
                      ),
                    ),
                    // if (widget.serviceData!.discount.validate() > 0) Text("-"),
                    // if (widget.serviceData!.discount.validate() != 0)
                    //   Text(
                    //     '(${widget.serviceData!.discount.validate()}% ${language.lblOff})',
                    //     style: boldTextStyle(color: Colors.green, size: 13),
                    //   ),
                    if (widget.serviceData!.discount.validate() > 0)
                      Expanded(
                        child: Container(
                          alignment: Alignment.topRight,
                          child: PriceWidget(
                            price: widget.serviceData!.basePrice.validate(),
                            isHourlyService:
                                widget.serviceData!.isHourlyService,
                            color: appTextSecondaryColor,
                            hourlyTextColor: Colors.white,
                            size: 14,
                            isLineThroughEnabled: true,
                          ),
                        ),
                      ),
                  ],
                ),
                5.height,
                FutureBuilder<List<Cart>>(
                  future: dbHelper.getCartId(serviceId!),
                  builder: (context, value) {
                    if (value.hasData) {
                      if (value.data!.length != 0)
                        return Container(
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(),
                            backgroundColor: appStore.isDarkMode
                                ? context.cardColor
                                : context.primaryColor,
                            border: widget.isBorderEnabled
                                    .validate(value: false)
                                ? appStore.isDarkMode
                                    ? Border.all(color: Colors.white, width: 2)
                                    : null
                                : Border.all(
                                    color: Colors.red,
                                    width: 1.5,
                                  ),
                          ),
                          // height: 32,
                          child: ValueListenableBuilder<int>(
                            valueListenable: ValueNotifier(
                                value.data!.first.quantity!.value),
                            builder: (index, int val, child) {
                              return PlusMinusButtons(
                                conditoin: 1,
                                addQuantity: () {
                                  cart.addQty(value.data!.first);
                                  ///////////// Update Cart Form API .//////////
                                  // cart.addQuantity(value.data![plus].id!);
                                  // dbHelper
                                  //     .updateQuantity(Cart(
                                  //         id: value.data![plus].id,
                                  //         productId: serviceId,
                                  //         productName:
                                  //             value.data![plus].productName,
                                  //         initialPrice:
                                  //             value.data![plus].initialPrice,
                                  //         productPrice:
                                  //             value.data![plus].productPrice,
                                  //         quantity: ValueNotifier(value
                                  //                 .data![plus].quantity!.value +
                                  //             1),
                                  //         unitTag: value.data![plus].image,
                                  //         image: ''))
                                  //     .then((values) {
                                  //   setState(() {
                                  //     cart.addQuantityApi(
                                  //         value.data![plus].id!,
                                  //         value.data![plus].quantity!.value
                                  //             .toInt());
                                  //     plus + val;
                                  //     cart.addTotalPrice(double.parse(value
                                  //         .data![plus].quantity!.value
                                  //         .toString()));
                                  //   });
                                  // });
                                  // cart.addQuantityNolist(
                                  //     value.data![plus].id.validate());
                                  ////////////// End Update Cart From API //////
                                },
                                deleteQuantity: () {
                                  cart.deleteQty(value.data!.first);
                                  //////////////// Delete Cart Id From API /////
                                  // setState(() {
                                  //   if ((value.data![plus].quantity!.value) >
                                  //       1) {
                                  // dbHelper
                                  //     .updateQuantity(Cart(
                                  //         id: value.data![plus].id,
                                  //         productId: serviceId,
                                  //         productName:
                                  //             value.data![plus].productName,
                                  //         initialPrice: value
                                  //             .data![plus].initialPrice,
                                  //         productPrice: value
                                  //             .data![plus].productPrice,
                                  //         quantity: ValueNotifier(value
                                  //                 .data![plus]
                                  //                 .quantity!
                                  //                 .value -
                                  //             1),
                                  //         unitTag: value.data![plus].image,
                                  //         image: ''))
                                  //     .then((values) {
                                  //   setState(() {
                                  //     cart.addTotalPrice(double.parse(value
                                  //         .data![plus].quantity!.value
                                  //         .toString()));
                                  //     cart.deleteQuantityApi(
                                  //         value.data![plus].id!,
                                  //         value.data![plus].quantity!.value
                                  //             .toInt());
                                  //     cart.deleteQuantityNolist(
                                  //         widget.serviceData!.id!);
                                  //     cart.removeTotalPrice(double.parse(
                                  //         widget.serviceData!.price
                                  //             .toString()));
                                  //   });
                                  // });
                                  //   }
                                  // });
                                  //////////////// End Delect Id from API //////
                                },
                                text: val.toString(),
                              );
                            },
                          ),
                        );
                      else
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: context.cardColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: context.primaryColor,
                                      spreadRadius: 1),
                                ],
                              ),
                              child: Row(children: [
                                ic_plus
                                    .iconImage(size: 12, color: primaryColor)
                                    .center(),
                                3.width,
                                Text(
                                  language.addToCart,
                                  style: boldTextStyle(
                                      size: 13, color: primaryColor),
                                )
                              ]),
                            ).onTap(() {
                              appStore.isLoggedIn
                                  ? setState(() {
                                      setValue('isButtonEnabled', true);
                                      cart.insertData(widget.serviceData!);
                                      ///////// Add New Cart From API //////////
                                      // Map? requset = {
                                      //   "quantity": 1,
                                      //   "product_id": serviceId
                                      // };
                                      // insertCartResponse(requset, serviceId)
                                      //     .then((data) {
                                      //   setValue(
                                      //       'total_price', data.grandTotal);
                                      //   var item = data.items!.firstWhere(
                                      //       (element) =>
                                      //           element.productId == serviceId);
                                      // dbHelper
                                      //     .insert(
                                      //   Cart(
                                      //     id: item.id,
                                      //     productId:
                                      //         widget.serviceData!.id!.toInt(),
                                      //     productName:
                                      //         widget.serviceData!.name,
                                      //     initialPrice: widget
                                      //         .serviceData!.price!
                                      //         .toDouble(),
                                      //     productPrice: widget
                                      //         .serviceData!.price!
                                      //         .toDouble(),
                                      //     quantity: ValueNotifier(1),
                                      //     unitTag: widget.serviceData!.unit,
                                      //     image: widget.isFavouriteService
                                      //         ? widget.serviceData!
                                      //                 .serviceAttachments
                                      //                 .validate()
                                      //                 .isNotEmpty
                                      //             ? widget
                                      //                 .serviceData!
                                      //                 .serviceAttachments!
                                      //                 .first
                                      //                 .validate()
                                      //             : ''
                                      //         : widget.serviceData!
                                      //                 .attachments
                                      //                 .validate()
                                      //                 .isNotEmpty
                                      //             ? widget.serviceData!
                                      //                 .attachments!.first
                                      //                 .validate()
                                      //             : '',
                                      //   ),
                                      // )
                                      //     .then((value) {
                                      //   context
                                      //       .read<CartProvider>()
                                      //       .getData();
                                      //   if (value.id.toString() != "") {
                                      //     cart.addTotalPrice(widget
                                      //         .serviceData!.price!
                                      //         .toDouble());
                                      //     cart.addCounter();
                                      //     getIntAsync("cart_items");
                                      //   }
                                      // });
                                      // }).onError((error, stackTrace) {
                                      //   print(error.toString());
                                      // });
                                      ////////// End New Add Cart From API /////
                                    })
                                  : SignInScreen().launch(context);
                            }),
                          ],
                        );
                    } else {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!isAddCart)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: context.cardColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: context.primaryColor,
                                      spreadRadius: 1),
                                ],
                              ),
                              child: Row(children: [
                                ic_plus
                                    .iconImage(size: 12, color: primaryColor)
                                    .center(),
                                3.width,
                                Text(
                                  language.addToCart,
                                  style: boldTextStyle(
                                      size: 13, color: primaryColor),
                                )
                              ]),
                            ).onTap(() {
                              appStore.isLoggedIn
                                  ? setState(() {
                                      isAddCart = true;
                                      setValue('isButtonEnabled', true);
                                      cart.insertData(widget.serviceData!);
                                      //////// Add New Cart API ////////////////
                                      // Map? requset = {
                                      //   "quantity": 1,
                                      //   "product_id": serviceId
                                      // };
                                      // insertCartResponse(requset, serviceId)
                                      //     .then((data) {
                                      //   setValue(
                                      //       'total_price', data.grandTotal);
                                      //   var item = data.items!.firstWhere(
                                      //       (element) =>
                                      //           element.productId == serviceId);
                                      //   dbHelper
                                      //       .insert(
                                      //     Cart(
                                      //       id: item.id,
                                      //       productId:
                                      //           widget.serviceData!.id!.toInt(),
                                      //       productName:
                                      //           widget.serviceData!.name,
                                      //       initialPrice: widget
                                      //           .serviceData!.price!
                                      //           .toDouble(),
                                      //       productPrice: widget
                                      //           .serviceData!.price!
                                      //           .toDouble(),
                                      //       quantity: ValueNotifier(1),
                                      //       unitTag: widget.serviceData!.unit,
                                      //       image: widget.isFavouriteService
                                      //           ? widget.serviceData!
                                      //                   .serviceAttachments
                                      //                   .validate()
                                      //                   .isNotEmpty
                                      //               ? widget
                                      //                   .serviceData!
                                      //                   .serviceAttachments!
                                      //                   .first
                                      //                   .validate()
                                      //               : ''
                                      //           : widget.serviceData!
                                      //                   .attachments
                                      //                   .validate()
                                      //                   .isNotEmpty
                                      //               ? widget.serviceData!
                                      //                   .attachments!.first
                                      //                   .validate()
                                      //               : '',
                                      //     ),
                                      //   )
                                      //       .then((value) {
                                      //     context
                                      //         .read<CartProvider>()
                                      //         .getData();
                                      //     if (value.id.toString() != "") {
                                      //       cart.addTotalPrice(widget
                                      //           .serviceData!.price!
                                      //           .toDouble());
                                      //       cart.addCounter();
                                      //       getIntAsync("cart_items");
                                      //     }
                                      //   });
                                      // }).onError((error, stackTrace) {
                                      //   print(error.toString());
                                      // });
                                      ///////////// End Add New Cart API ///////
                                    })
                                  : SignInScreen().launch(context);
                            }),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ).paddingSymmetric(horizontal: 8, vertical: 8),
      ),
    );
  }
}
