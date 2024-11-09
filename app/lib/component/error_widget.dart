import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

class ErrorsWidget extends StatelessWidget {
  final Function()? onPressed;
  final String? errortext;

  ErrorsWidget({this.onPressed, this.errortext});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(error, width: MediaQuery.of(context).size.width),
        25.height,
        Text(
          errortext!,
          style: boldTextStyle(size: 16, height: 2),
          textAlign: TextAlign.center,
        ),
        35.height,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 13),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Text(
            language.reload,
            style: boldTextStyle(color: white),
          ),
        ).onTap(() async {
          onPressed?.call();
        })
      ],
    );
  }
}
