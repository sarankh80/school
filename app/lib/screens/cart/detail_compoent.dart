import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/component/view_all_label_component.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/service_detail_response.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/screens/service/component/excluded_component.dart';
import 'package:com.gogospider.booking/screens/service/component/frequently_component.dart';
import 'package:com.gogospider.booking/screens/service/component/image_option_component.dart';
import 'package:com.gogospider.booking/screens/service/component/included_component.dart';
import 'package:com.gogospider.booking/screens/category/menu_fixed.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/screens/review/rating_view_all_screen.dart';
import 'package:com.gogospider.booking/screens/review/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DetailComponent extends StatefulWidget {
  final int serviceId;
  DetailComponent({required this.serviceId});
  @override
  State<StatefulWidget> createState() => _DetailComponentState();
}

class _DetailComponentState extends State<DetailComponent>
    with TickerProviderStateMixin {
  Future<ServiceDetailResponse>? future;
  int selectedAddressId = 0;
  int selectedBookingAddressId = -1;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(transparentColor);
    future = getServiceDetails(
        serviceId: widget.serviceId.validate(), customerId: appStore.userId);
  }

  @override
  Widget build(BuildContext context) {
    Widget reviewWidget({required List<RatingData> data}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          0.height,
          ViewAllLabel(
            label: language.lblCustomerReviews,
            list: data,
            labelSize: 16,
            onTap: () {
              RatingViewAllScreen(serviceId: widget.serviceId).launch(context);
            },
          ),
          Wrap(
            children: List.generate(
              data.length,
              (index) => ReviewWidget(data: data[index]),
            ),
          ).paddingTop(8),
          data.isNotEmpty
              ? Wrap(
                  children: List.generate(
                    data.length,
                    (index) => ReviewWidget(data: data[index]),
                  ),
                ).paddingTop(8)
              : Text(language.lblNoReviews, style: secondaryTextStyle()),
        ],
      ).paddingSymmetric(horizontal: 16);
    }

    Widget buildBodyWidget(AsyncSnapshot<ServiceDetailResponse> snap) {
      if (snap.hasError) {
        return Text(snap.error.toString()).center();
      } else if (snap.hasData) {
        return Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 5),
                alignment: Alignment.topRight,
                child: InkWell(
                  child: Icon(Icons.close_rounded, size: 30, color: white),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              ImageOptionComponent(serviceDetail: snap.data!.serviceDetail!),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: 15,
                      color: Colors.white,
                    ),
                    Container(
                        height: 5,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 218, 215, 215))),
                    Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(bottom: 10),
                        child: FrequentlyComponent(
                            serviceList: snap.data!.realtedService.validate())),
                    Container(
                        height: 5,
                        padding: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 218, 215, 215))),
                    // Container(
                    //     color: Colors.white,
                    //     padding: EdgeInsets.only(bottom: 10),
                    //     child: MarterialComponent()),
                    Container(
                        height: 5,
                        padding: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 218, 215, 215))),
                    Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(bottom: 10),
                        child: IncludeCompenent(
                            serviceDetail: snap.data!.serviceDetail!)),
                    Container(
                        height: 5,
                        padding: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 218, 215, 215))),
                    Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(bottom: 10),
                        child: ExcludedCompenent(
                            serviceDetail: snap.data!.serviceDetail!)),
                    Container(
                        height: 5,
                        padding: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 218, 215, 215))),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(bottom: 10),
                      child: reviewWidget(data: snap.data!.ratingData!),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return Container(
          height: MediaQuery.of(context).size.height,
          child: LoaderWidget().center());
    }

    return FutureBuilder<ServiceDetailResponse>(
      future: future,
      builder: (context, snap) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: buildBodyWidget(snap),
              ),
            ],
          ),
          floatingActionButton: (snap.hasData)
              ? Container(
                  padding: EdgeInsets.only(left: 35),
                  child: Stack(
                    children: [
                      Container(
                          height: 35,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 0, 0, 0)
                                        .withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: FloatingActionButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                backgroundColor:
                                    Color.fromARGB(255, 0, 21, 253),
                                child: Row(children: [
                                  10.width,
                                  Icon(
                                    Icons.menu,
                                    size: 18,
                                  ),
                                  5.width,
                                  Text(language.lblMenu)
                                ]),
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    isScrollControlled: true,
                                    isDismissible: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: radiusOnly(
                                            topLeft: defaultRadius,
                                            topRight: defaultRadius)),
                                    builder: (_) {
                                      return Stack(
                                        children: [
                                          Container(
                                            child: Menufixed(),
                                          )
                                          // DraggableScrollableSheet(
                                          //   builder: (context, scrollController) =>
                                          //       Menufixed(
                                          //           scrollController: scrollController),
                                          // )
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          )).paddingTop(20),
                      Container(
                        height: 55,
                        child: InkWell(
                          onTap: () {
                            DashboardScreen(redirectToCart: true).launch(
                                context,
                                isNewTask: true,
                                pageRouteAnimation: PageRouteAnimation.Fade);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 0, 0, 0)
                                      .withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            width: context.width(),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text("\$ 35.00",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold))),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      language.lblViewCart,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ).paddingTop(70),
                    ],
                  ))
              : Offstage(),
        );
      },
    );
  }
}
