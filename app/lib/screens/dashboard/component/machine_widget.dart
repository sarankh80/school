import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

class MachineWidget extends StatelessWidget {
  final CategoriesData categoryData;
  final double? width;
  final bool? isFromCategory;

  MachineWidget({required this.categoryData, this.width, this.isFromCategory});

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
              // color: context.cardColor,
              borderRadius:
                  radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
            ),
            child: categoryData.image.validate().endsWith('.svg')
                ? SvgPicture.network(
                    categoryData.image.validate(),
                    height: 60,
                    width: 60,
                  ).paddingAll(16.0)
                : CachedImageWidget(
                    url: categoryData.image.validate(),
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
          ).paddingSymmetric(vertical: 10),
        ],
      ),
    );
  }
}
