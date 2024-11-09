import 'package:com.gogospider.booking/component/view_all_label_component.dart';
import 'package:com.gogospider.booking/model/category_model.dart';
import 'package:com.gogospider.booking/screens/category/category_screen.dart';
import 'package:com.gogospider.booking/screens/service/search_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryComponent extends StatefulWidget {
  final List<CategoryData>? mainList;

  CategoryComponent({this.mainList});

  @override
  State<StatefulWidget> createState() => _CategoryComponentState();
}

class _CategoryComponentState extends State<CategoryComponent> {
  UniqueKey key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewAllLabel(
            label: "Services",
            list: widget.mainList!,
            onTap: () {
              CategoryScreen().launch(context).then((value) {
                setStatusBarColor(Colors.transparent);
              });
            },
          ),
          0.height,
          AnimatedWrap(
              key: key,
              runSpacing: 16,
              spacing: 16,
              itemCount: widget.mainList.validate().length,
              listAnimationType: ListAnimationType.Scale,
              scaleConfiguration: ScaleConfiguration(
                  duration: 300.milliseconds, delay: 50.milliseconds),
              itemBuilder: (context, index) {
                CategoryData data = widget.mainList![index];
                return GestureDetector(
                  onTap: () {
                    SearchListScreen(
                            categoryId: data.id.validate(),
                            categoryName: data.name)
                        .launch(context);
                  },
                  child: Container(),
                  // CategoryWidget(categoryData: data)
                );
              }),
        ],
      ),
    );
  }
}
