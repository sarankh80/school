import 'package:com.gogospider.booking/component/error_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/service/component/add_cart_component.dart';
import 'package:com.gogospider.booking/screens/service/component/detail_head_component.dart';
import 'package:com.gogospider.booking/screens/cart/view_cart.dart';
import 'package:com.gogospider.booking/screens/service/component/excluded_component.dart';
import 'package:com.gogospider.booking/screens/service/component/frequently_component.dart';
import 'package:com.gogospider.booking/screens/service/component/included_component.dart';
import 'package:com.gogospider.booking/screens/service/component/marterial_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ViewDetail extends StatefulWidget {
  final ServiceData? service;
  final int? serviceId;
  ViewDetail({this.service, this.serviceId});
  @override
  State<StatefulWidget> createState() => _ViewDetailState();
}

class _ViewDetailState extends State<ViewDetail> {
  get scrollController => null;
  // Future<ServiceData>? future;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ServiceData>(
      future: getServiceDetailId(serviceId: widget.serviceId.validate()),
      builder: (context, snap) {
        // return Container();
        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                // return await widget.service();
                context.read<CartProvider>().getData();
              },
              child: Stack(
                children: [
                  snap.hasError
                      ? ErrorsWidget(
                          errortext: snap.error.toString(),
                          onPressed: () async {
                            appStore.isLoading = true;
                            setState(() {});
                            return await 2.seconds.delay;
                          },
                        )
                      : SingleChildScrollView(
                          controller: scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DetailHeadComponent(
                                  serviceDetail: widget.service),
                              AddCartConponent(serviceDetail: widget.service),
                              FrequentlyComponent(
                                  serviceList: snap.data != null
                                      ? snap.data!.relatedServices.validate()
                                      : []),
                              MarterialComponent(
                                  marterialList: snap.data != null
                                      ? snap.data!.children.validate()
                                      : []),
                              10.height,
                              Container(
                                height: 5,
                                padding: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 218, 215, 215),
                                ),
                              ),
                              IncludeCompenent(serviceDetail: snap.data),
                              10.height,
                              Container(
                                height: 5,
                                padding: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 218, 215, 215),
                                ),
                              ),
                              ExcludedCompenent(serviceDetail: snap.data),
                              100.height,
                            ],
                          ),
                        ),
                  Observer(
                      builder: (context) =>
                          LoaderWidget().visible(appStore.isLoading)),
                  // PubMenu(category: snap.data?.relatedCategories),
                  Consumer<CartProvider>(
                    builder: (BuildContext context, value, widget) {
                      return value.counter.toInt() > 0
                          ? ViewCart()
                          : SizedBox();
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
