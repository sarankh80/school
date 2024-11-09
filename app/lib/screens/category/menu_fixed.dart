import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/screens/booking/component/booking_service_location_filter.dart';
import 'package:com.gogospider.booking/screens/service/search_list_screen.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'component/category_widget.dart';

class Menufixed extends StatefulWidget {
  final List<CategoriesData>? category;
  Menufixed({this.category});

  @override
  _MenufixdeState createState() => _MenufixdeState();
}

class _MenufixdeState extends State<Menufixed> {
  UniqueKey key = UniqueKey();
  ScrollController scrollController = ScrollController();
  List<CategoriesData> mainCatList = [];

  bool isEnabled = false;
  bool isLastPage = false;
  bool fabIsVisible = true;

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
    await getCategoriesList().then((value) {
      mainCatList = value.categoriesList.validate();
      isLastPage = value.categoriesList!.length != PER_PAGE_ITEM;

      setState(() {});
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
    print("mainCatList $mainCatList");
    return Container(
      color: transparentColor,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5, right: 5),
              alignment: Alignment.topRight,
              child: InkWell(
                child: Icon(Icons.close_rounded, size: 30, color: white),
                onTap: () => Navigator.pop(context),
              ),
            ),
            Container(
              width: context.width(),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              // child: MenuComponent(categoryList: mainCatList),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedWrap(
                          runSpacing: 0,
                          spacing: 18,
                          itemCount: widget.category != null
                              ? widget.category!.length
                              : 0,
                          listAnimationType: ListAnimationType.Scale,
                          itemBuilder: (_, index) {
                            return Container(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 0, top: 20),
                                    child: Container(
                                      padding: EdgeInsets.only(right: 0),
                                      child: CategoryWidget(
                                          categoryData:
                                              widget.category![index]),
                                    ).onTap(() {
                                      if (getStringAsync(BOOKING_INFO) != "") {
                                        SearchListScreen(
                                          categoryId: widget.category![index].id
                                              .validate(),
                                          categoryName:
                                              widget.category![index].name,
                                          categoriesData:
                                              widget.category![index],
                                        ).launch(context);
                                      } else {
                                        BookingServiceLocationFilter(
                                          categoryData: widget.category![index],
                                        ).launch(context);
                                      }
                                    }),
                                  ),
                                ],
                              ),
                            );
                          })
                    ]),
              ),
              padding: EdgeInsets.only(bottom: 20),
            ),
          ],
        ),
      ),
    );
  }
}
