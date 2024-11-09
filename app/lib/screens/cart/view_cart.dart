import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ViewCart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    // context.read<CartProvider>().getData();
    return Positioned(
      height: 55,
      bottom: 10,
      right: 15,
      left: 15,
      child: InkWell(
        onTap: () {
          DashboardScreen(redirectToCart: true).launch(context,
              isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Consumer<CartProvider>(
                  builder: (BuildContext context, value, Widget? child) {
                    final ValueNotifier<double?> totalPrice =
                        ValueNotifier(null);
                    for (var element in value.cart) {
                      totalPrice.value = (element.productPrice!.toDouble() *
                              element.quantity!.value) +
                          (totalPrice.value ?? 0.0);
                    }
                    return Container(
                      child: ValueListenableBuilder<double?>(
                        valueListenable: totalPrice,
                        builder: (context, val, child) {
                          if (totalPrice.value == null) {
                            return Container(
                              child: Text(
                                "${appStore.currencySymbol} ${getDoubleAsync("total_price").toStringAsFixed(DECIMAL_POINT)}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else if (getDoubleAsync("total_price") <
                                  totalPrice.value!.toDouble() ||
                              getDoubleAsync("total_price") >
                                  totalPrice.value!.toDouble()) {
                            return Container(
                              child: Text(
                                "${appStore.currencySymbol} ${(getDoubleAsync("total_price") + totalPrice.value!.toDouble()).toStringAsFixed(DECIMAL_POINT)}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                          return Container(
                            child: Text(
                              "${appStore.currencySymbol} ${val!.toStringAsFixed(DECIMAL_POINT)}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                // child: Consumer<CartProvider>(
                //   builder: (BuildContext context, provider, widget) {
                //     // final ValueNotifier<double?> totalPrice = ValueNotifier(0);
                //     // for (var element in provider.carts) {
                //     //   totalPrice.value =
                //     //       (element.price! * element.quantity!.value) +
                //     //           (totalPrice.value ?? 0.0);
                //     // }
                //     return Container(
                //       // child: ValueListenableBuilder<double?>(
                //       //   valueListenable: totalPrice,
                //       //   builder: (context, val, child) {
                //       //     return Container(
                //       child: Text(
                //         "${appStore.currencySymbol} ${getDoubleAsync("total_price").toStringAsFixed(DECIMAL_POINT) ?? '0'}",
                //         textAlign: TextAlign.left,
                //         style: TextStyle(
                //             fontSize: 18,
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold),
                //       ),
                //       //     );
                //       //   },
                //       // ),
                //     );
                //   },
                // ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  language.lblBookNow,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
