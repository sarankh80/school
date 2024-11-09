import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/brand_model.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/screens/service/component/subbrand_component.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class Sub1CategoryComponent extends StatefulWidget {
  final int? catId;
  final Function(bool val) onDataLoaded;
  final CategoriesData? categoriesData;

  Sub1CategoryComponent(
      {required this.catId, required this.onDataLoaded, this.categoriesData});

  @override
  _Sub1CategoryComponentState createState() => _Sub1CategoryComponentState();
}

class _Sub1CategoryComponentState extends State<Sub1CategoryComponent> {
  // AsyncMemoizer<CategoryResponse> _asyncMemoizer = AsyncMemoizer();
  List<CategoriesData> subCatList = [];
  List<BrandResponse> subBrandList = [];
  CategoriesData? subCategoriesData;

  CategoriesData allValue = CategoriesData(id: -1, name: "All");
  int catID = -1;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // appStore.setLoading(true);
    // await getCategoriesListID(catId: widget.catId.validate()).then((value) {
    //   subCatList = value.categoriesList.validate();
    //   setState(() {});
    // });
    // appStore.setLoading(false);
    if (widget.categoriesData!.children!.length > 0)
      subBrandList = widget.categoriesData!.children![0].brands.validate();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    // if (subCatList.contains(allValue)) {
    //   subCatList.insert(0, allValue);
    // }
    // widget.onDataLoaded.call(true);
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: context.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 4,
                offset: Offset(0, 2), // Shadow position
              ),
            ],
          ),
          child: HorizontalList(
            // itemCount: subCatList.length,
            itemCount: widget.categoriesData!.children!.length,
            padding: EdgeInsets.only(left: 16, right: 16),
            itemBuilder: (_, index) {
              // CategoriesData data = subCatList[index];
              CategoriesData data = widget.categoriesData!.children![index];
              String brandId = data.brands!.length > 0
                  ? data.brands![0].id.validate().toString()
                  : '-1';
              return Observer(
                builder: (_) {
                  bool isSelected = filterStore.selectedSub1CategoryId == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        catID = data.id.validate();
                        filterStore.setSelectedSub1Category(catId: index);
                        hideKeyboard(context);
                        subBrandList = data.brands.validate();
                        subCategoriesData = data;
                        LiveStream().emit(LIVESTREAM_UPDATE_SERVICE_LIST,
                            [data.id.validate(), brandId]);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                            width: 3.0,
                            color: isSelected ? Colors.red : Colors.white),
                      )),
                      padding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                      child: Text(
                        data.name.validate(),
                        style: boldTextStyle(
                            size: 18,
                            color: isSelected
                                ? Colors.red
                                : textPrimaryColorGlobal),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (subBrandList.length > 0)
          SubBrandComponent(
            catId: widget.catId != -1 ? widget.catId : -1,
            onDataLoaded: (bool val) async {
              appStore.setLoading(false);
            },
            brandList: subBrandList,
          ),
      ]),
    );
    // FutureBuilder<CategoryResponse>(
    //   future: _asyncMemoizer
    //       .runOnce(() => getSubCategoryList(catId: widget.catId.validate())),
    //   builder: (context, snap) {
    //     if (snap.hasData) {
    //       if (snap.data!.categoryList!.isEmpty) {
    //         widget.onDataLoaded.call(false);
    //         return Offstage();
    //       } else {
    //         if (!snap.data!.categoryList!.contains(allValue)) {
    //           snap.data!.categoryList!.insert(0, allValue);
    //         }
    //         widget.onDataLoaded.call(true);

    //         return Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             16.height,
    //             Text(language.lblSubcategories,
    //                     style: boldTextStyle(size: LABEL_TEXT_SIZE))
    //                 .paddingLeft(16),
    //             HorizontalList(
    //               itemCount: snap.data!.categoryList.validate().length,
    //               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //               itemBuilder: (_, index) {
    //                 CategoryData data = snap.data!.categoryList![index];
    //                 return Observer(
    //                   builder: (_) {
    //                     bool isSelected =
    //                         filterStore.selectedSubCategoryId == index;

    //                     return ChoiceChip(
    //                       label: Text(data.name.validate(),
    //                           style: primaryTextStyle(
    //                               color: isSelected
    //                                   ? Colors.white
    //                                   : textPrimaryColorGlobal)),
    //                       selected: isSelected,
    //                       selectedColor: primaryColor,
    //                       side: BorderSide(color: primaryColor),
    //                       onSelected: (bool selected) {
    //                         hideKeyboard(context);
    //                         filterStore.setSelectedSubCategory(catId: index);
    //                         LiveStream().emit(LIVESTREAM_UPDATE_SERVICE_LIST,
    //                             data.id.validate());
    //                       },
    //                       backgroundColor: context.scaffoldBackgroundColor,
    //                       labelStyle: TextStyle(color: Colors.white),
    //                     );
    //                   },
    //                 );
    //               },
    //             ),
    //           ],
    //         );
    //       }
    //     }
    //     return snapWidgetHelper(snap, loadingWidget: Offstage());
    //   },
    // );
  }
}