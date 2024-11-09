import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/component/price_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/booking_detail_model.dart';
import 'package:com.gogospider.booking/model/credit_card_model.dart';
import 'package:com.gogospider.booking/model/dashboard_model.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
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
import 'component/card_item.dart';
import 'new_card.dart';

class SelectCardScreen extends StatefulWidget {
  final BookingDetailResponse bookings;
  final String stripType;

  SelectCardScreen({required this.bookings, required this.stripType});

  @override
  _SelectCardScreenState createState() => _SelectCardScreenState();
}

class _SelectCardScreenState extends State<SelectCardScreen> {
  List<PaymentSetting> paymentList = [];
  List<CareditCardData> creditCardList = [
    CareditCardData(
        cardNumber: '4568977534323',
        expireDate: '12/2022',
        cvv: 123,
        id: 1,
        cardName: 'Chorizo Canapes',
        status: 1,
        isPrimary: 1,
        isSelected: true),
    CareditCardData(
        cardNumber: '456897755623232',
        expireDate: '12/2022',
        cvv: 123,
        id: 1,
        cardName: 'Chorizo Canapes',
        status: 1,
        isPrimary: 0,
        isSelected: false),
    CareditCardData(
        cardNumber: '456897755658',
        expireDate: '12/2022',
        cvv: 123,
        id: 1,
        cardName: 'Chorizo Canapes',
        status: 1,
        isPrimary: 0,
        isSelected: false),
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
        serviceDiscountPercent: widget.bookings.service!.discount.validate(),
        qty: widget.bookings.bookingDetail!.quantity!.toInt(),
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

  void handleClick() async {
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

  void _onPaymentSentLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${language.lblPaymentProcessing}',
                      style: boldTextStyle(size: 23),
                    ),
                    25.height,
                    new Container(
                      padding: EdgeInsets.all(45),
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: context.dividerColor),
                      //   borderRadius: radius(),
                      //   color: context.scaffoldBackgroundColor,
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.grey.withOpacity(0.5),
                      //       spreadRadius: 1,
                      //       blurRadius: 5,
                      //       offset: Offset(0, 1), // changes position of shadow
                      //     ),
                      //   ],
                      // ),
                      child: new CircularProgressIndicator(
                        strokeWidth: 8,
                      ),
                    ),
                  ],
                )));
      },
    );
    new Future.delayed(new Duration(seconds: 30), () {
      Navigator.pop(context); //pop dialog
      _onPaymentSuccess();
    });
  }

  void _onPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
          alignment: Alignment.center,
          // color: Colors.red,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${language.lblPaymentSuccess}',
                style: boldTextStyle(size: 20),
              ),
              20.height,
              Image.asset(appLogo, height: 124, width: 120, fit: BoxFit.cover),
              25.height,
              Container(
                padding:
                    EdgeInsets.only(top: 16, bottom: 16, left: 25, right: 25),
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
                child: Text(
                  '${language.backHome}',
                  style: secondaryTextStyle(
                      size: 15, color: appBarBackgroundColorGlobal),
                ),
              ).onTap(() {
                DashboardScreen().launch(context);
              })
            ],
          ),
        ));
      },
    );
  }

  void _onNewCard() {
    NewCardScreen().launch(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cardColor,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language.lblChoosePaymentMethod,
                      style: boldTextStyle(size: LABEL_TEXT_SIZE),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: context.dividerColor),
                        borderRadius: radius(),
                        color: verifyAcColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text(
                        '${language.addNew}',
                        style: secondaryTextStyle(color: scaffoldLightColor),
                      ),
                    ).onTap(() {
                      _onNewCard();
                    })
                  ],
                ).paddingAll(16),
                if (paymentList.isNotEmpty)
                  ListView.builder(
                    itemCount: creditCardList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      CareditCardData value = creditCardList[index];
                      return Container(
                        alignment: Alignment.center,
                        // color: context.scaffoldBackgroundColor,
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: CardItemComponent(
                          cardData: value,
                        ),
                      ).onTap(() {
                        setState(() {
                          creditCardList
                              .forEach((element) => element.isSelected = false);
                          creditCardList[index].isSelected = true;
                        });
                      });
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
                        '${language.lblPayNow}',
                        textAlign: TextAlign.right,
                        style: boldTextStyle(
                            size: 20, color: textPrimaryColorGlobal),
                      ))
                    ],
                  ),
                ).onTap(() {
                  // _handleClick();
                  _onPaymentSentLoading();
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
