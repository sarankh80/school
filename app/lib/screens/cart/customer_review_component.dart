import 'package:com.gogospider.booking/component/image_border_component.dart';
import 'package:com.gogospider.booking/component/view_all_label_component.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/screens/service/search_list_screen.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomerReviewsComponent extends StatelessWidget {
  CustomerReviewsComponent();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            child: ViewAllLabel(
              label: language.lblCustomerReviews,
              labelSize: 16,
              onTap: () {
                SearchListScreen().launch(context);
              },
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 10),
              alignment: Alignment.centerLeft,
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: ImageBorder(
                          src: "https://gogospider.com/images/user/user.png",
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Donna Bins" + " 02 Des",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(
                              top: 5, left: 10, right: 10, bottom: 10),
                          child: Row(
                            children: [
                              Image.asset('assets/icons/ic_star_fill.png',
                                  height: 14, color: getRatingBarColor(3)),
                              Image.asset('assets/icons/ic_star_fill.png',
                                  height: 14, color: getRatingBarColor(3)),
                              Image.asset('assets/icons/ic_star_fill.png',
                                  height: 14, color: getRatingBarColor(3)),
                              Image.asset('assets/icons/ic_star_fill.png',
                                  height: 14, color: getRatingBarColor(3)),
                              4.width,
                              Text("40.50", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      width: 5,
                    ),
                  ],
                ),
              )),
          Container(
            padding: EdgeInsets.only(left: 95, right: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Amit Minim Mellit non desert ullamco Est sit silique dolor amen",
                style: TextStyle(fontSize: 14),
              ),
            ),
          )
        ],
      ),
    );
  }
}
