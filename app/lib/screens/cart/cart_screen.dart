import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/cart_model.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/cart/component/book_now.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'component/list.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ScrollController scrollController = ScrollController();
  UniqueKey key = UniqueKey();
  // Future<AddCartResponse>? future;
  Future<Cart>? future;
  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().getData();
    init();
  }

  void init() async {
    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
    });
    // future = getCartResponse();
    // future = dbHelper?.getCartList();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    appStore.setLoading(false);
    return RefreshIndicator(
      onRefresh: () async {
        init();
        context.read<CartProvider>().getData();
        setState(() {});
        return await 2.seconds.delay;
      },
      child: Scaffold(
        appBar: appBarWidget(
          language.lblcart,
          textColor: Colors.white,
          color: primaryColor,
          showBack: Navigator.canPop(context),
          backWidget: BackWidget(),
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 16, top: 10),
              child: Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(language.lblYourCart, style: boldTextStyle()),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    language.lblAllItemYouHasBeenAddToCart,
                    style: primaryTextStyle(size: 12),
                  ),
                ),
              ]),
            ),
            // FutureBuilder<Cart>(
            //   future: future,
            //   builder: (context, snap) {
            //     if (snap.hasData) {
            //       return ListCart(items: snap.data);
            //     }
            //     return snapWidgetHelper(snap, loadingWidget: Offstage());
            //   },
            // ),
            Container(
              child: ListCart(),
            ),
            Observer(
              builder: (BuildContext context) =>
                  LoaderWidget().visible(appStore.isLoading.validate()),
            ),
            BookNow()
          ],
        ),
      ),
    );
  }
}
