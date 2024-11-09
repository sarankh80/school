import 'dart:convert';
import 'dart:io';

import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/network/network_utils.dart';
import 'package:com.gogospider.booking/screens/booking/component/booking_service_location_filter.dart';
import 'package:com.gogospider.booking/screens/dashboard/component/address_type_item_componect.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/model_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

class NewAddressScreen extends StatefulWidget {
  late final double? latitude;
  late final double? longitude;
  final String? address;
  late final bool? isFromBooking;
  late final DateTime? bookingDate;
  late final Time? pickupTime;
  final CategoriesData? categoryData;
  final ServiceData? serviceData;
  final bool? isFromCategory;
  final int? isCat;

  final Function(BuildContext context, SavedAddress address)? onSave;
  final Function(BuildContext context)? onClose;
  final String? image;

  NewAddressScreen(
      {required this.latitude,
      required this.longitude,
      this.address,
      this.isFromBooking = false,
      this.bookingDate,
      this.pickupTime,
      this.categoryData,
      this.isCat,
      this.isFromCategory,
      this.serviceData,
      this.onSave,
      this.onClose,
      this.image});
  @override
  NewAddressScreenState createState() => NewAddressScreenState();
}

class NewAddressScreenState extends State<NewAddressScreen> {
  final ScrollController scrollController = ScrollController();
  TextEditingController addressTitleCont = TextEditingController();
  TextEditingController floorCont = TextEditingController();
  TextEditingController noteCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();

  FocusNode addressFocus = FocusNode();
  FocusNode addressTitleFocus = FocusNode();
  FocusNode floorFocus = FocusNode();
  FocusNode noteFocus = FocusNode();
  OutlineInputBorder? border;
  OutlineInputBorder? errorBorder;
  String? currentAddress = "";
  bool? isDefualt = false;
  String? selectedAddressType = "Home";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? imageFile;
  XFile? pickedFile;
  late Base64Encoder imageAddress;

  List<SavedAddress>? savedAddresses = [];
  SavedAddress? savedAddress;
  List<AddressType>? addressType = [
    AddressType(type: "Home", selected: true),
    AddressType(type: "Condo", selected: false),
    AddressType(type: "Company", selected: false),
    AddressType(type: "Organization", selected: false)
  ];

  @override
  void initState() {
    super.initState();
    log("From Booking Screen ${widget.isFromBooking}");
    // border = OutlineInputBorder(
    //   borderRadius: BorderRadius.all(radiusCircular(15)),
    //   borderSide: BorderSide(
    //     color: context.dividerColor,
    //     width: 1.0,
    //   ),
    // );

    // errorBorder = OutlineInputBorder(
    //   borderRadius: BorderRadius.all(radiusCircular(15)),
    //   borderSide: BorderSide(
    //     color: primaryColor,
    //     width: 1.0,
    //   ),
    // );
    afterBuildCreated(() {
      setAddress(LatLng(widget.latitude!, widget.longitude!));
    });
    addressCont.text = widget.address.validate();
  }

  Future<void> setAddress(LatLng position) async {
    addressCont.text = widget.address.validate();
    // try {
    //   _currentAddress = await buildFullAddressFromLatLong(
    //           position.latitude, position.longitude)
    //       .catchError((e) {
    //     log(e);
    //   });
    //   addressCont.text = _currentAddress!;

    //   setState(() {});
    // } catch (e) {
    //   print(e);
    // }
  }

  void _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile!.path);
      setState(() {});
    }
  }

  _getFromCamera() async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile!.path);
      setState(() {});
    }
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: language.lblGallery,
              leading: Icon(Icons.image, color: primaryColor),
              onTap: () {
                _getFromGallery();
                finish(context);
              },
            ),
            Divider(),
            SettingItemWidget(
              title: language.camera,
              leading: Icon(Icons.camera, color: primaryColor),
              onTap: () {
                _getFromCamera();
                finish(context);
              },
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  Future<void> saveAddress(BuildContext context) async {
    hideKeyboard(context);
    int userID = getIntAsync(USER_ID);
    MultipartRequest multiPartRequest =
        await getMultiPartRequest('customers/$userID/addresses');
    multiPartRequest.fields[SaveAddressKey.title] = addressTitleCont.text;
    multiPartRequest.fields[SaveAddressKey.type] =
        selectedAddressType.validate();
    multiPartRequest.fields[SaveAddressKey.floor] = floorCont.text;
    multiPartRequest.fields[SaveAddressKey.note] = noteCont.text;
    multiPartRequest.fields[SaveAddressKey.address] = addressCont.text;
    multiPartRequest.fields[SaveAddressKey.defualt] =
        isDefualt == true ? '1' : '0';
    multiPartRequest.fields[SaveAddressKey.status] = '1';
    multiPartRequest.fields[SaveAddressKey.latitude] =
        widget.latitude!.toStringAsFixed(4);
    multiPartRequest.fields[SaveAddressKey.longitude] =
        widget.longitude!.toStringAsFixed(4);
    if (imageFile != null) {
      multiPartRequest.files.add(await MultipartFile.fromPath(
          SaveAddressKey.addressImage, imageFile!.path));
    } else {
      Image.asset(ic_home, fit: BoxFit.cover);
    }

    Map<String, dynamic> req = {
      SaveAddressKey.title: addressTitleCont.text,
      SaveAddressKey.address: addressCont.text,
      SaveAddressKey.floor: floorCont.text,
      SaveAddressKey.note: noteCont.text,
      SaveAddressKey.latitude: widget.latitude,
      SaveAddressKey.longitude: widget.longitude,
      SaveAddressKey.addressImage: imageFile != null
          ? imageFile!.path
          : Image.asset(ic_home, fit: BoxFit.cover),
      SaveAddressKey.uid: getStringAsync(UID),
      SaveAddressKey.type: "home",
      'createdAt': Timestamp.now(),
    };

    log('req: $req');

    multiPartRequest.headers.addAll(buildHeaderTokens());

    appStore.setLoading(true);

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        SavedAddress address = SavedAddress.fromJsonData(json.decode(data));
        log("Address ID ${address.id}");
        appStore.setLoading(false);
        setValue(SELECTED_ADDRESS, address.id.validate());
        // appStore.selectedAddressId = address.id.validate();

        appStore.setCurrentLocation(false);
        appStore.setCustomeLocation(true);
        // appStore.setAlertChooseLocation(false);

        setValue(TEMP_CURRENT_ADDRESS, address.address);
        setValue(TEMP_LATITUDE, double.parse(address.late!.toStringAsFixed(4)));
        setValue(
            TEMP_LONGITUDE, double.parse(address.lang!.toStringAsFixed(4)));
        setValue(TEMP_SELECTED_ADDRESS, address.id);
        setValue(TEMP_IS_CURRENT_LOCATION, false);

        setValue(CURRENT_ADDRESS, address.address);
        setValue(LATITUDE, double.parse(address.late!.toStringAsFixed(4)));
        setValue(LONGITUDE, double.parse(address.lang!.toStringAsFixed(4)));
        setValue(
            BOOKING_LATITUDE, double.parse(address.late!.toStringAsFixed(4)));
        setValue(
            BOOKING_LONGITUDE, double.parse(address.lang!.toStringAsFixed(4)));
        setValue(SELECTED_ADDRESS, address.id);
        appStore.selectedAddressId = address.id!;
        if (widget.onSave != null) {
          widget.onSave!.call(context, address);
        } else {
          if (widget.isFromBooking == true) {
            BookingServiceLocationFilter(
              categoryData: widget.categoryData,
              isCat: widget.isCat,
              isFromCategory: widget.isFromCategory,
              serviceData: widget.serviceData,
              selectedDate: widget.bookingDate,
              pickupTime: widget.pickupTime,
            ).launch(context);
          } else {
            DashboardScreen().launch(context,
                isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
            // if (data != null) {
            //   if ((data as String).isJson()) {
            //     SavedAddress res = SavedAddress.fromJson(jsonDecode(data));
            //   }
            // }
          }
        }
      },
      onError: (error) {
        toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  // void _saveAddress() async {
  //   appStore.setLoading(true);
  //   var addressString = getStringAsync(SAVED_ADDRESS);
  //   if (addressString != "") {
  //     savedAddresses = SavedAddress.decode(addressString);
  //     savedAddresses?.forEach((element) => element.isSelected = false);
  //     savedAddresses?.add(SavedAddress(
  //         title: addressTitleCont.text,
  //         image: imageFile != null
  //             ? Utility.base64String(imageFile!.readAsBytesSync())
  //             : "",
  //         address: addressCont.text,
  //         lang: widget.longitude,
  //         late: widget.latitude,
  //         floor: floorCont.text,
  //         note: noteCont.text,
  //         isDefault: 0,
  //         isSelected: true));
  //   } else {
  //     savedAddresses = [
  //       SavedAddress(
  //           title: addressTitleCont.text,
  //           image: imageFile?.path != ""
  //               ? Utility.base64String(imageFile!.readAsBytesSync())
  //               : "",
  //           address: addressCont.text,
  //           lang: widget.longitude,
  //           late: widget.latitude,
  //           floor: floorCont.text,
  //           note: noteCont.text,
  //           isDefault: 0,
  //           isSelected: true)
  //     ];
  //   }

  //   final String encodedData = SavedAddress.encode(savedAddresses!);
  //   await setValue(SAVED_ADDRESS, encodedData).then((value) {
  //     appStore.setSavedLocation(true);
  //     appStore.setCurrentLocation(false);
  //     appStore.setCustomeLocation(false);
  //     appStore.setCurrentAddress(addressCont.text);
  //     appStore.setLoading(false);
  //   });
  //   setState(() {});
  //   DashboardScreen().launch(context,
  //       isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
  // }

  Widget _getCustomPin() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 22),
        width: 120,
        child: Lottie.asset("assets/pin.json"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: appBarWidget(language.newAddress,
        //     color: context.primaryColor,
        //     textColor: Colors.white,
        //     backWidget: BackWidget()),
        body: SafeArea(
            child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Stack(children: [
                  SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Stack(children: [
                      //   Container(
                      //       color: context.cardColor,
                      //       height: 250,
                      //       child: MapScreenComponent(
                      //         latLong: widget.longitude,
                      //         latitude: widget.latitude,
                      //         isNewAddress: true,
                      //       )),
                      // ]),
                      Stack(
                        children: [
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Image.memory(
                              base64Decode(widget.image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          20.height,
                          _getCustomPin()
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        color: context.cardColor,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          widget.address.validate(),
                          style: boldTextStyle(size: 14),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: context.dividerColor),
                          color: context.scaffoldBackgroundColor,
                        ),
                        child: Row(children: [
                          Text(
                            language.addressType,
                            style: boldTextStyle(size: 16),
                          ),
                          Spacer(),
                          Text(
                            selectedAddressType.validate(),
                            style: boldTextStyle(color: appTextSecondaryColor),
                          )
                        ]).paddingOnly(
                            top: 10, bottom: 10, left: 18, right: 18),
                      ).onTap(() async {
                        String? res = await showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true,
                          isDismissible: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: radiusOnly(
                                  topLeft: defaultRadius,
                                  topRight: defaultRadius)),
                          builder: (_) {
                            return DraggableScrollableSheet(
                              initialChildSize: 0.50,
                              minChildSize: 0.2,
                              maxChildSize: 1,
                              builder: (context, scrollController) =>
                                  AddressTypeItemComponent(
                                      data: addressType,
                                      scrollController: scrollController),
                            );
                          },
                        );
                        selectedAddressType = res;
                        setState(() {});
                      }),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Container(
                          //   padding: EdgeInsets.all(8),
                          //   decoration: BoxDecoration(
                          //     border: Border.all(color: context.dividerColor),
                          //     borderRadius: radius(),
                          //     color: context.scaffoldBackgroundColor,
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Container(
                          //           // padding: EdgeInsets.all(8),
                          //           decoration: boxDecorationDefault(
                          //               color: warningColor,
                          //               shape: BoxShape.circle,
                          //               border: Border.all(
                          //                   color: context.dividerColor)),
                          //           child: imageFile != null
                          //               ? Image.file(
                          //                   imageFile!,
                          //                   width: 35,
                          //                   height: 35,
                          //                   fit: BoxFit.cover,
                          //                 ).cornerRadiusWithClipRRect(17.5)
                          //               : Image.asset(
                          //                   ic_camera,
                          //                   width: 20,
                          //                 ).paddingAll(8)),
                          //       8.width,
                          //       Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //             imageFile != null
                          //                 ? language.changeAvatar
                          //                 : language.chooseYourAvatar,
                          //             style: boldTextStyle(size: 14),
                          //           ),
                          //           Text(language.lblChooseYourAvatar)
                          //         ],
                          //       ),
                          //       Spacer(),
                          //       Image.asset(
                          //         ic_arrow_right,
                          //         width: 15,
                          //       )
                          //     ],
                          //   ),
                          // ).onTap(() async {
                          //   _showBottomSheet(context);
                          // }),
                          // 20.height,
                          RichText(
                            text: TextSpan(
                              text: language.addressTitle,
                              style: boldTextStyle(),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '(#15E0,St 10, Borey Rana Phumi)',
                                  style: secondaryTextStyle(),
                                ),
                              ],
                            ),
                          ),
                          // Text(
                          //     "${language.addressTitle} (#15 E0, Street 10, Borey Rana Phumi)",
                          //     style: boldTextStyle()),
                          8.height,
                          AppTextField(
                            textFieldType: TextFieldType.OTHER,
                            controller: addressTitleCont,
                            isValidationRequired: true,
                            validator: (value) {
                              if (value!.isEmpty)
                                return language.lblRequiredValidation;
                              return null;
                            },
                            decoration: InputDecoration(
                              // hintText: 'Mom House',
                              hintStyle: secondaryTextStyle(),
                              labelStyle:
                                  const TextStyle(color: appTextSecondaryColor),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(radiusCircular(15)),
                                borderSide: BorderSide(
                                  color: context.dividerColor,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(radiusCircular(15)),
                                borderSide: BorderSide(
                                  color: context.dividerColor,
                                  width: 1.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(radiusCircular(15)),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                          20.height,
                          Text(language.lblYourAddress, style: boldTextStyle()),
                          8.height,
                          AppTextField(
                              textFieldType: TextFieldType.MULTILINE,
                              controller: addressCont,
                              maxLines: 2,
                              onChanged: (s) {
                                log(s);
                              },
                              // minLines: 4,
                              onFieldSubmitted: (s) {
                                // widget.data.serviceDetail!.address = s;
                              },
                              validator: (value) {
                                if (value!.isEmpty)
                                  return language.lblRequiredValidation;
                                return null;
                              },
                              isValidationRequired: true,
                              decoration: InputDecoration(
                                hintText: '#123,Hanoy Blv , Phnom Penh',
                                hintStyle: const TextStyle(
                                    color: appTextSecondaryColor),
                                labelStyle: const TextStyle(
                                    color: appTextSecondaryColor),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(radiusCircular(15)),
                                  borderSide: BorderSide(
                                    color: context.dividerColor,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(radiusCircular(15)),
                                  borderSide: BorderSide(
                                    color: context.dividerColor,
                                    width: 1.0,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(radiusCircular(15)),
                                  borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 1.0,
                                  ),
                                ),
                              )),
                          20.height,
                          Text(language.floor, style: boldTextStyle()),
                          8.height,
                          AppTextField(
                              textFieldType: TextFieldType.OTHER,
                              controller: floorCont,
                              maxLines: 2,
                              onChanged: (s) {
                                log(s);
                              },
                              // minLines: 4,
                              onFieldSubmitted: (s) {
                                // widget.data.serviceDetail!.address = s;
                              },
                              // validator: (value) {
                              //   if (value!.isEmpty)
                              //     return language.lblRequiredValidation;
                              //   return null;
                              // },
                              // isValidationRequired: true,
                              decoration: InputDecoration(
                                hintText: '3rd',
                                hintStyle: secondaryTextStyle(),
                                labelStyle:
                                    const TextStyle(color: appTextPrimaryColor),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(radiusCircular(15)),
                                  borderSide: BorderSide(
                                    color: context.dividerColor,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(radiusCircular(15)),
                                  borderSide: BorderSide(
                                    color: context.dividerColor,
                                    width: 1.0,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(radiusCircular(15)),
                                  borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 1.0,
                                  ),
                                ),
                              )),
                          20.height,
                          Text(language.note, style: boldTextStyle()),
                          8.height,
                          AppTextField(
                              textFieldType: TextFieldType.OTHER,
                              controller: noteCont,
                              maxLines: 2,
                              onChanged: (s) {
                                log(s);
                              },
                              // minLines: 4,
                              onFieldSubmitted: (s) {
                                // widget.data.serviceDetail!.address = s;
                              },
                              isValidationRequired: true,
                              decoration: InputDecoration(
                                hintText: 'Your note',
                                hintStyle: secondaryTextStyle(),
                                labelStyle: const TextStyle(
                                    color: appTextSecondaryColor),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(radiusCircular(15)),
                                  borderSide: BorderSide(
                                    color: context.dividerColor,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(radiusCircular(15)),
                                  borderSide: BorderSide(
                                    color: context.dividerColor,
                                    width: 1.0,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(radiusCircular(15)),
                                  borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 1.0,
                                  ),
                                ),
                              )),
                          8.height,
                          Container(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 16),
                            child: RoundedCheckBox(
                              borderColor: context.primaryColor,
                              checkedColor: context.primaryColor,
                              isChecked: false,
                              text: language.setAsDefaultAddress,
                              textStyle: secondaryTextStyle(),
                              size: 20,
                              onTap: (value) async {
                                isDefualt = !isDefualt!;
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ).paddingAll(18),
                      60.height
                    ],
                  )),
                  Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        width: 35,
                        height: 35,
                        child: Icon(
                          Icons.close,
                          color: redColor,
                          size: 25,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      ).onTap(() {
                        if (widget.onClose != null) {
                          widget.onClose!.call(context);
                        } else {
                          Navigator.of(context).pop();
                        }
                      })),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: context.dividerColor),
                            borderRadius: radius(),
                            color: context.primaryColor,
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
                          child: Text(
                            '${language.lblSaveContinue}',
                            textAlign: TextAlign.center,
                            style: boldTextStyle(
                                size: 18, color: scaffoldLightColor),
                          )).onTap(() {
                        if (formKey.currentState!.validate()) {
                          saveAddress(context);
                        } else {
                          print('invalid!');
                        }
                      }))
                ]))));
  }
}
