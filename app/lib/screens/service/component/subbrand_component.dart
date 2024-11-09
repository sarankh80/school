import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/brand_model.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:async/async.dart';

class SubBrandComponent extends StatefulWidget {
  final int? catId;
  final Function(bool val) onDataLoaded;
  final List<BrandResponse>? brandList;

  SubBrandComponent(
      {required this.catId, required this.onDataLoaded, this.brandList});

  @override
  _SubBrandComponentState createState() => _SubBrandComponentState();
}

class _SubBrandComponentState extends State<SubBrandComponent> {
  AsyncMemoizer<CategoriesData> asyncMemoizer = AsyncMemoizer();

  // List<CategoriesData> subCatList = [];
  CategoriesData allValue = CategoriesData(id: -1, name: "All");

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    appStore.setLoading(true);
    // await getCategoriesListID(catId: widget.catId.validate()).then((value) {
    //   subCatList = value.categoriesList.validate();
    //   setState(() {});
    // });
    // log("Cat ID : ${widget.catId.toString()}");
    appStore.setLoading(false);
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
        12.height,
        if (widget.brandList != null)
          HorizontalList(
            // itemCount: subCatList.length,
            itemCount: widget.brandList!.length,
            padding: EdgeInsets.only(left: 16, right: 16),
            itemBuilder: (_, index) {
              BrandResponse data = widget.brandList![index];
              // return Observer(
              //   builder: (_) {
              bool isSelected = filterStore.selectedSubBrandId == index;
              return GestureDetector(
                onTap: () {
                  appStore.isLoading = true;
                  setState(() {
                    filterStore.setSelectedSubBrand(brandId: index);
                    hideKeyboard(context);
                    LiveStream().emit(LIVESTREAM_UPDATE_SERVICE_LIST,
                        [widget.catId, data.id.validate().toString()]);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isSelected ? Colors.red : Colors.white,
                      border: Border.all(color: Colors.red, width: 1)),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Text(
                    data.name.validate(),
                    style: boldTextStyle(
                        size: 15,
                        color:
                            isSelected ? Colors.white : textPrimaryColorGlobal),
                  ),
                ),
              );
              // },
              // );
            },
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
