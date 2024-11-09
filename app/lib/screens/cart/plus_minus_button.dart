import 'package:com.gogospider.booking/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;
  final int conditoin;
  const PlusMinusButtons(
      {Key? key,
      required this.conditoin,
      required this.addQuantity,
      required this.deleteQuantity,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? heightCon = (conditoin == 2) ? 44 : 34;
    if (conditoin == 1) {
      return Container(
        height: heightCon,
        width: context.width(),
        alignment: Alignment.topCenter,
        // color: Colors.white,
        child: Row(
          children: [
            IconButton(
              onPressed: deleteQuantity,
              icon: Container(
                child: Icon(Icons.remove, color: Colors.white, size: 18),
              ),
            ).expand(),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: appStore.isDarkMode ? Colors.white : Colors.white,
                  fontSize: 16),
            ).expand(),
            Align(
              child: IconButton(
                onPressed: addQuantity,
                icon: Container(
                  child: Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ).expand(),
          ],
        ),
      );
    } else if (conditoin == 2) {
      return Container(
        height: heightCon,
        width: context.width(),
        alignment: Alignment.topCenter,
        child: Row(
          children: [
            IconButton(
              onPressed: deleteQuantity,
              icon: Container(
                child: Icon(Icons.remove, color: Colors.white, size: 22),
              ),
            ).expand(),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: appStore.isDarkMode ? Colors.white : Colors.white,
                  fontSize: 20),
            ).expand(),
            Align(
              child: IconButton(
                onPressed: addQuantity,
                icon: Container(
                  child: Icon(Icons.add, color: Colors.white, size: 22),
                ),
              ),
            ).expand(),
          ],
        ),
      );
    } else
      return Align(
        alignment: Alignment.topRight,
        child: Row(
          children: [
            Container(
              child: IconButton(
                onPressed: deleteQuantity,
                icon: Container(
                  // width: 20,
                  decoration: boxDecorationWithShadow(
                      boxShape: BoxShape.circle, backgroundColor: Colors.black),
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: appStore.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Container(
              child: IconButton(
                onPressed: addQuantity,
                icon: Container(
                  // width: 20,
                  decoration: boxDecorationWithShadow(
                      boxShape: BoxShape.circle, backgroundColor: Colors.black),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }
}
