import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/booking_data_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class BookingSuccessfulDialog extends StatefulWidget {
  BookingSuccessfulDialog();
  @override
  State<BookingSuccessfulDialog> createState() =>
      _BookingSuccessfulDialogState();
}

class _BookingSuccessfulDialogState extends State<BookingSuccessfulDialog> {
  DBHelper? dbHelper = DBHelper();

  String bookingLabel = "";

  Future<void> bookServices() async {
    bookingLabel = language.lblBookingProcessing;
    // var listCart = await getCartResponse();
    // if (listCart.id != null) {
    // List<Items>? itemBooking = listCart.items;
    // List itemCart = itemBooking!.map((e) {
    //   return {
    //     "service_id": e.product!.id,
    //     "quantity": e.quantity!.value,
    //     "discount": e.discountAmount,
    //     "total": e.total
    //   };
    // }).toList();
    // Map request = {
    //   "service_id": listCart.id,
    //   "coupon_id": listCart.couponCode,
    //   "customer_id": appStore.userId != null
    //       ? appStore.userId.validate()
    //       : listCart.customer?.id.validate(),
    //   "amount": listCart.grandTotal,
    //   "total_amount": listCart.grandTotal,
    //   "date": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    //   "items": itemCart
    // };
    appStore.setLoading(true);
    Map requestBooking = {
      "date": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "latitude": getDoubleAsync(BOOKING_LATITUDE).toString(),
      "longitude": getDoubleAsync(BOOKING_LONGITUDE).toString(),
      "address_id": getIntAsync(SELECTED_ADDRESS),
      "booking_date": "",
      "booking_date_time": "",
      "booking_time": "",
    };
    String stringBookingInfo = getStringAsync(BOOKING_INFO);
    if (stringBookingInfo != "") {
      List<BookingInfo> bookingInfo = BookingInfo.decode(stringBookingInfo);
      requestBooking = {
        "date": bookingInfo.isNotEmpty
            ? bookingInfo[0].bookingDateFormat
            : DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        "latitude": getDoubleAsync(BOOKING_LATITUDE).toString(),
        "longitude": getDoubleAsync(BOOKING_LONGITUDE).toString(),
        "address_id": getIntAsync(SELECTED_ADDRESS),
        "booking_date":
            bookingInfo.isNotEmpty ? bookingInfo[0].bookingDateFormat : "",
        "booking_date_time":
            bookingInfo.isNotEmpty ? bookingInfo[0].bookingDateTime : "",
        "booking_time":
            bookingInfo.isNotEmpty ? bookingInfo[0].bookingTime : "",
      };
    }

    print("requestBooking $requestBooking");
    bookTheServices(requestBooking).then((value) async {
      bookingLabel = language.lblBookingSuccessful;
      setState(() {});
      await Future.delayed(const Duration(seconds: 2));

      setValue('cart_items', 0);
      setValue('item_quantity', 0);
      setValue('total_price', 0.0);
      setValue('isButtonEnabled', false);

      setValue(BOOKING_INFO, "");
      // LocationPermission permission = await Geolocator.checkPermission();

      // if (permission != LocationPermission.denied &&
      //     permission != LocationPermission.deniedForever) {
      //   appStore.isCurrentLocation = true;
      //   appStore.isCustomeLocation = false;
      // }

      context.read<CartProvider>().getData();
      dbHelper!.deleteAllCartItem();
      appStore.setLoading(false);
      DashboardScreen(redirectToBooking: true).launch(context,
          isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
    appStore.setLoading(false);
  }

  @override
  void initState() {
    super.initState();
    bookServices();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
          width: context.width(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              20.height,
              Image.asset(
                appLogo,
                height: 100,
                width: 100,
              ),
              20.height,
              Text(
                bookingLabel,
                style: boldTextStyle(size: 22),
                textAlign: TextAlign.center,
              ),
              16.height,
              // Text(language.textBookingsuccess,
              //     style: primaryTextStyle(size: 12),
              //     textAlign: TextAlign.center),
              25.height,

              10.height,
            ],
          ).visible(
            !appStore.isLoading,
            defaultWidget: LoaderWidget().withSize(width: 250, height: 280),
          ),
        );
      },
    );
  }
}
