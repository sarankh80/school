import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/background_component.dart';
import 'package:com.gogospider.booking/component/error_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/cart/view_cart.dart';
import 'package:com.gogospider.booking/screens/service/component/service_component.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ItemListScreen extends StatefulWidget {
  final String? categoryName;

  final int? categoryId;
  ItemListScreen({
    this.categoryId,
    this.categoryName = '',
  });

  @override
  ItemListScreenState createState() => ItemListScreenState();
}

class ItemListScreenState extends State<ItemListScreen> {
  FocusNode myFocusNode = FocusNode();

  ScrollController scrollController = ScrollController();

  TextEditingController searchCont = TextEditingController();

  int page = 1;
  List<ServiceData> mainList = [];

  bool isEnabled = false;
  bool isLastPage = false;
  bool fabIsVisible = true;
  bool isSubCategoryLoaded = false;
  bool isApiCalled = false;

  String? subCategory = '0';
  String? brand = '-1';
  String? isError = "";
  bool firstLoad = true;

  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().getData();
    afterBuildCreated(() {
      init();
    });
  }

  void init() async {
    fetchAllServiceData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isLastPage) {
          page++;
          fetchAllServiceData();
        }
      }
    });
  }

  Future<void> fetchAllServiceData() async {
    appStore.setLoading(true);

    filterStore.setLatitude(getDoubleAsync(LATITUDE).toString());
    filterStore.setLongitude(getDoubleAsync(LONGITUDE).toString());

    await getProductServiceList(page,
            categoryId: widget.categoryId,
            lat: getDoubleAsync(LATITUDE),
            long: getDoubleAsync(LONGITUDE))
        .then((value) async {
      appStore.setLoading(false);

      if (page == 1) {
        mainList.clear();
      }
      isLastPage = value.serviceList.validate().length != PER_PAGE_ITEM;
      mainList.addAll(value.serviceList.validate());

      isApiCalled = true;
      isError = "";
      firstLoad = false;
      setState(() {});
    }).catchError((e) {
      isError = e.toString();
      isApiCalled = true;
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    filterStore.clearFilters();
    myFocusNode.dispose();
    LiveStream().dispose(LIVESTREAM_UPDATE_SERVICE_LIST);
    filterStore.setSelectedSubCategory(catId: 0);

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (getStringAsync(BOOKING_INFO) == "") {}
    return Scaffold(
      appBar: appBarWidget(
        widget.categoryName.toString(),
        textColor: Colors.white,
        color: context.primaryColor,
        backWidget: BackWidget(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // context.read<CartProvider>().getData();
          page = 1;
          return await fetchAllServiceData();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
                controller: scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (mainList.isNotEmpty && widget.categoryId != 0)
                        AnimatedWrap(
                          itemCount: mainList.length,
                          listAnimationType: ListAnimationType.Scale,
                          itemBuilder: (_, index) {
                            return ServiceComponent(
                                    isBorderEnabled: true,
                                    serviceData: mainList[index],
                                    width: context.width() / 2 - 26)
                                .paddingAll(8);
                          },
                        ).paddingAll(8),
                      Observer(
                          builder: (BuildContext context) => LoaderWidget(
                                backgroundColor: Colors.white,
                              ).visible(appStore.isLoading.validate() &&
                                  firstLoad == false)),
                      70.height,
                    ],
                  ),
                )).paddingTop(0),
            Observer(
                builder: (BuildContext context) => LoaderWidget(
                      backgroundColor: Colors.white,
                    ).visible(
                        appStore.isLoading.validate() && firstLoad == true)),
            Observer(
                builder: (BuildContext context) => Consumer<CartProvider>(
                      builder: (BuildContext context, value, widget) {
                        if (getIntAsync("cart_items") != 0)
                          return ViewCart();
                        else
                          return Container();
                      },
                    ).visible(!appStore.isLoading.validate())),
            Observer(
              builder: (BuildContext context) {
                return isError != ""
                    ? Center(
                        child: ErrorsWidget(
                          errortext: isError,
                          onPressed: () async {
                            appStore.setLoading(true);
                            filterStore.setSelectedSubCategory(catId: 0);
                            init();
                            setState(() {});
                            return await 2.seconds.delay;
                          },
                        ),
                      )
                    : BackgroundComponent(
                            size: 300, text: language.lblNoServicesFound)
                        .center()
                        .visible(isApiCalled &&
                            mainList.isEmpty &&
                            !appStore.isLoading &&
                            widget.categoryId != 0);
              },
            ).visible(!appStore.isLoading.validate()),
          ],
        ),
      ),
    );
  }
}
