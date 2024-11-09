import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/error_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/screens/category/component/category_widget.dart';
import 'package:com.gogospider.booking/screens/service/item_list_screen.dart';
import 'package:com.gogospider.booking/screens/service/search_list_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryList extends StatefulWidget {
  final int? categoryId;
  final int? parentId;
  final String? title;
  CategoryList({this.categoryId, this.title, this.parentId});
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  ScrollController scrollController = ScrollController();
  UniqueKey key = UniqueKey();

  int page = 1;
  List<CategoriesData> mainCatList = [];

  bool isEnabled = false;
  bool isLastPage = false;
  bool fabIsVisible = true;
  String? isError = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    fetchAllCategoryData();
    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
    });
  }

  Future fetchAllCategoryData() async {
    appStore.setLoading(true);
    await getCategoriesListByID(catId: widget.categoryId.validate())
        .then((value) {
      mainCatList = value.categoriesList.validate();
      // mainCatList
      //     .sort((a, b) => a.name.toString().compareTo(b.name.toString()));
      isLastPage = value.categoriesList!.length != PER_PAGE_ITEM;
      isError = "";
      setState(() {});
    }).catchError((error) {
      // maybe do something here
      isError = error;
      setState(() {});
      throw error;
    });

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
    return RefreshIndicator(
      onRefresh: () async {
        // page = 1;
        return await fetchAllCategoryData();
      },
      child: Scaffold(
        appBar: appBarWidget(
          widget.title != null ? widget.title.validate() : language.lblCategory,
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
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        AnimatedWrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          key: key,
                          runSpacing: 0,
                          itemCount: mainCatList.length,
                          listAnimationType: ListAnimationType.Scale,
                          itemBuilder: (_, index) {
                            CategoriesData data = mainCatList[index];
                            if (widget.parentId != data.parentId &&
                                data.id == 26) {
                              return Container(
                                width: 0,
                              );
                            } else
                              return GestureDetector(
                                onTap: () {
                                  if (data.countChild! > 0) {
                                    SearchListScreen(
                                      categoryId: data.id.validate(),
                                      categoryName: data.name,
                                      categoriesData: data,
                                    ).launch(context);
                                  } else {
                                    ItemListScreen(
                                      categoryId: data.id.validate(),
                                      categoryName: data.name,
                                    ).launch(context);
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  child: CategoryWidget(
                                      categoryData: data,
                                      width: context.width() / 3 - 24),
                                ),
                              );
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
}
