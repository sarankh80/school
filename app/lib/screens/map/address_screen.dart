import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/background_component.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/address_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen();
  @override
  AddressScreenState createState() => AddressScreenState();
}

class AddressScreenState extends State<AddressScreen> {
  ScrollController scrollController = ScrollController();
  UniqueKey key = UniqueKey();

  int page = 1;
  List<AddressData> addressList = [];
  bool isLastPage = false;
  double latitude = 0.0;
  double longitude = 0.0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    fetchAllAddressData();
    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (getBoolAsync(SET_PAGINATION_ADDRESS)) {
          if (!isLastPage) {
            page++;
            fetchAllAddressData();
          }
        }
      }
    });
  }

  Future fetchAllAddressData() async {
    appStore.setLoading(true);
    if (getBoolAsync(SET_PAGINATION_ADDRESS)) {
      await getAddress(page: page).then((value) {
        // addressList = value.addressList.validate();
        setState(() {});
        if (getBoolAsync(SET_PAGINATION_ADDRESS)) {
          if (page == 1) {
            addressList.clear();
          }
          isLastPage = value.addressList!.length != PER_PAGE_ITEM;
        }
        addressList.addAll(value.addressList.validate());
      });
    } else {
      await getAddress().then((value) {
        setState(() {});

        addressList.addAll(value.addressList.validate());
      });
    }
    appStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        fetchAllAddressData();
        appStore.setLoading(false);
        return await 2.seconds.delay;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: appBarWidget(language.lblAddress,
            backWidget: BackWidget(),
            color: primaryColor,
            elevation: 0,
            textColor: white),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedWrap(
                    itemCount: addressList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return addressList[index].title == "Current Address"
                          ? SizedBox()
                          : Container(
                              margin:
                                  EdgeInsets.only(top: 10, left: 10, right: 10),
                              padding:
                                  EdgeInsets.only(top: 8, left: 10, right: 10),
                              width: context.width(),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: (addressList.length != 0 &&
                                            (appStore.isCurrentLocation ==
                                                    false &&
                                                appStore.isCustomeLocation ==
                                                    true))
                                        ? warningColor
                                        : context.dividerColor),
                                borderRadius: radius(),
                                color: (addressList.length != 0 &&
                                        (appStore.isCurrentLocation == false &&
                                            appStore.isCustomeLocation == true))
                                    ? Colors.red[100]
                                    : context.scaffoldBackgroundColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${addressList[index].title}",
                                        textAlign: TextAlign.left,
                                        style: boldTextStyle(
                                          size: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 15,
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            showInDialog(
                                              context,
                                              contentPadding: EdgeInsets.zero,
                                              builder: (p0) {
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                        language.lblDeleteAddress +
                                                            "?",
                                                        style: boldTextStyle(
                                                            size: 20)),
                                                    16.height,
                                                    Row(
                                                      children: [
                                                        AppButton(
                                                          child: Text(
                                                              language.lblNo,
                                                              style:
                                                                  boldTextStyle()),
                                                          elevation: 0,
                                                          onTap: () {
                                                            finish(context);
                                                          },
                                                        ).expand(),
                                                        16.width,
                                                        AppButton(
                                                          child: Text(
                                                              language.lblYes,
                                                              style:
                                                                  boldTextStyle(
                                                                      color:
                                                                          white)),
                                                          color: primaryColor,
                                                          elevation: 0,
                                                          onTap: () async {
                                                            setState(() {
                                                              appStore
                                                                  .setLoading(
                                                                      true);
                                                              deletedAddress(
                                                                  addressList[
                                                                          index]
                                                                      .id);
                                                              addressList.removeWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      addressList[
                                                                              index]
                                                                          .id);
                                                              finish(context);
                                                              appStore
                                                                  .setLoading(
                                                                      false);
                                                            });
                                                          },
                                                        ).expand(),
                                                      ],
                                                    ),
                                                  ],
                                                ).paddingSymmetric(
                                                    horizontal: 16,
                                                    vertical: 24);
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      if (addressList[index].isDefault == 1)
                                        Text(
                                          '${language.defaultAddress}',
                                          textAlign: TextAlign.left,
                                          style: secondaryTextStyle(
                                              size: 13, color: warningColor),
                                        )
                                    ],
                                  ),
                                  Text(
                                    "${addressList[index].address}",
                                    textAlign: TextAlign.left,
                                    style: primaryTextStyle(size: 14),
                                  ).paddingBottom(10),
                                ],
                              ),
                            );
                    },
                  ),
                ],
              ),
            ),
            Observer(
              builder: (BuildContext context) {
                return BackgroundComponent(
                        size: 150, text: language.lblNoServicesFound)
                    .center()
                    .paddingTop(!appStore.isLoading ? 180 : 26)
                    .visible(addressList.isEmpty && !appStore.isLoading);
              },
            ),
          ],
        ).paddingBottom(20),
      ),
    );
  }
}
