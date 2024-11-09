import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/booking_detail_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/utils/configs.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayServices {
  static late Razorpay razorPay;
  static late String razorKeys;
  static late BookingDetailResponse data;

  static init({required String razorKey, required BookingDetailResponse data}) {
    razorPay = Razorpay();
    razorPay.on(
        Razorpay.EVENT_PAYMENT_SUCCESS, RazorPayServices.handlePaymentSuccess);
    razorPay.on(
        Razorpay.EVENT_PAYMENT_ERROR, RazorPayServices.handlePaymentError);
    razorPay.on(
        Razorpay.EVENT_EXTERNAL_WALLET, RazorPayServices.handleExternalWallet);
    razorKeys = razorKey;
    data = data;
  }

  static void handlePaymentSuccess(PaymentSuccessResponse response) async {
    savePay(
        data: data,
        paymentMethod: PAYMENT_METHOD_RAZOR,
        paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
        txnId: response.paymentId);
  }

  static void handlePaymentError(PaymentFailureResponse response) {
    toast("Error: " + response.code.toString() + " - " + response.message!,
        print: true);
  }

  static void handleExternalWallet(ExternalWalletResponse response) {
    toast("external_wallet: " + response.walletName!);
  }

  static void razorPayCheckout(num mAmount) async {
    var options = {
      'key': razorKeys,
      'amount': (mAmount * 100),
      'name': APP_NAME,
      'theme.color': '#5f60b9',
      'description': APP_NAME_TAG_LINE,
      'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
      'prefill': {
        'contact': appStore.userContactNumber,
        'email': appStore.userEmail
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorPay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

Future<void> savePay({
  String? paymentMethod,
  String? txnId,
  String? paymentStatus = SERVICE_PAYMENT_STATUS_PENDING,
  required BookingDetailResponse data,
  num? totalAmount,
}) async {
  Map request = {
    CommonKeys.bookingId: data.bookingDetail!.id.validate(),
    CommonKeys.customerId: appStore.userId,
    CouponKeys.discount: data.bookingDetail!.discount.validate(),
    // BookingServiceKeys.totalAmount: totalAmount ??
    //     calculateTotalAmount(
    //       servicePrice: data.bookingDetail!.price.validate(),
    //       qty: data.bookingDetail!.quantity.validate(),
    //       serviceDiscountPercent: data.bookingDetail!.discount,
    //       taxes: data.bookingDetail!.taxes,
    //       couponData: data.couponData,
    //     ),
    BookingServiceKeys.totalAmount: data.bookingDetail!.amount.validate(),
    CommonKeys.dateTime: DateFormat(BOOKING_SAVE_FORMAT).format(DateTime.now()),
    "txn_id": txnId != '' ? txnId : "#${data.bookingDetail!.id.validate()}",
    "payment_status": paymentStatus,
    "payment_type": paymentMethod
  };
  log(request);

  appStore.setLoading(true);

  await savePayment(request).then((value) {
    appStore.setLoading(false);
    push(DashboardScreen(redirectToBooking: true),
        isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
  }).catchError((e) {
    log(e);
    appStore.setLoading(false);
  });
}
