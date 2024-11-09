import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/cart_model.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class HelpSupportScreen extends StatefulWidget {
  @override
  _HelpSupportScreenState createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  ScrollController scrollController = ScrollController();
  UniqueKey key = UniqueKey();
  Future<Cart>? future;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        init();
        setState(() {});
        return await 2.seconds.delay;
      },
      child: Scaffold(
        appBar: appBarWidget(
          language.helpSupport,
          textColor: Colors.white,
          color: primaryColor,
          showBack: Navigator.canPop(context),
          backWidget: BackWidget(),
        ),
        body: Stack(
          children: [
            Container(),
          ],
        ),
      ),
    );
  }
}
