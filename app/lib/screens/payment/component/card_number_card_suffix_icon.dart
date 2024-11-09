import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/images.dart';

class CardNumberSuffixIconComponent extends StatelessWidget {
  final CardSystemData? cardData;
  final String? iconCard = ic_visa_card;

  CardNumberSuffixIconComponent({required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(right: 10),
            child: iconCard!.endsWith('.svg')
                ? SvgPicture.asset(
                    iconCard!,
                    width: 5,
                    fit: BoxFit.contain,
                  )
                : iconCard!.iconImage())
        .paddingAll(5);
  }
}
