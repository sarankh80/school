import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/cart_model.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/cart/plus_minus_button.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ListCart extends StatefulWidget {
  final Cart? items;
  ListCart({Key? key, this.items}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ListCartState();
}

class _ListCartState extends State<ListCart> {
  DBHelper? dbHelper = DBHelper();
  List<bool> tapped = [];
  final bool isFavouriteService = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Column(children: [
      60.height,
      Expanded(
        child: Consumer<CartProvider>(
            builder: (BuildContext context, provider, widget) {
          if (provider.cart.length == 0) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: provider.cart.length,
              itemBuilder: (BuildContext context, int index) {
                var discount = provider.cart[index].discountProduct != null
                    ? provider.cart[index].discountProduct
                    : 0;
                // print(discount);
                //     ((provider.carts[index].product!.discount! / 100) *
                //         provider.carts[index].price!);
                return Container(
                  // color: Colors.blueGrey.shade200,
                  // elevation: 5.0,
                  padding: EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 216, 216, 216),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CachedImageWidget(
                          // url: provider.carts[index].product!.attchments != null
                          //     ? provider.carts[index].product!.attchments!.first
                          //         .validate()
                          //     : '',
                          url: provider.cart[index].image != null
                              ? provider.cart[index].image.validate()
                              : '',
                          fit: BoxFit.cover,
                          radius: 8,
                          // height: 180,
                          height: 80,
                          width: 80,
                          circle: false,
                        )
                            .cornerRadiusWithClipRRectOnly(
                              topRight: defaultRadius.toInt(),
                              topLeft: defaultRadius.toInt(),
                            )
                            .paddingAll(0),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      padding: EdgeInsets.only(left: 10),
                                      width: context.width() - 120,
                                      child: Text(
                                        // '${(provider.carts.isNotEmpty) ? provider.carts[index].name! : ""}\n',
                                        '${(provider.cart.isNotEmpty) ? provider.cart[index].productName : ""}\n',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: appStore.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        onTap: () {
                                          // dbHelper!.deleteCartItemApi(
                                          //     provider.carts[index].id!);
                                          // provider.removeItemApi(
                                          //     provider.carts[index].id!);
                                          provider.removeItem(
                                              provider.cart[index].id!);
                                          provider.removeCounter();
                                          provider.getData();
                                        },
                                        child: Icon(Icons.close, size: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 10, left: 10),
                                    width: context.width() - 210,
                                    child: Row(
                                      children: [
                                        Text(
                                          // '${isCurrencyPositionLeft ? appStore.currencySymbol : ''} ${(provider.carts.isNotEmpty) ? (discount > 0 ? provider.carts[index].price! - discount : provider.carts[index].price!).toStringAsFixed(DECIMAL_POINT).formatNumberWithComma() : ""}',
                                          '${isCurrencyPositionLeft ? appStore.currencySymbol : ''} ${(provider.cart.isNotEmpty) ? (discount!.toDouble() > 0 ? provider.cart[index].productPrice! : provider.cart[index].productPrice!).toStringAsFixed(DECIMAL_POINT).formatNumberWithComma() : ""}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: appStore.isDarkMode
                                                  ? Colors.white
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ).paddingRight(5),
                                        if (discount!.toDouble() > 0)
                                          Text(
                                            '${isCurrencyPositionLeft ? appStore.currencySymbol : ''} ${(provider.cart.isNotEmpty) ? (discount.toDouble() > 0 ? provider.cart[index].productPrice! + provider.cart[index].discountProduct! : provider.cart[index].productPrice!).toStringAsFixed(DECIMAL_POINT).formatNumberWithComma() : ""}',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                decorationColor: Colors.red,
                                                decorationStyle:
                                                    TextDecorationStyle.solid,
                                                fontSize: 14,
                                                color: appStore.isDarkMode
                                                    ? Colors.white
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (provider.cart.isNotEmpty)
                                    ValueListenableBuilder<int>(
                                      valueListenable:
                                          provider.cart[index].quantity!,
                                      builder: (context, val, child) {
                                        return PlusMinusButtons(
                                          conditoin: 0,
                                          addQuantity: () {
                                            cart.addQty(provider.cart[index]);
                                            // cart.addQuantitys(
                                            //     provider.cart[index].id!);
                                            // dbHelper!
                                            //     .updateQuantity(Cart(
                                            //         id: provider.cart[index].id,
                                            //         productId: provider
                                            //             .cart[index].productId,
                                            //         productName: provider
                                            //             .cart[index]
                                            //             .productName,
                                            //         initialPrice: provider
                                            //             .cart[index]
                                            //             .initialPrice,
                                            //         productPrice: provider
                                            //             .cart[index]
                                            //             .productPrice,
                                            //         quantity: ValueNotifier(
                                            //             provider.cart[index]
                                            //                 .quantity!.value),
                                            //         unitTag: provider
                                            //             .cart[index].unitTag,
                                            //         image: provider
                                            //             .cart[index].image))
                                            //     .then((value) {
                                            //   setState(() {
                                            //     cart.addQuantityApi(
                                            //         provider.carts[index].id
                                            //             .validate(),
                                            //         provider.carts[index]
                                            //             .quantity!.value
                                            //             .toInt());
                                            //     cart.addTotalPrice(double.parse(
                                            //         provider.cart[index]
                                            //             .productPrice
                                            //             .toString()));
                                            //   });
                                            // });
                                          },
                                          deleteQuantity: () {
                                            if ((provider.cart[index].quantity!
                                                    .value) >
                                                1) {
                                              cart.deleteQty(
                                                  provider.cart[index]);
                                            }
                                            // cart.deleteQuantity(
                                            //     provider.cart[index].id!);
                                            // cart.removeTotalPrice(double.parse(
                                            //     provider
                                            //         .cart[index].productPrice
                                            //         .toString()));
                                            // cart.deleteQuantityApi(
                                            //     provider.carts[index].id
                                            //         .validate(),
                                            //     provider.carts[index].quantity!
                                            //         .value
                                            //         .toInt());
                                          },
                                          text: val.toString(),
                                        );
                                      },
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }),
      ),
    ]);
  }
}
