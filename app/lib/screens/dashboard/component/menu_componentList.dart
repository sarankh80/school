import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/screens/booking/component/booking_service_location_filter.dart';
import 'package:com.gogospider.booking/screens/category/component/category_widget.dart';
import 'package:com.gogospider.booking/screens/service/search_list_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class MenuComponentList extends StatefulWidget {
  final List<CategoriesData>? categoryList;
  final int? id;
  MenuComponentList({this.categoryList, this.id});

  @override
  State<StatefulWidget> createState() => _MenuComponentListState();
}

class _MenuComponentListState extends State<MenuComponentList> {
  ScrollController scrollController = ScrollController();
  UniqueKey key = UniqueKey();

  int page = 1;
  List<CategoriesData> mainCatList = [];

  bool isEnabled = false;
  bool isLastPage = false;
  bool fabIsVisible = true;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // page = 1;
        // return await fetchAllCategoryData();
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
            SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedWrap(
                            runSpacing: 0,
                            spacing: 18,
                            itemCount: widget.categoryList!.length,
                            listAnimationType: ListAnimationType.Scale,
                            itemBuilder: (_, index) {
                              CategoriesData data = widget.categoryList![index];
                              if (widget.id == data.id)
                                return data.children!.length > 0
                                    ? Container(
                                        child: Column(
                                          children: [
                                            AnimatedWrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              runSpacing: 0,
                                              listAnimationType:
                                                  ListAnimationType.Scale,
                                              itemCount: data.children!.length,
                                              spacing: 0,
                                              itemBuilder: (context, index) {
                                                CategoriesData children =
                                                    data.children![index];
                                                if (children.parentId !=
                                                        data.id ||
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
                                                          SearchListScreen(
                                                            categoryId: children
                                                                .id
                                                                .validate(),
                                                            categoryName:
                                                                children.name,
                                                            categoriesData:
                                                                children,
                                                          ).launch(context);
                                                        } else {
                                                          BookingServiceLocationFilter(
                                                            categoryData:
                                                                children,
                                                          ).launch(context);
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 16),
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 15),
                                                        child: CategoryWidget(
                                                            categoryData:
                                                                children),
                                                      ));
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : 1.height;
                              else {
                                return Container();
                              }
                            },
                          ),
                        ],
                      ),
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
