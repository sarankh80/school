import 'package:com.gogospider.booking/component/ask_change_location_dialog.dart';
import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/error_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/component/view_all_label_component.dart';
import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/booking/component/booking_service_location_filter.dart';
import 'package:com.gogospider.booking/screens/category/component/category_widget.dart';
import 'package:com.gogospider.booking/screens/service/item_list_screen.dart';
import 'package:com.gogospider.booking/screens/service/search_list_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final int? categoryId;
  CategoryScreen({this.categoryId});
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  ScrollController scrollController = ScrollController();
  UniqueKey key = UniqueKey();

  int page = 1;
  List<CategoriesData> mainCatList = [];

  bool isEnabled = false;
  bool isLastPage = false;
  bool fabIsVisible = true;
  DBHelper? dbHelper = DBHelper();
  String? isError = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // if (appStore.isAlertChooseLocation == true) {
    //   showBottomSheetChooseLocation(context, firstTimeShow: true);
    // }
    fetchAllCategoryData();
    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
    });
  }

  Future fetchAllCategoryData() async {
    appStore.setLoading(true);
    if (widget.categoryId != null) {
      await getCategoriesListID(catId: widget.categoryId.validate())
          .then((value) {
        mainCatList = value.categoriesList.validate();
        isLastPage = value.categoriesList!.length != PER_PAGE_ITEM;
        isError = "";
        setState(() {});
      }).catchError((error) {
        // maybe do something here
        isError = error;
        setState(() {});
        throw error;
      });
    } else {
      await getCategoriesList().then((value) {
        mainCatList = value.categoriesList.validate();
        isLastPage = value.categoriesList!.length != PER_PAGE_ITEM;
        isError = "";
        setState(() {});
      }).catchError((error) {
        // maybe do something here
        isError = error;
        setState(() {});
        throw error;
      });
    }
    appStore.setLoading(false);
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
    context.read<CartProvider>().getData();
    return RefreshIndicator(
      onRefresh: () async {
        return await fetchAllCategoryData();
      },
      child: Scaffold(
        appBar: appBarWidget(
          language.lblCategory,
          textColor: Colors.white,
          color: primaryColor,
          showBack: Navigator.canPop(context),
          backWidget: BackWidget(),
        ),
        body: Stack(
          children: [
            isError != ""
                ? Center(
                    child: ErrorsWidget(
                      errortext: isError,
                      onPressed: () async {
                        appStore.setLoading(true);
                        init();
                        setState(() {});
                        return await 2.seconds.delay;
                      },
                    ),
                  )
                : SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        AnimatedWrap(
                          key: key,
                          runSpacing: 0,
                          spacing: 18,
                          itemCount: mainCatList.length,
                          listAnimationType: ListAnimationType.Scale,
                          itemBuilder: (_, index) {
                            CategoriesData data = mainCatList[index];
                            log("data ${data.id}");
                            // if (data.id == 49) {
                            //   return Container(
                            //     child: Column(
                            //       children: [
                            //         Container(
                            //           padding:
                            //               EdgeInsets.only(left: 16, top: 5),
                            //           child: ViewAllLabel(
                            //             label: data.name.validate(),
                            //             list: [],
                            //           ),
                            //         ),
                            //         AnimatedWrap(
                            //           itemCount: data.children!.length,
                            //           itemBuilder: (_, index) {
                            //             CategoriesData children =
                            //                 data.children![index];
                            //             if (children.children!.length > 0) {
                            //               var existHome = children.children!
                            //                   .where((element) =>
                            //                       element.home == true)
                            //                   .toList();
                            //               if (existHome.isEmpty) {
                            //                 children.children!.insert(
                            //                     0,
                            //                     CategoriesData(
                            //                         name: "AA",
                            //                         brands: [],
                            //                         children: [],
                            //                         home: true));
                            //               }
                            //             }
                            //             if (children.parentId != data.id ||
                            //                 children.id == 26) {
                            //               return Container(
                            //                 width: 0,
                            //               );
                            //             } else
                            //               return GestureDetector(
                            //                 onTap: () {
                            //                   if (getDoubleAsync(
                            //                               BOOKING_LATITUDE) !=
                            //                           0.00 &&
                            //                       getDoubleAsync(
                            //                               BOOKING_LONGITUDE) !=
                            //                           0.00) {
                            //                     SearchListScreen(
                            //                       categoryId:
                            //                           children.id.validate(),
                            //                       categoryName: children.name,
                            //                       categoriesData: children,
                            //                     ).launch(context);
                            //                   } else {
                            //                     BookingServiceLocationFilter(
                            //                       categoryData: children,
                            //                     ).launch(context);
                            //                   }
                            //                 },
                            //                 child: Padding(
                            //                   padding: EdgeInsets.symmetric(
                            //                       horizontal: 10, vertical: 10),
                            //                   child: CategoryWidget(
                            //                       categoryData: children,
                            //                       width:
                            //                           context.width() / 3 - 24),
                            //                 ),
                            //               );
                            //           },
                            //         ),
                            //       ],
                            //     ),
                            //   );
                            // }
                            // if (data.id == 2) {
                            //   return Container(
                            //     child: Column(
                            //       children: [
                            //         Container(
                            //           padding:
                            //               EdgeInsets.only(left: 16, top: 5),
                            //           child: ViewAllLabel(
                            //             label: data.name.validate(),
                            //             list: [],
                            //           ),
                            //         ),
                            //         AnimatedWrap(
                            //           itemCount: data.children!.length,
                            //           itemBuilder: (_, index) {
                            //             CategoriesData children =
                            //                 data.children![index];
                            //             if (children.children!.length > 0) {
                            //               var existHome = children.children!
                            //                   .where((element) =>
                            //                       element.home == true)
                            //                   .toList();
                            //               if (existHome.isEmpty) {
                            //                 children.children!.insert(
                            //                     0,
                            //                     CategoriesData(
                            //                         name: "AA",
                            //                         brands: [],
                            //                         children: [],
                            //                         home: true));
                            //               }
                            //             }
                            //             if (children.parentId != data.id ||
                            //                 children.id == 26) {
                            //               return Container(
                            //                 width: 0,
                            //               );
                            //             } else
                            //               return GestureDetector(
                            //                 onTap: () {
                            //                   if (getDoubleAsync(
                            //                               BOOKING_LATITUDE) !=
                            //                           0.00 &&
                            //                       getDoubleAsync(
                            //                               BOOKING_LONGITUDE) !=
                            //                           0.00) {
                            //                     SearchListScreen(
                            //                       categoryId:
                            //                           children.id.validate(),
                            //                       categoryName: children.name,
                            //                       categoriesData: children,
                            //                     ).launch(context);
                            //                   } else {
                            //                     BookingServiceLocationFilter(
                            //                       categoryData: children,
                            //                     ).launch(context);
                            //                   }
                            //                 },
                            //                 child: Padding(
                            //                   padding: EdgeInsets.symmetric(
                            //                       horizontal: 10, vertical: 10),
                            //                   child: CategoryWidget(
                            //                       categoryData: children,
                            //                       width:
                            //                           context.width() / 3 - 24),
                            //                 ),
                            //               );
                            //           },
                            //         ),
                            //       ],
                            //     ),
                            //   );
                            // }
                            // if (data.id == 1) {
                            return Container(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 16, top: 5),
                                    child: ViewAllLabel(
                                      label: data.name.validate(),
                                      list: [],
                                    ),
                                  ),
                                  AnimatedWrap(
                                    itemCount: data.children!.length,
                                    itemBuilder: (_, index) {
                                      CategoriesData children =
                                          data.children![index];

                                      if (children.parentId != data.id ||
                                          children.id == 26) {
                                        return Container(
                                          width: 0,
                                        );
                                      } else
                                        return GestureDetector(
                                          onTap: () {
                                            if (getDoubleAsync(
                                                        BOOKING_LATITUDE) !=
                                                    0.00 &&
                                                getDoubleAsync(
                                                        BOOKING_LONGITUDE) !=
                                                    0.00) {
                                              if (children.countChild! > 0) {
                                                SearchListScreen(
                                                  categoryId:
                                                      children.id.validate(),
                                                  categoryName: children.name,
                                                  categoriesData: children,
                                                ).launch(context);
                                              } else {
                                                ItemListScreen(
                                                  categoryId:
                                                      children.id.validate(),
                                                  categoryName: children.name,
                                                ).launch(context);
                                              }
                                            } else {
                                              BookingServiceLocationFilter(
                                                categoryData: children,
                                              ).launch(context);
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: CategoryWidget(
                                                categoryData: children,
                                                width:
                                                    context.width() / 3 - 24),
                                          ),
                                        );
                                    },
                                  ),
                                ],
                              ),
                            );
                            // }
                            // return Container();
                          },
                        ),
                      ],
                    )),
            Observer(
                builder: (BuildContext context) =>
                    LoaderWidget().visible(appStore.isLoading.validate()))
          ],
        ),
      ),
    );
  }

  Future<void> showBottomSheetChooseLocation(BuildContext context,
      {firstTimeShow = false}) async {
    appStore.isLoading = true;
    await getSavedAddress().then((value) async {
      if (appStore.isCustomeLocation == true) {
        if (value.data!
            .where((element) =>
                element.late == getDoubleAsync(LATITUDE) &&
                element.lang == getDoubleAsync(LONGITUDE))
            .isNotEmpty) {
          value.data!
              .where((element) =>
                  element.late == getDoubleAsync(LATITUDE) &&
                  element.lang == getDoubleAsync(LONGITUDE))
              .first
              .isSelected = true;
          setState(() {});
        }
      }
      appStore.isLoading = false;
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius:
                radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
        builder: (_) {
          return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.50,
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(20),
                      backgroundColor: context.cardColor),
                  padding: EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      DraggableScrollableSheet(
                          initialChildSize: 0.98,
                          minChildSize: 0.98,
                          maxChildSize: 0.98,
                          builder: (context, scrollController) {
                            return AskChangeLocationDialog(
                                addreses: value,
                                onSelectLocation: (lat, long, address,
                                    seletedId, isCurrentLocation) {
                                  setValue(TEMP_CURRENT_ADDRESS, address);
                                  setValue(TEMP_LATITUDE,
                                      double.parse(lat.toStringAsFixed(4)));
                                  setValue(TEMP_LONGITUDE,
                                      double.parse(long.toStringAsFixed(4)));
                                  setValue(TEMP_SELECTED_ADDRESS, seletedId);
                                  setValue(TEMP_IS_CURRENT_LOCATION,
                                      isCurrentLocation);
                                  setState(() {});
                                });
                          }),
                      Positioned(
                        bottom: 10,
                        left: 16,
                        right: 16,
                        child: AppButton(
                          width: MediaQuery.of(context).size.width,
                          text: language.lbConfirm,
                          margin: EdgeInsets.only(right: 10),
                          color: primaryColor,
                          textStyle:
                              boldTextStyle(size: 15, color: Colors.white),
                          onTap: () async {
                            int cartItem = getIntAsync('cart_items');
                            double currentTempLat =
                                getDoubleAsync(TEMP_LATITUDE);
                            double currentTempLong =
                                getDoubleAsync(TEMP_LONGITUDE);

                            double currentLate = getDoubleAsync(LATITUDE);
                            double currentLong = getDoubleAsync(LONGITUDE);

                            if (firstTimeShow = true) {
                              appStore.setAlertChooseLocation(false);
                            }

                            if (currentTempLat != currentLate &&
                                currentTempLong != currentLong) {
                              log(123456);
                              if (cartItem > 0) {
                                showConfirmClearCart(context);
                              } else {
                                String currentTempAddress =
                                    getStringAsync(TEMP_CURRENT_ADDRESS);
                                bool currentTempIsCurrentLocation =
                                    getBoolAsync(TEMP_IS_CURRENT_LOCATION);
                                int currentTempSelectedAddress =
                                    getIntAsync(TEMP_SELECTED_ADDRESS);

                                setValue(CURRENT_ADDRESS, currentTempAddress);
                                setValue(
                                    BOOKING_LATITUDE,
                                    double.parse(
                                        currentTempLat.toStringAsFixed(4)));
                                setValue(
                                    BOOKING_LONGITUDE,
                                    double.parse(
                                        currentTempLong.toStringAsFixed(4)));
                                setValue(
                                    LATITUDE,
                                    double.parse(
                                        currentTempLat.toStringAsFixed(4)));
                                setValue(
                                    LONGITUDE,
                                    double.parse(
                                        currentTempLong.toStringAsFixed(4)));
                                setValue(SELECTED_ADDRESS,
                                    currentTempSelectedAddress);
                                appStore.isCurrentLocation =
                                    currentTempIsCurrentLocation;
                                Navigator.of(context).pop();
                              }
                            } else {
                              String currentTempAddress =
                                  getStringAsync(TEMP_CURRENT_ADDRESS);
                              bool currentTempIsCurrentLocation =
                                  getBoolAsync(TEMP_IS_CURRENT_LOCATION);
                              int currentTempSelectedAddress =
                                  getIntAsync(TEMP_SELECTED_ADDRESS);

                              setValue(CURRENT_ADDRESS, currentTempAddress);
                              setValue(
                                  BOOKING_LATITUDE,
                                  double.parse(
                                      currentTempLat.toStringAsFixed(4)));
                              setValue(
                                  BOOKING_LONGITUDE,
                                  double.parse(
                                      currentTempLong.toStringAsFixed(4)));
                              setValue(
                                  LATITUDE,
                                  double.parse(
                                      currentTempLat.toStringAsFixed(4)));
                              setValue(
                                  LONGITUDE,
                                  double.parse(
                                      currentTempLong.toStringAsFixed(4)));
                              setValue(
                                  SELECTED_ADDRESS, currentTempSelectedAddress);
                              appStore.isCurrentLocation =
                                  currentTempIsCurrentLocation;
                              Navigator.of(context).pop();
                              log(1234567);
                            }
                          },
                        ),
                      )
                    ],
                  )));
        },
      );
    });
  }

  showConfirmClearCart(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              language.lblCofirmation,
              style: boldTextStyle(size: 16),
            ),
            content: Text(language.changeAddressContainItemInCartAlert),
            actions: <Widget>[
              AppButton(
                text: language.lblNo,
                textColor: Colors.white,
                color: warningColor,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              AppButton(
                text: language.lblOk,
                textColor: Colors.white,
                color: primaryColor,
                onTap: () {
                  appStore.setLoading(true);
                  double currentTempLat = getDoubleAsync(TEMP_LATITUDE);
                  double currentTempLong = getDoubleAsync(TEMP_LONGITUDE);
                  int currentTempSelectedAddress =
                      getIntAsync(TEMP_SELECTED_ADDRESS);
                  String currentTempAddress =
                      getStringAsync(TEMP_CURRENT_ADDRESS);

                  bool currentTempIsCurrentLocation =
                      getBoolAsync(TEMP_IS_CURRENT_LOCATION);

                  setValue(CURRENT_ADDRESS, currentTempAddress);
                  setValue(BOOKING_LATITUDE, currentTempLat);
                  setValue(BOOKING_LONGITUDE, currentTempLong);
                  setValue(LATITUDE, currentTempLat);
                  setValue(LONGITUDE, currentTempLong);
                  setValue(SELECTED_ADDRESS, currentTempSelectedAddress);
                  appStore.isCurrentLocation = currentTempIsCurrentLocation;

                  setValue('cart_items', 0);
                  setValue('item_quantity', 0);
                  setValue('total_price', 0.0);
                  setValue('isButtonEnabled', false);
                  setValue(BOOKING_INFO, "");
                  Navigator.of(context).pop();
                  dbHelper!.deleteAllCartItem().then((value) {
                    appStore.setLoading(false);
                  });
                  appStore.setLoading(false);
                },
              ),
            ],
          );
        });
  }
}
