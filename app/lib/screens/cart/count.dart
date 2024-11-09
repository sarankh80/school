import 'package:badges/badges.dart' as badge;
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class Count extends StatefulWidget {
  final color;
  const Count({Key? key, this.color}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CountState();
}

class _CountState extends State<Count> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (BuildContext context) {
      appStore.cartItems = getIntAsync("cart_items");
      if (appStore.cartItems != 0)
        return badge.Badge(
          badgeContent: Consumer<CartProvider>(
            builder: (context, value, child) {
              return Text(
                getIntAsync("cart_items") != 0
                    ? getIntAsync("cart_items").toString()
                    : getIntAsync("cart_items").toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
          position: badge.BadgePosition.topEnd(),
          child: ImageIcon(AssetImage(ic_buy), color: widget.color),
        );
      else
        return Container(
            child: ImageIcon(AssetImage(ic_buy), color: widget.color));
    });
    // if (getIntAsync("cart_items") != 0)
    //   return badge.Badge(
    //     badgeContent: Consumer<CartProvider>(
    //       builder: (context, value, child) {
    //         return Text(
    //           getIntAsync("cart_items") != 0
    //               ? getIntAsync("cart_items").toString()
    //               : getIntAsync("cart_items").toString(),
    //           style: const TextStyle(
    //               color: Colors.white, fontWeight: FontWeight.bold),
    //         );
    //       },
    //     ),
    //     position: badge.BadgePosition.topEnd(),
    //     child: ImageIcon(AssetImage(ic_buy), color: widget.color),
    //   );
    // else
    //   return Container(
    //       child: ImageIcon(AssetImage(ic_buy), color: widget.color));
  }
}
