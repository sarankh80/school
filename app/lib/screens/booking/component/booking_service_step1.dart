import 'package:another_stepper/another_stepper.dart';
import 'package:com.gogospider.booking/app_theme.dart';
import 'package:com.gogospider.booking/component/back_widget.dart';
// ignore: unused_import
import 'package:com.gogospider.booking/component/custom_stepper.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/component/price_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/booking_data_model.dart';
import 'package:com.gogospider.booking/model/service_detail_response.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/booking/component/booking_service_step2.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class BookingServiceStep1 extends StatefulWidget {
  final ServiceDetailResponse? data;

  BookingServiceStep1({this.data});

  @override
  _BookingServiceStep1State createState() => _BookingServiceStep1State();
}

class _BookingServiceStep1State extends State<BookingServiceStep1> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController dateTimeCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  DateTime currentDateTime = DateTime.now();
  DateTime? selectedDate;
  DateTime? finalDate;
  TimeOfDay? pickedTime;
  late Time _time;
  DateTime now = DateTime.now();
  double totalAmount = 0;
  String errorInavlidDateTime = '';

  List<BookingInfo>? bookingInfo = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _time = Time(hour: now.hour, minute: now.minute);
  }

  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
      log("time debug :$_time");
    });
  }

  void selectDateAndTime(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: currentDateTime,
      firstDate: currentDateTime,
      lastDate: currentDateTime.add(30.days),
      builder: (_, child) {
        return Theme(
          data: appStore.isDarkMode
              ? ThemeData.dark()
              : AppTheme.lightTheme().copyWith(
                  colorScheme: ColorScheme.light(
                    background: Colors.white,
                    primary: primaryColor, // header background color
                    // onPrimary: Colors.black, // header text color
                    // onSurface: Colors.green, // body text color
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red, // button text color
                    ),
                  ),
                ),
          child: child!,
        );
      },
    ).then((date) async {
      if (date != null) {
        int currentTime = DateTime.now().minute;
        int lastMinute = 60 - currentTime;
        int hour = DateTime.now().hour;
        if (lastMinute < 15) {
          hour = hour + 1;
        }
        _time = Time(hour: hour, minute: (currentTime + lastMinute) - 1);
        Navigator.of(context).push(showPicker(
          barrierDismissible: false,
          width: MediaQuery.of(context).size.width,
          hourLabel: ":",
          minuteLabel: "",
          iosStylePicker: true,
          // showSecondSelector: true,
          context: context,
          value: _time,
          accentColor: primaryColor,
          okStyle: primaryTextStyle(color: primaryColor),
          cancelStyle: primaryTextStyle(color: primaryColor),
          onChange: (Time newTime) {
            finalDate = DateTime(date.year, date.month, date.day,
                newTime.hour.validate(), newTime.minute.validate());
            DateTime currentDate = DateTime(
                date.year,
                date.month,
                date.day,
                DateTime.now().hour.validate(),
                DateTime.now().minute.validate());
            Time currentTime =
                Time(hour: DateTime.now().hour, minute: DateTime.now().minute);

            DateTime now = DateTime.now().subtract(1.minutes);
            errorInavlidDateTime = '';
            if (date.isToday &&
                finalDate!.millisecondsSinceEpoch <
                    now.millisecondsSinceEpoch) {
              errorInavlidDateTime =
                  "${language.selctedDateInvalid} \n ${language.yourCurrentTime} : \n${formatDate(date.toString(), format: DATE_FORMAT_3)} ${newTime.format(context).toString()} \n ${language.currentdateTime} : \n ${formatDate(currentDate.toString(), format: DATE_FORMAT_3)} ${currentTime.format(context).toString()} \n ${language.shouldSelectedDate}";
              dateTimeCont.text = "";
              setState(() {});
              // showConfirmDialog(scaffoldKey.currentContext,
              //     "${language.selctedDateInvalid} \n ${language.yourCurrentTime} : $finalDate < ${language.currentdateTime} : $currentDate");

              return toast(errorInavlidDateTime);
            }

            // widget.selectedDate = date;
            pickedTime = newTime;
            // widget.pickupTime = newTime;
            log("pickedTime : $finalDate");

            dateTimeCont.text =
                "${formatDate(date.toString(), format: DATE_FORMAT_3)} ${pickedTime!.format(context).toString()}";
            setState(() {
              _time = newTime;
              log("time debug :$_time");
            });
          },
          minuteInterval: TimePickerInterval.ONE,
          // Optional onChange to receive value as DateTime

          onChangeDateTime: (DateTime dateTime) {
            log("[debug datetime]:  $dateTime");
            // debugPrint("[debug datetime]:  $dateTime");
          },
        ));
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    List<StepperData> stepperData = [
      StepperData(
          title: StepperText(
            language.lblcart,
          ),
          iconWidget: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: const Text(
              "1",
              style: TextStyle(color: Colors.white),
            ),
          )),
      StepperData(
          title: StepperText(language.dateTime),
          iconWidget: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: const Text(
              "2",
              style: TextStyle(color: Colors.white),
            ),
          )),
      StepperData(
          title: StepperText(
            language.lblAddress,
            textStyle: const TextStyle(
              color: Colors.grey,
            ),
          ),
          iconWidget: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: const Text(
              "3",
              style: TextStyle(color: Colors.white),
            ),
          )),
    ];
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(
        language.lblReviewDateBooking,
        textColor: Colors.white,
        color: primaryColor,
        showBack: Navigator.canPop(context),
        backWidget: BackWidget(),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      AnotherStepper(
                        stepperList: stepperData,
                        stepperDirection: Axis.horizontal,
                        iconWidth: 30,
                        iconHeight: 30,
                        activeBarColor: primaryColor,
                        inActiveBarColor: Colors.grey,
                        inverted: true,
                        verticalGap: 40,
                        activeIndex: 1,
                        barThickness: 4,
                      ),
                      32.height,
                      Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Container(
                          decoration:
                              boxDecorationDefault(color: context.cardColor),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.lblDateAndTime,
                                  style: boldTextStyle()),
                              8.height,
                              AppTextField(
                                textFieldType: TextFieldType.OTHER,
                                controller: dateTimeCont,
                                isValidationRequired: true,
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return language.lblRequiredValidation;
                                  return null;
                                },
                                readOnly: true,
                                onTap: () {
                                  selectDateAndTime(context);
                                },
                                decoration: inputDecoration(context,
                                        prefixIcon: ic_calendar
                                            .iconImage(size: 10)
                                            .paddingAll(14))
                                    .copyWith(
                                  fillColor: context.scaffoldBackgroundColor,
                                  filled: true,
                                  hintText: language.lblEnterDateAndTime,
                                  hintStyle: secondaryTextStyle(),
                                ),
                              ),
                              15.height,
                              Text(
                                errorInavlidDateTime,
                                style: secondaryTextStyle(color: primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      16.height,
                      Text(language.bookingSummary, style: boldTextStyle()),
                      16.height,
                      Container(
                        decoration:
                            boxDecorationDefault(color: context.cardColor),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Consumer<CartProvider>(
                            builder: (BuildContext context, provider, widget) {
                          if (provider.cart.length == 0) {
                            return Container();
                          } else {
                            return AnimatedListView(
                                // controller: scrollController,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: provider.cart.length,
                                shrinkWrap: true,
                                listAnimationType: ListAnimationType.Slide,
                                slideConfiguration:
                                    SlideConfiguration(verticalOffset: 400),
                                disposeScrollController: false,
                                itemBuilder: (_, index) {
                                  return Row(
                                    children: [
                                      ValueListenableBuilder<int>(
                                          valueListenable:
                                              provider.cart[index].quantity!,
                                          builder: (context, val, child) {
                                            return Text(val.toString());
                                          }),
                                      Text(" x "),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          provider.cart[index].productName
                                              .validate(),
                                          maxLines: 1,
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      20.width,
                                      PriceWidget(
                                          color: textPrimaryColor,
                                          size: 14,
                                          isBoldText: false,
                                          price: provider
                                              .cart[index].productPrice
                                              .validate())
                                    ],
                                  ).paddingSymmetric(vertical: 5);
                                });
                          }
                        }),
                      ),
                      16.height,
                      Row(
                        children: [
                          Text(language.totalAmount, style: boldTextStyle()),
                          Spacer(),
                          Consumer<CartProvider>(builder:
                              (BuildContext context, value, Widget? child) {
                            final ValueNotifier<double?> totalPrice =
                                ValueNotifier(null);
                            for (var element in value.cart) {
                              totalPrice.value =
                                  (element.productPrice!.toDouble() *
                                          element.quantity!.value) +
                                      (totalPrice.value ?? 0.0);
                            }
                            return ValueListenableBuilder<double?>(
                                valueListenable: totalPrice,
                                builder: (context, val, child) {
                                  return PriceWidget(
                                    price: val.validate(),
                                    color: textPrimaryColor,
                                  );
                                });
                          })
                        ],
                      ),
                    ],
                  )).paddingBottom(5),
              Observer(
                  builder: (context) =>
                      LoaderWidget().visible(appStore.isLoading)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.all(15),
          child: Stack(
            children: [
              // Row(
              //   children: [
              //     Text(language.totalAmount, style: boldTextStyle()),
              //     Spacer(),
              //     Consumer<CartProvider>(
              //         builder: (BuildContext context, value, Widget? child) {
              //       final ValueNotifier<double?> totalPrice =
              //           ValueNotifier(null);
              //       for (var element in value.cart) {
              //         totalPrice.value = (element.productPrice!.toDouble() *
              //                 element.quantity!.value) +
              //             (totalPrice.value ?? 0.0);
              //       }
              //       return ValueListenableBuilder<double?>(
              //           valueListenable: totalPrice,
              //           builder: (context, val, child) {
              //             return PriceWidget(
              //               price: val.validate(),
              //               color: textPrimaryColor,
              //             );
              //           });
              //     })
              //   ],
              // ),
              AppButton(
                onTap: () async {
                  if (!appStore.isLoading) {
                    hideKeyboard(context);
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      bookingInfo = [];
                      BookingInfo v = BookingInfo(
                          date: DateTime.now().toIso8601String(),
                          address: getStringAsync(CURRENT_ADDRESS),
                          latitude: getDoubleAsync(LATITUDE),
                          longtitude: getDoubleAsync(LONGITUDE),
                          bookingDate: dateTimeCont.text,
                          bookingDateTime: finalDate?.toIso8601String(),
                          bookingTime: pickedTime?.format(context),
                          bookingDateFormat: finalDate.toString());
                      bookingInfo?.add(v);

                      final String encodedData =
                          BookingInfo.encode(bookingInfo!);
                      await setValue(BOOKING_INFO, encodedData).then((value) {
                        BookingServiceStep2().launch(context);
                      });
                    }
                  }
                },
                text: appStore.isLoading
                    ? language.lblLoading
                    : language.lblReviewAddress,
                textColor: Colors.white,
                width: context.width(),
                color: context.primaryColor,
              )
            ],
          )),
    );
  }
}
