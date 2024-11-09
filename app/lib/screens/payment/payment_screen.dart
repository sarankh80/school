import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/component/price_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/booking_detail_model.dart';
import 'package:com.gogospider.booking/model/credit_card_model.dart';
import 'package:com.gogospider.booking/model/dashboard_model.dart';
import 'package:com.gogospider.booking/services/razor_pay_services.dart';
import 'package:com.gogospider.booking/services/stripe_services.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:uuid/uuid.dart';

import '../../component/cached_image_widget.dart';

class PaymentScreen extends StatefulWidget {
  final BookingDetailResponse bookings;

  PaymentScreen({required this.bookings});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<PaymentSetting> paymentList = [];
  List<CareditCardData> creditCardList = [
    CareditCardData(
      cardNumber: '456897755658',
      expireDate: '12/2022',
      cvv: 123,
      id: 1,
      cardName: 'Chorizo Canapes',
      status: 1,
      isPrimary: 1,
    ),
    CareditCardData(
      cardNumber: '456897755658',
      expireDate: '12/2022',
      cvv: 123,
      id: 1,
      cardName: 'Chorizo Canapes',
      status: 1,
      isPrimary: 0,
    ),
    CareditCardData(
      cardNumber: '456897755658',
      expireDate: '12/2022',
      cvv: 123,
      id: 1,
      cardName: 'Chorizo Canapes',
      status: 1,
      isPrimary: 0,
    ),
  ];

  PaymentSetting? currentTimeValue;

  num totalAmount = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    paymentList = PaymentSetting.decode(getStringAsync(PAYMENT_LIST));

    currentTimeValue = paymentList.first;

    if (widget.bookings.bookingDetail!.isHourlyService.validate()) {
      totalAmount = getHourlyPrice(
        price: widget.bookings.bookingDetail!.totalAmount!.toInt(),
        secTime: widget.bookings.bookingDetail!.durationDiff.toInt(),
        date: widget.bookings.bookingDetail!.date.validate(),
      );

      log("Hourly Total Amount $totalAmount");
    } else {
      totalAmount = calculateTotalAmount(
        serviceDiscountPercent: widget.bookings.service?.discount.validate(),
        qty: widget.bookings.bookingDetail!.quantity.validate(),
        detail: widget.bookings.service,
        servicePrice: widget.bookings.bookingDetail!.amount.validate(),
        taxes: widget.bookings.bookingDetail!.taxes.validate(),
        couponData: widget.bookings.couponData,
      );
      log("Fixed Total Amount $totalAmount");
    }
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _handleClick() async {
    log(currentTimeValue!.type);
    if (currentTimeValue!.type == PAYMENT_METHOD_COD) {
      savePay(
          data: widget.bookings,
          paymentMethod: PAYMENT_METHOD_COD,
          totalAmount: totalAmount);
    } else if (currentTimeValue!.type == PAYMENT_METHOD_STRIPE) {
      if (currentTimeValue!.isTest == 1) {
        await stripeServices.init(
          stripePaymentPublishKey:
              currentTimeValue!.testValue!.stripePublickey.validate(),
          data: widget.bookings,
          totalAmount: totalAmount,
          stripeURL: currentTimeValue!.testValue!.stripeUrl.validate(),
          stripePaymentKey: currentTimeValue!.testValue!.stripeKey.validate(),
          isTest: true,
        );
        await 1.seconds.delay;
        stripeServices.stripePay();
      } else {
        await stripeServices.init(
          stripePaymentPublishKey:
              currentTimeValue!.liveValue!.stripePublickey.validate(),
          data: widget.bookings,
          totalAmount: totalAmount,
          stripeURL: currentTimeValue!.liveValue!.stripeUrl.validate(),
          stripePaymentKey: currentTimeValue!.liveValue!.stripeKey.validate(),
          isTest: false,
        );
        await 1.seconds.delay;
        stripeServices.stripePay();
      }
    } else if (currentTimeValue!.type == PAYMENT_METHOD_RAZOR) {
      if (currentTimeValue!.isTest == 1) {
        appStore.setLoading(true);
        RazorPayServices.init(
            razorKey: currentTimeValue!.testValue!.razorKey!,
            data: widget.bookings);
        await 1.seconds.delay;
        appStore.setLoading(false);
        RazorPayServices.razorPayCheckout(totalAmount);
      } else {
        appStore.setLoading(true);
        RazorPayServices.init(
            razorKey: currentTimeValue!.liveValue!.razorKey!,
            data: widget.bookings);
        await 1.seconds.delay;
        appStore.setLoading(false);
        RazorPayServices.razorPayCheckout(totalAmount);
      }
    } else if (currentTimeValue!.type == PAYMENT_METHOD_FLUTTER_WAVE) {
      if (currentTimeValue!.isTest == 1) {
        appStore.setLoading(true);
        _handlePaymentInitialization(
            flutterWavePublicKeys:
                currentTimeValue!.testValue!.flutterwavePublic.validate());
      } else {
        appStore.setLoading(true);
        _handlePaymentInitialization(
            flutterWavePublicKeys:
                currentTimeValue!.liveValue!.flutterwavePublic.validate());
      }
    }
  }

  void _handlePaymentInitialization(
      {required String flutterWavePublicKeys}) async {
    final Customer customer = Customer(
      name: widget.bookings.customer!.displayName.toString(),
      phoneNumber: widget.bookings.customer!.contactNumber.toString(),
      email: widget.bookings.customer!.email.toString(),
    );

    Flutterwave flutterWave = Flutterwave(
      context: context,
      style: FlutterwaveStyle(
        appBarText: "Pay By FlutterWave",
        buttonColor: primaryColor,
        appBarIcon: Icon(Icons.arrow_back_ios, color: Colors.white),
        buttonTextStyle: boldTextStyle(color: Colors.white),
        buttonText: "Continue to pay ${appStore.currencySymbol}$totalAmount",
        appBarColor: primaryColor,
        appBarTitleTextStyle: boldTextStyle(color: Colors.white, size: 18),
        dialogCancelTextStyle: TextStyle(color: Colors.redAccent, fontSize: 18),
        dialogContinueTextStyle: TextStyle(color: Colors.blue, fontSize: 18),
      ),
      publicKey: flutterWavePublicKeys,
      currency: appStore.currencyCode,
      redirectUrl: "https://google.com",
      txRef: Uuid().v1(),
      amount: totalAmount.toString(),
      customer: customer,
      paymentOptions: "card, payattitude, barter",
      customization: Customization(title: "FlutterWave Payment"),
      isTestMode: false,
    );

    await flutterWave.charge().then((value) {
      if (value.success.validate()) {
        savePay(
            paymentMethod: PAYMENT_METHOD_FLUTTER_WAVE,
            paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
            data: widget.bookings,
            totalAmount: totalAmount,
            txnId: value.transactionId);
      }
    }).catchError((e) {
      appStore.setLoading(false);
      log(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.payment,
          color: context.primaryColor,
          textColor: Colors.white,
          backWidget: BackWidget()),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PriceCommonWidget(
                    //   bookingDetail: widget.bookings.bookingDetail!,
                    //   serviceDetail: widget.bookings.service!,
                    //   taxes: widget.bookings.bookingDetail!.taxes.validate(),
                    //   couponData: widget.bookings.couponData,
                    // ),
                    // 32.height,
                    Text(language.lblChoosePaymentMethod,
                        style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                  ],
                ).paddingAll(16),
                if (paymentList.isNotEmpty)
                  ListView.builder(
                    itemCount: paymentList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      PaymentSetting value = paymentList[index];
                      return Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        margin: EdgeInsets.only(
                            bottom: 16, top: 0, left: 16, right: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: context.dividerColor),
                          borderRadius: radius(),
                          color: context.cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: RadioListTile<PaymentSetting>(
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          dense: true,
                          activeColor: primaryColor,
                          value: value,
                          controlAffinity: ListTileControlAffinity.leading,
                          groupValue: currentTimeValue,
                          onChanged: (PaymentSetting? ind) {
                            currentTimeValue = ind;
                            setState(() {});
                          },
                          title: Text(value.title.validate(),
                              style: primaryTextStyle()),
                          secondary: Container(
                              child: value.icon != null
                                  ? CachedImageWidget(
                                      url: '',
                                      height: 90,
                                      width: 90,
                                      fit: BoxFit.cover,
                                      radius: 60,
                                    )
                                  : Image.asset(cash,
                                      height: 27,
                                      width: 45,
                                      fit: BoxFit.cover)),
                        ),
                      );
                    },
                  )
                else
                  Column(
                    children: [
                      24.height,
                      Image.asset(notDataFoundImg, height: 150),
                      16.height,
                      Text(language.lblNoPayments, style: boldTextStyle())
                          .center(),
                    ],
                  ),
              ],
            ),
          ),
          if (paymentList.isNotEmpty)
            Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: context.dividerColor),
                    borderRadius: radius(),
                    color: context.primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: PriceWidget(
                            price: widget.bookings.bookingDetail!.totalAmount
                                .validate(),
                            color: Colors.white,
                            size: 20,
                          )),
                      Expanded(
                          child: Text(
                        '${language.lblNext}',
                        textAlign: TextAlign.right,
                        style: boldTextStyle(
                            size: 20, color: context.dividerColor),
                      ))
                    ],
                  ),
                ).onTap(() {
                  log(currentTimeValue!.type);
                  // if (currentTimeValue!.type == "stripe") {
                  //   log("12332 : ");
                  //   SelectCardScreen(
                  //           bookings: widget.bookings,
                  //           stripType: currentTimeValue!.type.validate())
                  //       .launch(context);
                  // }else if(){

                  // }

                  if (currentTimeValue!.type == PAYMENT_METHOD_COD) {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.CONFIRMATION,
                      title:
                          "${language.lblPayWith} ${currentTimeValue!.title.validate()}",
                      primaryColor: primaryColor,
                      positiveText: language.lblYes,
                      negativeText: language.lblCancel,
                      onAccept: (p0) {
                        _handleClick();
                      },
                    );
                  }
                  // else {
                  //   _handleClick();
                  // }
                })

                // AppButton(
                //   onTap: () {
                //     if (currentTimeValue!.type == PAYMENT_METHOD_COD) {
                //       showConfirmDialogCustom(
                //         context,
                //         dialogType: DialogType.CONFIRMATION,
                //         title:
                //             "${language.lblPayWith} ${currentTimeValue!.title.validate()}",
                //         primaryColor: primaryColor,
                //         positiveText: language.lblYes,
                //         negativeText: language.lblCancel,
                //         onAccept: (p0) {
                //           _handleClick();
                //         },
                //       );
                //     } else {
                //       _handleClick();
                //     }
                //   },
                //   text:
                //       "${language.payWith} ${currentTimeValue!.title.validate()}",
                //   color: context.primaryColor,
                //   width: context.width(),
                // ).paddingAll(16)
                ),
          Observer(
              builder: (context) =>
                  LoaderWidget().visible(appStore.isLoading)).center()
        ],
      ),
    );
  }
}
