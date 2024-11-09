import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:flutter/material.dart';

class ExcludedCompenent extends StatefulWidget {
  final ServiceData? serviceDetail;
  const ExcludedCompenent({required this.serviceDetail, Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ExcludedCompenentState();
}

class _ExcludedCompenentState extends State<ExcludedCompenent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 16, right: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Text(
              language.lblExcluded,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: appStore.isDarkMode ? Colors.white : Colors.black),
            )),
        Container(
          child: Row(children: [
            SizedBox(
              // height: 20,
              width: 10,
              child: Text(
                // "\u2022",
                "",
                style: TextStyle(
                    fontSize: 25,
                    color: appStore.isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            Expanded(
              child: Text(
                "${widget.serviceDetail?.excluded}",
                textAlign: TextAlign.left,
                softWrap: true,
                style: TextStyle(
                    fontSize: 14,
                    color: appStore.isDarkMode ? Colors.white : Colors.black),
              ),
            ),
          ]),
        ),
        // Container(
        //   child: Row(children: [
        //     SizedBox(
        //       height: 50,
        //       width: 20,
        //       child: Text(
        //         "\u2022",
        //         style: TextStyle(
        //             fontSize: 25,
        //             color: appStore.isDarkMode ? Colors.white : Colors.black),
        //       ),
        //     ),
        //     Expanded(
        //       child: Text(
        //         "Drilling, Wiring Connections, Installation of The Unit(S), Pipe Fixes",
        //         style: TextStyle(
        //             fontSize: 14,
        //             color: appStore.isDarkMode ? Colors.white : Colors.black),
        //       ),
        //     ),
        //   ]),
        // ),
        // Container(
        //   child: Row(children: [
        //     SizedBox(
        //       height: 50,
        //       width: 20,
        //       child: Text(
        //         "\u2022",
        //         style: TextStyle(
        //             fontSize: 25,
        //             color: appStore.isDarkMode ? Colors.white : Colors.black),
        //       ),
        //     ),
        //     Expanded(
        //       child: Text(
        //         "Comprehensive Checkup and Gas Check to Prevent Malfunction/Leakages",
        //         style: TextStyle(
        //             fontSize: 14,
        //             color: appStore.isDarkMode ? Colors.white : Colors.black),
        //       ),
        //     ),
        //   ]),
        // ),
        // Container(
        //   child: Row(children: [
        //     SizedBox(
        //       height: 50,
        //       width: 20,
        //       child: Text(
        //         "\u2022",
        //         style: TextStyle(
        //             fontSize: 25,
        //             color: appStore.isDarkMode ? Colors.white : Colors.black),
        //       ),
        //     ),
        //     Expanded(
        //       child: Text(
        //         "Cooling Rate and Device Functioning Check, Clean Up of AC & Surrounding Area",
        //         style: TextStyle(
        //             fontSize: 14,
        //             color: appStore.isDarkMode ? Colors.white : Colors.black),
        //       ),
        //     ),
        //   ]),
        // ),
      ]),
    );
  }
}
