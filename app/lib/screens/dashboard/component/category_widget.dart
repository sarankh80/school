import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryData categoryData;
  final double? width;
  final bool? isFromCategory;

  CategoryWidget({required this.categoryData, this.width, this.isFromCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? context.width() / 3 - 24,
      decoration: BoxDecoration(
        border: Border.all(color: context.dividerColor),
        borderRadius: radius(),
      ),
      child: Column(
        children: [
          Container(
            width: context.width(),
            height: width != null ? 115 : 75,
            decoration: boxDecorationDefault(
              boxShadow: defaultBoxShadow(blurRadius: 0, spreadRadius: 0),
              color: context.cardColor,
              borderRadius:
                  radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
            ),
            child: categoryData.categoryImage.validate().endsWith('.svg')
                ? SvgPicture.network(
                    categoryData.categoryImage.validate(),
                    height: 60,
                    width: 60,
                    color: appStore.isDarkMode
                        ? Colors.white
                        : categoryData.color.toColor(),
                    placeholderBuilder: (context) => PlaceHolderWidget(
                        height: 60, width: 60, color: transparentColor),
                  ).paddingAll(16.0)
                : CachedImageWidget(
                    url: categoryData.categoryImage.validate(),
                    width: context.width(),
                    height: 60 + 32,
                    circle: false,
                  ).cornerRadiusWithClipRRectOnly(
                    topRight: defaultRadius.toInt(),
                    topLeft: defaultRadius.toInt()),
          ),
          Text(
            '${categoryData.name.validate()}',
            style: boldTextStyle(size: 12),
            textAlign: TextAlign.center,
          ).paddingSymmetric(vertical: 16),
        ],
      ),
    );
  }
}
