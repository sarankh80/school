import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/screens/category/menu_fixed.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PubMenu extends StatefulWidget {
  final List<CategoriesData>? category;
  PubMenu({this.category});
  @override
  State<StatefulWidget> createState() => _PubMenuState();
}

class _PubMenuState extends State<PubMenu> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 15,
          bottom: 70,
          child: Container(
            height: 36,
            width: 85,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Color.fromARGB(255, 1, 17, 194),
              child: Row(children: [
                10.width,
                Icon(
                  Icons.menu,
                  size: 18,
                  color: white,
                ),
                5.width,
                Text(
                  language.lblMenu,
                  style: TextStyle(color: white),
                )
              ]),
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.grey.withOpacity(-0.0),
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: radiusOnly(
                          topLeft: defaultRadius, topRight: defaultRadius)),
                  builder: (_) {
                    return Stack(
                      children: [
                        Container(
                          child: Menufixed(category: widget.category),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
