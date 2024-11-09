import 'package:com.gogospider.booking/component/view_all_label_component.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/screens/booking/component/booking_service_location_filter.dart';
import 'package:com.gogospider.booking/screens/category/category_list.dart';
import 'package:com.gogospider.booking/screens/category/component/category_widget.dart';
import 'package:com.gogospider.booking/screens/service/item_list_screen.dart';
import 'package:com.gogospider.booking/screens/service/search_list_screen.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class MenuComponent extends StatefulWidget {
  final List<CategoriesData>? categoryList;
  final int? id;
  MenuComponent({this.categoryList, this.id});

  @override
  State<StatefulWidget> createState() => _MenuComponentState();
}

class _MenuComponentState extends State<MenuComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
              // if (widget.id == data.id)
              return data.children!.length > 0
                  ? Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 0, top: 0),
                            child: ViewAllLabel(
                              labelSize: 17,
                              label: data.name.validate(),
                              list: data.children,
                              onTap: () {
                                CategoryList(
                                  categoryId: data.id,
                                  title: data.name.validate(),
                                  parentId: data.id,
                                ).launch(context);
                                // if (getDoubleAsync(BOOKING_LATITUDE) != 0.00 &&
                                //     getDoubleAsync(BOOKING_LONGITUDE) != 0.00) {
                                //   // SearchListScreen().launch(context);
                                //   MenuComponentList(
                                //           categoryList: widget.categoryList,
                                //           id: widget.id)
                                //       .launch(context);
                                // } else {
                                //   BookingServiceLocationFilter(
                                //           categoryData: widget.categoryList![1],
                                //           isCat: 1)
                                //       .launch(context);
                                // }
                              },
                            ),
                          ),
                          HorizontalList(
                            itemCount: data.children!.length,
                            spacing: 0,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            itemBuilder: (context, index) {
                              CategoriesData children = data.children![index];

                              if (children.parentId != data.id ||
                                  children.id == 26) {
                                return Container(
                                  width: 0,
                                );
                              } else
                                return GestureDetector(
                                  onTap: () {
                                    if (getDoubleAsync(BOOKING_LATITUDE) !=
                                            0.00 &&
                                        getDoubleAsync(BOOKING_LONGITUDE) !=
                                            0.00) {
                                      if (children.countChild! > 0) {
                                        SearchListScreen(
                                          categoryId: children.id.validate(),
                                          categoryName: children.name,
                                          categoriesData: children,
                                        ).launch(context);
                                      } else {
                                        ItemListScreen(
                                          categoryId: children.id.validate(),
                                          categoryName: children.name,
                                        ).launch(context);
                                      }
                                    } else {
                                      BookingServiceLocationFilter(
                                        categoryData: children,
                                      ).launch(context);
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(right: 15),
                                    child:
                                        CategoryWidget(categoryData: children),
                                  ),
                                );
                            },
                          ),
                        ],
                      ),
                    )
                  : 1.height;
              // else {
              //   return Container();
              // }
            },
          ),
        ],
      ),
    );
  }
}
