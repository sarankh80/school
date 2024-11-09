import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/background_component.dart';
import 'package:com.gogospider.booking/component/error_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/category/component/category_widget.dart';
import 'package:com.gogospider.booking/screens/service/item_list_screen.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SearchListScreen extends StatefulWidget {
  final String? categoryName;
  final String? isFeatured;
  final bool? isFromProvider;
  final bool? isFromCategory;
  final bool? isFromSearch;
  final int? providerId;
  final CategoriesData? categoriesData;
  int? categoryId;
  SearchListScreen(
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

class SearchListScreenState extends State<SearchListScreen> {
  FocusNode myFocusNode = FocusNode();

  ScrollController scrollController = ScrollController();

  TextEditingController searchCont = TextEditingController();

  int page = 1;
  List<CategoriesData>? categoriesList = [];

  bool isEnabled = false;
  bool isLastPage = false;
  bool fabIsVisible = true;
  bool isSubCategoryLoaded = false;
  bool isApiCalled = false;

  String? subCategory = '0';
  String? brand = '-1';
  @observable
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
      fetchCategory();
    });
    afterBuildCreated(() {
      init();
    });
  }

  void init() async {
    fetchCategory();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!isLastPage) {
          page++;
          fetchCategory();
        }
      }
    });
  }

  Future<void> fetchCategory() async {
    appStore.setLoading(true);
    await getCategoriesListByID(catId: widget.categoryId.validate())
        .then((value) {
      categoriesList = value.categoriesList!;

      // if (value.categoriesList!.length <= 0) {
      //   // ItemListScreen(
      //   //   categoryId: widget.categoryId,
      //   //   categoryName: widget.categoryName,
      //   // ).launch(context);
      //   Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //           builder: (BuildContext context) => ItemListScreen(
      //               categoryId: widget.categoryId,
      //               categoryName: widget.categoryName)));
      // }

      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      isError = e.toString();
      isApiCalled = true;
      appStore.setLoading(false);
      print("Error Connection ${e.toString()}");
      toast(e.toString());
    });
  }

  void onTap(int countChild, CategoriesData? children) {
    if (countChild > 0) {
      SearchListScreen(
        categoryId: children!.id,
        categoryName: children.name,
      ).launch(context);
      setState(() {});
    } else {
      ItemListScreen(
        categoryId: widget.categoryId,
        categoryName: widget.categoryName,
      ).launch(context);
    }
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            page = 1;
            return await fetchCategory();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (categoriesList!.length > 0)
                      AnimatedWrap(
                        itemCount: categoriesList!.length,
                        itemBuilder: (_, index) {
                          CategoriesData children = categoriesList![index];
                          return GestureDetector(
                            onTap: () {
                              if (children.countChild! > 0) {
                                SearchListScreen(
                                  categoryId: children.id,
                                  categoryName: children.name,
                                ).launch(context);
                              } else {
                                ItemListScreen(
                                        categoryId: children.id,
                                        categoryName: children.name)
                                    .launch(context);
                              }

                              setState(() {});
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: CategoryWidget(
                                  categoryData: children,
                                  width: context.width() / 3 - 24),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ).paddingTop(0),
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
                              !appStore.isLoading &&
                              widget.categoryId != 0);
                },
              ).visible(!appStore.isLoading.validate()),
              Observer(
                  builder: (BuildContext context) =>
                      LoaderWidget().visible(appStore.isLoading.validate())),
            ],
          ),
        ),
      ),
    );
  }
}
