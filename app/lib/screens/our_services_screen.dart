import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/screens/allow_loaction_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class OurServicesScreen extends StatefulWidget {
  @override
  _OurServicesScreenState createState() => _OurServicesScreenState();
}

class _OurServicesScreenState extends State<OurServicesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double containerWith = (MediaQuery.of(context).size.width / 4);
    double iconWith = (MediaQuery.of(context).size.width / 9);
    double iconHeight = iconWith.validate() + iconWith * 0.05;

    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "យើងមានសេវាកម្មដូចខាងក្រោម",
              style: boldTextStyle(size: 17),
            ),
            Text(
              "We have the following services.",
              style: boldTextStyle(size: 14),
            ),
            10.height,
            Text(
              "សេវាកម្មរហ័ស / Express Services",
              style: boldTextStyle(size: 13),
            ),
            10.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      width: containerWith,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: cardColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image.asset(
                          ic_change_battery,
                          width: iconWith,
                          height: iconHeight,
                        ),
                        5.height,
                        Text(
                          "ផ្លាស់ប្តូរអាគុយ",
                          style: boldTextStyle(size: 12),
                        )
                      ]),
                    ),
                    5.height,
                    Text(
                      "Change Battery",
                      style: secondaryTextStyle(size: 12, color: black),
                    )
                  ],
                ),
                10.width,
                Column(
                  children: [
                    Container(
                      width: containerWith,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: cardColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image.asset(
                          ic_flat_tire,
                          width: iconWith,
                          height: iconHeight,
                        ),
                        5.height,
                        Text(
                          "ប៉ះកង់",
                          style: boldTextStyle(size: 12),
                        )
                      ]),
                    ),
                    5.height,
                    Text(
                      "Flat Tire",
                      style: secondaryTextStyle(size: 12, color: black),
                    )
                  ],
                ),
                10.width,
                Column(
                  children: [
                    Container(
                      width: containerWith,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: cardColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image.asset(
                          ic_gas,
                          width: iconWith,
                          height: iconHeight,
                        ),
                        5.height,
                        Text(
                          "ហ្គាស",
                          style: boldTextStyle(size: 12),
                        )
                      ]),
                    ),
                    5.height,
                    Text(
                      "Gas",
                      style: secondaryTextStyle(size: 12, color: black),
                    )
                  ],
                )
              ],
            ),
            15.height,
            Text(
              "សេវាកម្ម / Services",
              style: boldTextStyle(size: 14),
            ),
            10.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      width: containerWith,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: cardColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image.asset(
                          ic_aircon_service,
                          width: iconWith,
                          height: iconHeight,
                        ),
                        5.height,
                        Text(
                          "ម៉ាស៊ីនត្រជាក់",
                          style: boldTextStyle(size: 12),
                        )
                      ]),
                    ),
                    5.height,
                    Text(
                      "Aircon Service",
                      style: secondaryTextStyle(size: 12, color: black),
                    )
                  ],
                ),
                10.width,
                Column(
                  children: [
                    Container(
                      width: containerWith,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: cardColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image.asset(
                          ic_refrigerator_repair,
                          width: iconWith,
                          height: iconHeight,
                        ),
                        5.height,
                        Text(
                          "ទូទឹកកក",
                          style: boldTextStyle(size: 12),
                        )
                      ]),
                    ),
                    5.height,
                    Text(
                      "Refrigerator",
                      style: secondaryTextStyle(size: 12, color: black),
                    )
                  ],
                ),
                10.width,
                Column(
                  children: [
                    Container(
                      width: containerWith,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: cardColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image.asset(
                          ic_washing_repair,
                          width: iconWith,
                          height: iconHeight,
                        ),
                        5.height,
                        Text(
                          "ម៉ាស៊ីនបោកគក់",
                          style: boldTextStyle(size: 12),
                        )
                      ]),
                    ),
                    5.height,
                    Text(
                      "Washing Machine",
                      style: secondaryTextStyle(size: 12, color: black),
                    )
                  ],
                )
              ],
            ),
            10.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      width: containerWith,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: cardColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image.asset(
                          ic_security_camera_repair,
                          width: iconWith,
                          height: iconHeight,
                        ),
                        5.height,
                        Text(
                          "កាមេរ៉ាសុវត្ថិភាព",
                          style: boldTextStyle(size: 12),
                        )
                      ]),
                    ),
                    5.height,
                    Text(
                      "Camera Security",
                      style: secondaryTextStyle(size: 12, color: black),
                    )
                  ],
                ),
                10.width,
                Column(
                  children: [
                    Container(
                      width: containerWith,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: cardColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image.asset(
                          ic_plumber_service,
                          width: iconWith,
                          height: iconHeight,
                        ),
                        5.height,
                        Text(
                          "សេវាប្រពន្ធទឹក",
                          style: boldTextStyle(size: 12),
                        )
                      ]),
                    ),
                    5.height,
                    Text(
                      "Plimbing Service",
                      style: secondaryTextStyle(size: 12, color: black),
                    )
                  ],
                ),
                10.width,
                Column(
                  children: [
                    Container(
                      width: containerWith,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: cardColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image.asset(
                          ic_electricial_service,
                          width: iconWith,
                          height: iconHeight,
                        ),
                        5.height,
                        Text(
                          "សេវាអគ្គីសនី",
                          style: boldTextStyle(size: 12),
                        )
                      ]),
                    ),
                    5.height,
                    Text(
                      "Electrical Service",
                      style: secondaryTextStyle(size: 12, color: black),
                    )
                  ],
                )
              ],
            ),
            10.height,
            Text(
              "ផលិតផល / Product",
              style: boldTextStyle(size: 14),
            ),
            10.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      width: containerWith,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: cardColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image.asset(
                          ic_air_con,
                          width: iconWith,
                          height: iconHeight,
                        ),
                        5.height,
                        Text(
                          "ម៉ាស៊ីនត្រជាក់",
                          style: boldTextStyle(size: 12),
                        )
                      ]),
                    ),
                    5.height,
                    Text(
                      "Aircon",
                      style: secondaryTextStyle(size: 12, color: black),
                    )
                  ],
                ),
                10.width,
                Column(
                  children: [
                    Container(
                      width: containerWith,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: cardColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image.asset(
                          ic_refrigerator,
                          width: iconWith,
                          height: iconHeight,
                        ),
                        5.height,
                        Text(
                          "ទូទឹកកក",
                          style: boldTextStyle(size: 12),
                        )
                      ]),
                    ),
                    5.height,
                    Text(
                      "Refrigerator",
                      style: secondaryTextStyle(size: 12, color: black),
                    )
                  ],
                ),
                10.width,
                Column(
                  children: [
                    Container(
                      width: containerWith,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: cardColor),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image.asset(
                          ic_washing_machine,
                          width: iconWith,
                          height: iconHeight,
                        ),
                        5.height,
                        Text(
                          "ម៉ាស៊ីនបោកគក់",
                          style: boldTextStyle(size: 12),
                        )
                      ]),
                    ),
                    5.height,
                    Text(
                      "Washing Machine",
                      style: secondaryTextStyle(size: 12, color: black),
                    )
                  ],
                )
              ],
            ),
            15.height,
            Center(
              child: Text(
                "គ្រប់សេវាកម្មក្នុង GoGoSpider App គឺមានការធានាត្រឹមត្រូវ!",
                style: secondaryTextStyle(size: 14, color: black),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
                child:
                    Text("All Services in GoGoSpider are fully guaranties!")),
            100.height,
          ],
        )).paddingAll(15),
        Positioned(
            bottom: 20,
            left: 20,
            child: AppButton(
              textColor: black,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: cardColor,
              child: Text(
                language.back,
                style: boldTextStyle(color: black),
              ),
              onTap: () {
                finish(context);
              },
            )),
        Positioned(
            bottom: 20,
            right: 20,
            child: AppButton(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              color: primaryColor,
              child: Text(
                language.btnNext,
                style: boldTextStyle(color: white),
              ),
              onTap: () {
                AllowLocationScreen().launch(context);
              },
            ))
      ]),
    ));
  }
}
