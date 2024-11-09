import 'package:com.gogospider.booking/component/price_widget.dart';
import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/cart_model.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/auth/sign_in_screen.dart';
import 'package:com.gogospider.booking/screens/cart/plus_minus_button.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class AddCartConponent extends StatefulWidget {
  final ServiceData? serviceDetail;

  const AddCartConponent({required this.serviceDetail, Key? key})
      : super(key: key);

  @override
  State<AddCartConponent> createState() => _AddCartConponentState();
}

class _AddCartConponentState extends State<AddCartConponent> {
  DBHelper dbHelper = DBHelper();
  bool isAddCart = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    int? serviceId =
        widget.serviceDetail!.id! > 0 ? widget.serviceDetail!.id : 0;
    // int? plus = 0;
    return Container(
      width: context.width(),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          4.height,
          Text(
            '${widget.serviceDetail!.name.validate()}',
            style: boldTextStyle(size: 18),
          ),
          5.height,
          Row(
            children: [
              Text(
                language.lblPrice + " : ",
                style: boldTextStyle(size: 18),
              ),
              PriceWidget(
                price: widget.serviceDetail!.price.validate(),
                isHourlyService: widget.serviceDetail!.isHourlyService,
                size: 18,
                hourlyTextColor: textSecondaryColorGlobal,
              ),
              4.width,
              if (widget.serviceDetail!.discount.validate() != 0)
                Text(
                  '(${widget.serviceDetail!.discount.validate()}% ${language.lblOff})',
                  style: boldTextStyle(color: Colors.green),
                ),
              10.width,
              if (widget.serviceDetail!.discount.validate() != 0)
                Container(
                  alignment: Alignment.bottomRight,
                  child: PriceWidget(
                    price: widget.serviceDetail!.basePrice.validate(),
                    isHourlyService: widget.serviceDetail!.isHourlyService,
                    color: textSecondaryColor,
                    hourlyTextColor: Colors.white,
                    size: 18,
                    isLineThroughEnabled: true,
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
                      border: appStore.isDarkMode
                          ? Border.all(color: Colors.white, width: 2)
                          : Border.all(
                              color: Colors.red,
                              width: 1.5,
                            ),
                    ),
                    child: ValueListenableBuilder<int>(
                      valueListenable:
                          ValueNotifier(value.data!.first.quantity!.value),
                      builder: (index, int val, child) {
                        return PlusMinusButtons(
                          conditoin: 2,
                          addQuantity: () {
                            cart.addQty(value.data!.first);
                            /////////////////// Update Cart From API ///////////
                            // cart.addQuantity(value.data![plus].id!);
                            // dbHelper
                            //     .updateQuantity(Cart(
                            //         id: value.data![plus].id,
                            //         productId: serviceId,
                            //         productName: value.data![plus].productName,
                            //         initialPrice:
                            //             value.data![plus].initialPrice,
                            //         productPrice:
                            //             value.data![plus].productPrice,
                            //         quantity: ValueNotifier(
                            //             value.data![plus].quantity!.value + 1),
                            //         unitTag: value.data![plus].image,
                            //         image: ''))
                            //     .then((values) {
                            //   setState(() {
                            //     cart.addQuantityApi(value.data![plus].id!,
                            //         value.data![plus].quantity!.value.toInt());
                            //     cart.addTotalPrice(double.parse(
                            //         widget.serviceDetail!.price.toString()));
                            //   });
                            // });
                            // cart.addQuantityNolist(
                            //     value.data![plus].id.validate());
                            ///////////////// End Update Cart From API /////////
                          },
                          deleteQuantity: () {
                            if ((value.data!.first.quantity!.value) > 1) {
                              cart.deleteQty(value.data!.first);
                            }
                            //////////////// Delete Item min ////////////////
                            // setState(() {
                            // if ((value.data![plus].quantity!.value) > 1) {
                            //   dbHelper
                            //       .updateQuantity(Cart(
                            //           id: value.data![plus].id,
                            //           productId: serviceId,
                            //           productName:
                            //               value.data![plus].productName,
                            //           initialPrice:
                            //               value.data![plus].initialPrice,
                            //           productPrice:
                            //               value.data![plus].productPrice,
                            //           quantity: ValueNotifier(
                            //               value.data![plus].quantity!.value -
                            //                   1),
                            //           unitTag: value.data![plus].image,
                            //           image: ''))
                            //       .then((value) {
                            //     setState(() {
                            //       // cart.addTotalPrice(double.parse(
                            //       //     widget.serviceDetail.price.toString()));
                            //     });
                            //   });
                            //   cart.deleteQuantityApi(value.data![plus].id!,
                            //       value.data![plus].quantity!.value.toInt());
                            //   cart.deleteQuantityNolist(
                            //       value.data![plus].id!);
                            //   cart.removeTotalPrice(double.parse(
                            //       widget.serviceDetail!.price.toString()));
                            // }
                            // });
                            ///////////////// End Delete ///////////////////////
                          },
                          text: val.toString(),
                        );
                      },
                    ),
                  );
                else
                  return Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: context.width(),
                    decoration: BoxDecoration(
                      border: Border.all(color: white, width: 2),
                      borderRadius: radius(),
                      color: context.primaryColor,
                    ),
                    child: Text(
                      language.addToCart,
                      style: boldTextStyle(size: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ).onTap(
                    () {
                      appStore.isLoggedIn
                          ? setState(() {
                              setValue('isButtonEnabled', true);
                              cart.insertData(widget.serviceDetail!);
                              ////////// Add Cart From API /////////////////////
                              //   Map? requset = {
                              //     "quantity": 1,
                              //     "product_id": serviceId
                              //   };
                              //   insertCartResponse(requset, serviceId)
                              //       .then((data) {
                              //     var item = data.items!.firstWhere((element) =>
                              //         element.productId == serviceId);
                              //     dbHelper
                              //         .insert(Cart(
                              //       id: item.id,
                              //       productId: serviceId,
                              //       productName: widget.serviceDetail!.name,
                              //       initialPrice: widget.serviceDetail!.price,
                              //       productPrice: widget.serviceDetail!.price,
                              //       quantity: ValueNotifier(1),
                              //       unitTag: widget.serviceDetail!.unit,
                              //       image: widget
                              //               .serviceDetail!.serviceAttachments
                              //               .validate()
                              //               .isNotEmpty
                              //           ? widget.serviceDetail!
                              //               .serviceAttachments!.first
                              //               .validate()
                              //           : widget.serviceDetail!.attachments
                              //                   .validate()
                              //                   .isNotEmpty
                              //               ? widget
                              //                   .serviceDetail!.attachments!.first
                              //                   .validate()
                              //               : '',
                              //     ))
                              //         .then((value) {
                              //       context.read<CartProvider>().getData();
                              //       if (value.id.toString() != "") {
                              //         cart.addTotalPrice(widget
                              //             .serviceDetail!.price!
                              //             .toDouble());
                              //         cart.addCounter();
                              //         getIntAsync("cart_items");
                              //       }
                              //     }).onError((error, stackTrace) {
                              //       print(error.toString());
                              //     });
                              //   });
                              ////////////////// End Add Cart //////////////////
                            })
                          : SignInScreen().launch(context);
                    },
                  );
              } else {
                return Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: context.width(),
                  decoration: BoxDecoration(
                    border: Border.all(color: white, width: 2),
                    borderRadius: radius(),
                    color: context.primaryColor,
                  ),
                  child: Text(
                    language.addToCart,
                    style: boldTextStyle(size: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ).onTap(
                  () {
                    appStore.isLoggedIn
                        ? setState(() {
                            setValue('isButtonEnabled', true);
                            cart.insertData(widget.serviceDetail!);
                            ////////////////// Add Cart From API ///////////////
                            // Map? requset = {
                            //   "quantity": 1,
                            //   "product_id": serviceId
                            // };
                            // insertCartResponse(requset, serviceId).then((data) {
                            //   var item = data.items!.firstWhere(
                            //       (element) => element.productId == serviceId);
                            //   dbHelper
                            //       .insert(Cart(
                            //     id: item.id,
                            //     productId: serviceId,
                            //     productName: widget.serviceDetail!.name,
                            //     initialPrice: widget.serviceDetail!.price,
                            //     productPrice: widget.serviceDetail!.price,
                            //     quantity: ValueNotifier(1),
                            //     unitTag: widget.serviceDetail!.unit,
                            //     image: widget.serviceDetail!.serviceAttachments
                            //             .validate()
                            //             .isNotEmpty
                            //         ? widget.serviceDetail!.serviceAttachments!
                            //             .first
                            //             .validate()
                            //         : widget.serviceDetail!.attachments
                            //                 .validate()
                            //                 .isNotEmpty
                            //             ? widget
                            //                 .serviceDetail!.attachments!.first
                            //                 .validate()
                            //             : '',
                            //   ))
                            //       .then((value) {
                            //     Map? requset = {
                            //       "quantity": 1,
                            //       "product_id": serviceId
                            //     };
                            //     context.read<CartProvider>().getData();
                            //     insertCartResponse(requset, serviceId);
                            //     if (value.id.toString() != "") {
                            //       cart.addTotalPrice(
                            //           widget.serviceDetail!.price!.toDouble());
                            //       cart.addCounter();
                            //       getIntAsync("cart_items");
                            //     }
                            //   }).onError((error, stackTrace) {
                            //     print(error.toString());
                            //   });
                            // });
                            ////////////////// End Add Cart From API ///////////
                          })
                        : SignInScreen().launch(context);
                  },
                );
              }
            },
          ),
          10.height,
          Container(
              child: Text(
            widget.serviceDetail!.description.validate(),
            style: TextStyle(
                color: appStore.isDarkMode ? Colors.white : textSecondaryColor),
            // maxLines: 1,
          )),
        ],
      ),
    );
  }
}
