import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/background_component.dart';
import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/component/error_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/cart/view_cart.dart';
import 'package:com.gogospider.booking/screens/category/component/category_widget.dart';
import 'package:com.gogospider.booking/screens/filter/filter_screen.dart';
import 'package:com.gogospider.booking/screens/service/component/service_component.dart';
import 'package:com.gogospider.booking/screens/service/component/subcategory_component.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SearchListScreenOld extends StatefulWidget {
  final String? categoryName;
  final String isFeatured;
  final bool isFromProvider;
  final bool isFromCategory;
  final bool isFromSearch;
  final int? providerId;
  final CategoriesData? categoriesData;
  int? categoryId;
  SearchListScreenOld(
      {this.categoryId,
      this.categoryName = '',
      this.isFromSearch = false,
      this.isFeatured = '',
      this.isFromProvider = true,
      this.isFromCategory = false,
      this.providerId,
      this.categoriesData});

  @override
  SearchListScreenState createState() => SearchListScreenState();
}

class SearchListScreenState extends State<SearchListScreenOld> {
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

  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().getData();
    LiveStream().on(LIVESTREAM_UPDATE_SERVICE_LIST, (p0) {
      var a = p0 as List;
      // subCategory = a[0] as String;
      widget.categoryId = a[0] as int;
      brand = "-1";
      brand = a[1] as String;
      page = 1;

      setState(() {});
      fetchAllServiceData();
    });
    afterBuildCreated(() {
      if (widget.categoriesData?.children == null) {
      } else {
        if (widget.categoriesData!.children!.length > 0) {
          widget.categoryId = widget.categoriesData!.children![0].id.validate();
          if (widget.categoriesData!.children![0].brands!.isNotEmpty) {
            brand =
                widget.categoriesData!.children![0].brands![0].id.toString();
          }
        }
      }
      init();
    });
  }

  void init() async {
    if (filterStore.search.isNotEmpty) {
      filterStore.setSearch('');
    }
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

  String get setSearchString {
    if (!widget.categoryName.isEmptyOrNull) {
      return widget.categoryName!;
    } else if (widget.isFeatured == "1") {
      return language.lblFeatured;
    } else {
      return language.allServices;
    }
  }

  Future<void> fetchAllServiceData() async {
    appStore.setLoading(true);

    filterStore.setLatitude(getDoubleAsync(LATITUDE).toString());
    filterStore.setLongitude(getDoubleAsync(LONGITUDE).toString());

    String categoryId() {
      if (filterStore.categoryId.isNotEmpty) {
        return filterStore.categoryId.join(",");
      } else {
        if (widget.categoryId != null) {
          return widget.categoryId.toString();
        } else {
          return "";
        }
      }
    }

    await getSearchListServices(
            categoryId: categoryId(),
            providerId: widget.providerId != null
                ? widget.providerId.toString()
                : filterStore.providerId.join(","),
            handymanId: filterStore.handymanId.join(","),
            isPriceMin: filterStore.isPriceMin,
            isPriceMax: filterStore.isPriceMax,
            search: filterStore.search,
            latitude: filterStore.latitude,
            longitude: filterStore.longitude,
            isFeatured: widget.isFeatured,
            page: page,
            subCategory: subCategory.toString(),
            brandId: brand.toString())
        .then((value) async {
      appStore.setLoading(false);

      if (page == 1) {
        mainList.clear();
      }
      isLastPage = value.serviceList.validate().length != PER_PAGE_ITEM;
      mainList.addAll(value.serviceList.validate());

      if (widget.isFromSearch && !isApiCalled && mainList.isNotEmpty) {
        await 1.seconds.delay;
        myFocusNode.requestFocus();
      }
      isApiCalled = true;
      isError = "";
      setState(() {});
    }).catchError((e) {
      isError = e;
      isApiCalled = true;
      appStore.setLoading(false);
      print(e.toString());
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
        setSearchString,
        textColor: Colors.white,
        color: context.primaryColor,
        backWidget: BackWidget(),
        // actions: [
        //   commonLocationWidget(
        //     onTap: () {
        //       page = 1;
        //       fetchAllServiceData();
        //     },
        //     context: context,
        //     color:
        //         appStore.isCurrentLocation ? Colors.lightGreen : Colors.white,
        //   ).paddingRight(16),
        // ],
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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.categoriesData == null)
                    Container()
                  else if (widget.categoriesData!.children!.length > 0)
                    SubCategoryComponent(
                      catId: widget.categoryId,
                      onDataLoaded: (bool val) async {
                        appStore.setLoading(false);
                      },
                      categoriesData: widget.categoriesData,
                    ),
                  16.height,
                  if (widget.categoryId == 0)
                    AnimatedWrap(
                      itemCount: widget.categoriesData!.children!.length,
                      itemBuilder: (_, index) {
                        CategoriesData children =
                            widget.categoriesData!.children![index];
                        // log(children.toJson());

                        String brandId = children.brands!.length > 0
                            ? children.brands![0].id.validate().toString()
                            : '-1';
                        int catSubID = children.id.validate();
                        if (children.children!.length > 0) {
                          // log(children.children);
                          catSubID = children.children![0].id.validate();
                        }

                        return (children.home == false && isError == "")
                            ? GestureDetector(
                                onTap: () {
                                  log("AAAAA ${children.toJson()}");
                                  setState(() {
                                    // var catID = children.id.validate();
                                    filterStore.setSelectedSubCategory(
                                        catId: index);
                                    hideKeyboard(context);
                                    // subBrandList = children.brands.validate();
                                    // subCategoriesData = children;
                                    LiveStream().emit(
                                        LIVESTREAM_UPDATE_SERVICE_LIST,
                                        [catSubID, brandId]);
                                    filterStore.setSelectedSubBrand(brandId: 0);
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: CategoryWidget(
                                      categoryData: widget
                                          .categoriesData!.children![index],
                                      width: context.width() / 3 - 24),
                                ),
                              )
                            : SizedBox();
                      },
                    ),
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
                  70.height,
                ],
              ),
            ).paddingTop((widget.isFromSearch == true) ? 70 : 0),
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
            ),
            Observer(
                builder: (BuildContext context) =>
                    LoaderWidget().visible(appStore.isLoading.validate())),
            (widget.isFromSearch == true)
                ? Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        AppTextField(
                          textFieldType: TextFieldType.OTHER,
                          focus: myFocusNode,
                          controller: searchCont,
                          suffix: CloseButton(
                            onPressed: () {
                              page = 1;
                              searchCont.clear();
                              filterStore.setSearch('');
                              fetchAllServiceData();
                            },
                          ).visible(searchCont.text.isNotEmpty),
                          onFieldSubmitted: (s) {
                            page = 1;

                            filterStore.setSearch(s);
                            fetchAllServiceData();
                          },
                          decoration: inputDecoration(context).copyWith(
                            hintText:
                                "${language.lblSearchFor} $setSearchString",
                            prefixIcon:
                                ic_search.iconImage(size: 10).paddingAll(14),
                            hintStyle: secondaryTextStyle(),
                          ),
                        ).expand(),
                        16.width,
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration:
                              boxDecorationDefault(color: context.primaryColor),
                          child: CachedImageWidget(
                            url: ic_filter,
                            height: 26,
                            width: 26,
                            color: Colors.white,
                          ),
                        ).onTap(() {
                          hideKeyboard(context);

                          FilterScreen(isFromProvider: widget.isFromProvider)
                              .launch(context)
                              .then((value) {
                            if (value != null) {
                              page = 1;
                              fetchAllServiceData();
                            }
                          });
                        }, borderRadius: radius())
                      ],
                    ),
                  )
                : Container(),
            if (widget.isFromSearch == false)
              Consumer<CartProvider>(
                builder: (BuildContext context, value, widget) {
                  if (getIntAsync("cart_items") != 0)
                    return ViewCart();
                  else
                    return Container();
                },
              )
          ],
        ),
      ),
    );
  }
}
