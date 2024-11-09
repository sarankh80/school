import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryWidget extends StatelessWidget {
  final CategoriesData categoryData;
  final double? width;
  final bool? isFromCategory;

  CategoryWidget({required this.categoryData, this.width, this.isFromCategory});

  @override
  Widget build(BuildContext context) {
    // log(categoryData.toJson());
    return Container(
      width: width ?? context.width() / 3 - 24,
      // decoration: BoxDecoration(
      //   border: Border.all(color: context.dividerColor),
      //   borderRadius: radius(),
      // ),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: context.scaffoldBackgroundColor,
        border: Border.all(color: context.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 0), // Shadow position
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: context.width(),
            height: width != null ? 90 : 75,
            child: categoryData.image.validate().endsWith('.svg')
                ? SvgPicture.network(
                    categoryData.image.validate(),
                    height: 60,
                    fit: BoxFit.contain,
                    color: appStore.isDarkMode
                        ? Colors.white
                        : categoryData.color.toColor(),
                    placeholderBuilder: (context) =>
                        PlaceHolderWidget(width: 60, color: transparentColor),
                  ).paddingAll(5.0)
                : CachedImageWidget(
                    url: categoryData.image.validate(),
                    // width: 60,
                    height: 60,
                    circle: false,
                    fit: BoxFit.contain,
                    // radius: 30,
                  ).paddingOnly(left: 15, right: 15, bottom: 15, top: 15),
          ),
          Marquee(
                  directionMarguee: DirectionMarguee.TwoDirection,
                  child: Text(
                    '${categoryData.name.validate()}',
                    style: boldTextStyle(size: 12),
                    textAlign: TextAlign.center,
                  ).paddingOnly(top: 0, bottom: 15))
              .paddingSymmetric(horizontal: 10, vertical: 0),
        ],
      ),
    );
  }
}
