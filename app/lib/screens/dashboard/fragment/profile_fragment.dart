import 'package:com.gogospider.booking/component/ask_change_location_dialog.dart';
import 'package:com.gogospider.booking/component/cached_image_widget.dart';
import 'package:com.gogospider.booking/component/loader_widget.dart';
import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:com.gogospider.booking/provider/cart_provider.dart';
import 'package:com.gogospider.booking/screens/auth/change_password_screen.dart';
import 'package:com.gogospider.booking/screens/auth/edit_profile_screen.dart';
import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
// import 'package:com.gogospider.booking/screens/auth/help_support_screen.dart';
// import 'package:com.gogospider.booking/screens/auth/privacy_screen.dart';
// import 'package:com.gogospider.booking/screens/auth/sign_in_screen.dart';
// import 'package:com.gogospider.booking/screens/auth/term_condition_screen.dart';
// import 'package:com.gogospider.booking/screens/dashboard/dashboard_screen.dart';
import 'package:com.gogospider.booking/screens/language_screen.dart';
import 'package:com.gogospider.booking/screens/map/address_screen.dart';
// import 'package:com.gogospider.booking/screens/service/favourite_service_screen.dart';
// import 'package:com.gogospider.booking/screens/setting_screen.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/configs.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ProfileFragment extends StatefulWidget {
  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DBHelper? dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // if (appStore.isAlertChooseLocation == true) {
    //   showBottomSheetChooseLocation(context, firstTimeShow: true);
    // }
    afterBuildCreated(() {
      appStore.setLoading(false);
      setStatusBarColor(context.primaryColor);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<CartProvider>().getData();
    return Scaffold(
      appBar: appBarWidget(
        language.profile,
        textColor: white,
        elevation: 0.0,
        color: context.primaryColor,
        showBack: false,
        actions: [
          // IconButton(
          //   icon: ic_setting.iconImage(color: white, size: 20),
          //   onPressed: () async {
          //     SettingScreen().launch(context);
          //   },
          // ),
        ],
      ),
      body: Observer(
        builder: (BuildContext context) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (appStore.isLoggedIn)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          24.height,
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                decoration: boxDecorationDefault(
                                  border:
                                      Border.all(color: primaryColor, width: 3),
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  decoration: boxDecorationDefault(
                                    border: Border.all(
                                        color: context.scaffoldBackgroundColor,
                                        width: 4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedImageWidget(
                                    url: appStore.userProfileImage,
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                    radius: 60,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 8,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(6),
                                  decoration: boxDecorationDefault(
                                    shape: BoxShape.circle,
                                    color: primaryColor,
                                    border: Border.all(
                                        color: context.cardColor, width: 2),
                                  ),
                                  child: Icon(AntDesign.edit,
                                      color: white, size: 18),
                                ).onTap(() {
                                  EditProfileScreen().launch(context);
                                }),
                              ),
                            ],
                          ),
                          10.height,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(appStore.userFullName,
                                  style: boldTextStyle(
                                      color: primaryColor, size: 18)),
                              // Text(appStore.userEmail,
                              //     style: secondaryTextStyle()),
                            ],
                          ),
                          10.height,
                        ],
                      ).center(),
                    SettingSection(
                      title: Text(language.lblGENERAL,
                          style: boldTextStyle(color: primaryColor)),
                      headingDecoration: BoxDecoration(
                        color: context.primaryColor.withOpacity(0.1),
                      ),
                      divider: Offstage(),
                      items: [
                        SettingItemWidget(
                          leading:
                              ic_profile2.iconImage(size: SETTING_ICON_SIZE),
                          title: language.profile,
                          trailing: trailing,
                          onTap: () {
                            doIfLoggedIn(context, () {
                              EditProfileScreen().launch(context);
                            });
                          },
                        ),
                        SettingItemWidget(
                          leading: ic_servicesAddress.iconImage(
                              size: SETTING_ICON_SIZE),
                          title: language.lblAddress,
                          trailing: trailing,
                          onTap: () {
                            doIfLoggedIn(context, () {
                              AddressScreen().launch(context);
                            });
                          },
                        ),
                        SettingItemWidget(
                          leading: ic_lock.iconImage(size: SETTING_ICON_SIZE),
                          title: language.changePassword,
                          trailing: trailing,
                          onTap: () {
                            doIfLoggedIn(context, () {
                              ChangePasswordScreen().launch(context);
                            });
                          },
                        ),
                        // SettingItemWidget(
                        //   leading: ic_heart.iconImage(size: SETTING_ICON_SIZE),
                        //   title: language.lblFavorite,
                        //   trailing: trailing,
                        //   onTap: () {
                        //     doIfLoggedIn(context, () {
                        //       // FavouriteServiceScreen().launch(context);
                        //     });
                        //   },
                        // ),
                        SettingItemWidget(
                          leading:
                              ic_language.iconImage(size: SETTING_ICON_SIZE),
                          title: language.language,
                          trailing: trailing,
                          onTap: () {
                            LanguagesScreen().launch(context).then((value) {
                              setState(() {});
                            });
                          },
                        ),
                        // SettingItemWidget(
                        //   leading:
                        //       ic_dark_mode.iconImage(size: SETTING_ICON_SIZE),
                        //   title: language.appTheme,
                        //   trailing: trailing,
                        //   onTap: () async {
                        //     await showInDialog(
                        //       context,
                        //       builder: (context) => ThemeSelectionDaiLog(),
                        //       contentPadding: EdgeInsets.zero,
                        //     );
                        //   },
                        // ),
                        // if (isLoginTypeUser)
                        // SettingItemWidget(
                        //   leading: ic_star.iconImage(size: SETTING_ICON_SIZE),
                        //   title: language.rateUs,
                        //   trailing: trailing,
                        //   onTap: () async {
                        //     getPackageName().then((value) {
                        //       String package = '';
                        //       if (isAndroid) package = value;

                        //       commonLaunchUrl(
                        //         '${isAndroid ? getSocialMediaLink(LinkProvider.PLAY_STORE) : getSocialMediaLink(LinkProvider.APPSTORE)}$package',
                        //         launchMode: LaunchMode.externalApplication,
                        //       );
                        //     });
                        //   },
                        // ),
                      ],
                    ),
                    SettingSection(
                      title: Text(language.lblDangerZone.toUpperCase(),
                          style: boldTextStyle(color: primaryColor)),
                      headingDecoration: BoxDecoration(
                          color: context.primaryColor.withOpacity(0.1)),
                      divider: Offstage(),
                      items: [
                        //     8.height,
                        //     SettingItemWidget(
                        //       leading:
                        //           ic_shield_done.iconImage(size: SETTING_ICON_SIZE),
                        //       title: language.privacyPolicy,
                        //       onTap: () {
                        //         PrivacyScreen().launch(context);
                        //         // checkIfLink(
                        //         //     context, appStore.privacyPolicy.validate(),
                        //         //     title: language.privacyPolicy);
                        //       },
                        //     ),
                        //     SettingItemWidget(
                        //       leading:
                        //           ic_document.iconImage(size: SETTING_ICON_SIZE),
                        //       title: language.termsCondition,
                        //       onTap: () {
                        //         TermConditionScreen().launch(context);
                        //         // checkIfLink(
                        //         //     context, appStore.termConditions.validate(),
                        //         //     title: language.termsCondition);
                        //       },
                        //     ),
                        //     SettingItemWidget(
                        //       leading: ic_helpAndSupport.iconImage(
                        //           size: SETTING_ICON_SIZE),
                        //       title: language.helpSupport,
                        //       onTap: () {
                        //         HelpSupportScreen().launch(context);
                        //         // checkIfLink(
                        //         //     context, appStore.inquiryEmail.validate(),
                        //         //     title: language.helpSupport);
                        //       },
                        //     ),
                        //     // SettingItemWidget(
                        //     //   leading:
                        //     //       ic_calling.iconImage(size: SETTING_ICON_SIZE),
                        //     //   title: language.lblHelplineNumber,
                        //     //   onTap: () {
                        //     //     launchCall(appStore.helplineNumber.validate());
                        //     //   },
                        //     // ),
                        //     // SettingItemWidget(
                        //     //   leading: ic_buy.iconImage(size: SETTING_ICON_SIZE),
                        //     //   title: language.lblPurchaseCode,
                        //     //   onTap: () {
                        //     //     launchUrlCustomTab(PURCHASE_URL);
                        //     //   },
                        //     // ).visible(isIqonicProduct),
                        //     SettingItemWidget(
                        //       leading: Icon(MaterialCommunityIcons.logout,
                        //           color: context.iconColor),
                        //       title: language.signIn,
                        //       onTap: () {
                        //         SignInScreen().launch(context);
                        //       },
                        //     ).visible(!appStore.isLoggedIn),
                        //   ],
                        // ),

                        // SettingSection(
                        // title: Text(language.lblDangerZone.toUpperCase(),
                        //     style: boldTextStyle(color: redColor)),
                        // headingDecoration:
                        //     BoxDecoration(color: redColor.withOpacity(0.08)),
                        // divider: Offstage(),
                        // items: [
                        // 8.height,
                        SettingItemWidget(
                          leading: ic_delete_account.iconImage(
                              size: SETTING_ICON_SIZE),
                          paddingBeforeTrailing: 4,
                          title: language.lblDeleteAccount,
                          onTap: () {
                            showConfirmDialogCustom(
                              context,
                              negativeText: language.lblCancel,
                              positiveText: language.lblDelete,
                              onAccept: (_) {
                                ifNotTester(() {
                                  appStore.setLoading(true);

                                  deleteAccountCompletely().then((value) async {
                                    appStore.setLoading(false);

                                    toast(value.message);
                                    await clearPreferences();

                                    push(DashboardScreen(),
                                        isNewTask: true,
                                        pageRouteAnimation:
                                            PageRouteAnimation.Fade);
                                  }).catchError((e) {
                                    appStore.setLoading(false);
                                    toast(e.toString());
                                  });
                                });
                              },
                              dialogType: DialogType.DELETE,
                              title: language.lblDeleteAccountConformation,
                            );
                          },
                        ).paddingOnly(left: 4),
                        // 64.height,
                        //     TextButton(
                        //       child: Text(language.logout,
                        //           style:
                        //               boldTextStyle(color: primaryColor, size: 18)),
                        //       onPressed: () {
                        //         logout(context).then((value) {
                        //           DBHelper().deleteAllCartItem();
                        //         });
                        //       },
                        //     ).center(),
                      ],
                    ).visible(appStore.isLoggedIn),
                    10.height.visible(!appStore.isLoggedIn),
                    SnapHelperWidget<PackageInfoData>(
                      future: getPackageInfo(),
                      onSuccess: (data) {
                        return TextButton(
                          child: VersionInfoWidget(
                              prefixText: 'v',
                              textStyle: secondaryTextStyle(size: 14)),
                          onPressed: () {
                            showAboutDialog(
                              context: context,
                              applicationName: APP_NAME,
                              applicationVersion: data.versionName,
                              applicationIcon: Image.asset(appLogo, height: 50),
                            );
                          },
                        ).center();
                      },
                    ),
                    10.height,
                    TextButton(
                      child: Text(language.logout,
                          style: boldTextStyle(color: primaryColor, size: 18)),
                      onPressed: () {
                        logout(context).then((value) {
                          DBHelper().deleteAllCartItem();
                        });
                      },
                    ).center(),
                  ],
                ),
              ),
              Observer(
                  builder: (context) =>
                      LoaderWidget().visible(appStore.isLoading))
            ],
          );
        },
      ),
    );
  }

  Future<void> showBottomSheetChooseLocation(BuildContext context,
      {firstTimeShow = false}) async {
    appStore.isLoading = true;
    await getSavedAddress().then((value) async {
      if (appStore.isCustomeLocation == true) {
        if (value.data!
            .where((element) =>
                element.late == getDoubleAsync(LATITUDE) &&
                element.lang == getDoubleAsync(LONGITUDE))
            .isNotEmpty) {
          value.data!
              .where((element) =>
                  element.late == getDoubleAsync(LATITUDE) &&
                  element.lang == getDoubleAsync(LONGITUDE))
              .first
              .isSelected = true;
          setState(() {});
        }
      }
      appStore.isLoading = false;
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius:
                radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
        builder: (_) {
          return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.50,
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(20),
                      backgroundColor: context.cardColor),
                  padding: EdgeInsets.all(16),
                  child: Stack(
                    children: [
                      DraggableScrollableSheet(
                          initialChildSize: 0.98,
                          minChildSize: 0.98,
                          maxChildSize: 0.98,
                          builder: (context, scrollController) {
                            return AskChangeLocationDialog(
                                showWelcomeBack: false,
                                addreses: value,
                                onSelectLocation: (lat, long, address,
                                    seletedId, isCurrentLocation) {
                                  setValue(TEMP_CURRENT_ADDRESS, address);
                                  setValue(TEMP_LATITUDE,
                                      double.parse(lat.toStringAsFixed(4)));
                                  setValue(TEMP_LONGITUDE,
                                      double.parse(long.toStringAsFixed(4)));
                                  setValue(TEMP_SELECTED_ADDRESS, seletedId);
                                  setValue(TEMP_IS_CURRENT_LOCATION,
                                      isCurrentLocation);
                                  setState(() {});
                                });
                          }),
                      Positioned(
                        bottom: 10,
                        left: 16,
                        right: 16,
                        child: AppButton(
                          width: MediaQuery.of(context).size.width,
                          text: language.lbConfirm,
                          margin: EdgeInsets.only(right: 10),
                          color: primaryColor,
                          textStyle:
                              boldTextStyle(size: 15, color: Colors.white),
                          onTap: () async {
                            int cartItem = getIntAsync('cart_items');
                            double currentTempLat =
                                getDoubleAsync(TEMP_LATITUDE);
                            double currentTempLong =
                                getDoubleAsync(TEMP_LONGITUDE);

                            double currentLate = getDoubleAsync(LATITUDE);
                            double currentLong = getDoubleAsync(LONGITUDE);
                            bool changeAddressClearCart =
                                getBoolAsync(CHANGE_ADDRESS_CLEAR_CART);

                            if (firstTimeShow = true) {
                              appStore.setAlertChooseLocation(false);
                            }

                            if (currentTempLat != currentLate &&
                                currentTempLong != currentLong) {
                              log(123456);
                              if (cartItem > 0) {
                                if (changeAddressClearCart) {
                                  log("Change Address");
                                  showConfirmClearCart(context);
                                } else {
                                  String currentTempAddress =
                                      getStringAsync(TEMP_CURRENT_ADDRESS);
                                  bool currentTempIsCurrentLocation =
                                      getBoolAsync(TEMP_IS_CURRENT_LOCATION);
                                  int currentTempSelectedAddress =
                                      getIntAsync(TEMP_SELECTED_ADDRESS);

                                  setValue(CURRENT_ADDRESS, currentTempAddress);
                                  setValue(
                                      BOOKING_LATITUDE,
                                      double.parse(
                                          currentTempLat.toStringAsFixed(4)));
                                  setValue(
                                      BOOKING_LONGITUDE,
                                      double.parse(
                                          currentTempLong.toStringAsFixed(4)));
                                  setValue(
                                      LATITUDE,
                                      double.parse(
                                          currentTempLat.toStringAsFixed(4)));
                                  setValue(
                                      LONGITUDE,
                                      double.parse(
                                          currentTempLong.toStringAsFixed(4)));
                                  if (currentTempSelectedAddress != 0) {
                                    setValue(SELECTED_ADDRESS,
                                        currentTempSelectedAddress);
                                    appStore.selectedAddressId =
                                        currentTempSelectedAddress;
                                  }
                                  if (currentTempIsCurrentLocation == true) {
                                    appStore.setCurrentLocation(true);
                                    appStore.setCustomeLocation(false);
                                  } else {
                                    appStore.setCurrentLocation(false);
                                    appStore.setCustomeLocation(true);
                                  }
                                  if (currentTempLat == 0.0 &&
                                      currentTempLong == 0.0) {
                                    showConfirmDialogCustom(
                                      context,
                                      subTitle: language.pleaseChooseOneAddress,
                                      onAccept: (p0) {},
                                    );
                                  } else {
                                    // Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }
                                }
                              } else {
                                String currentTempAddress =
                                    getStringAsync(TEMP_CURRENT_ADDRESS);
                                bool currentTempIsCurrentLocation =
                                    getBoolAsync(TEMP_IS_CURRENT_LOCATION);
                                int currentTempSelectedAddress =
                                    getIntAsync(TEMP_SELECTED_ADDRESS);

                                setValue(CURRENT_ADDRESS, currentTempAddress);
                                setValue(
                                    BOOKING_LATITUDE,
                                    double.parse(
                                        currentTempLat.toStringAsFixed(4)));
                                setValue(
                                    BOOKING_LONGITUDE,
                                    double.parse(
                                        currentTempLong.toStringAsFixed(4)));
                                setValue(
                                    LATITUDE,
                                    double.parse(
                                        currentTempLat.toStringAsFixed(4)));
                                setValue(
                                    LONGITUDE,
                                    double.parse(
                                        currentTempLong.toStringAsFixed(4)));
                                if (currentTempSelectedAddress != 0) {
                                  setValue(SELECTED_ADDRESS,
                                      currentTempSelectedAddress);
                                  appStore.selectedAddressId =
                                      currentTempSelectedAddress;
                                }
                                if (currentTempIsCurrentLocation == true) {
                                  appStore.setCurrentLocation(true);
                                  appStore.setCustomeLocation(false);
                                } else {
                                  appStore.setCurrentLocation(false);
                                  appStore.setCustomeLocation(true);
                                }
                                Navigator.of(context).pop();
                              }
                            } else {
                              String currentTempAddress =
                                  getStringAsync(TEMP_CURRENT_ADDRESS);
                              bool currentTempIsCurrentLocation =
                                  getBoolAsync(TEMP_IS_CURRENT_LOCATION);
                              int currentTempSelectedAddress =
                                  getIntAsync(TEMP_SELECTED_ADDRESS);

                              setValue(CURRENT_ADDRESS, currentTempAddress);
                              setValue(
                                  BOOKING_LATITUDE,
                                  double.parse(
                                      currentTempLat.toStringAsFixed(4)));
                              setValue(
                                  BOOKING_LONGITUDE,
                                  double.parse(
                                      currentTempLong.toStringAsFixed(4)));
                              setValue(
                                  LATITUDE,
                                  double.parse(
                                      currentTempLat.toStringAsFixed(4)));
                              setValue(
                                  LONGITUDE,
                                  double.parse(
                                      currentTempLong.toStringAsFixed(4)));
                              if (currentTempSelectedAddress != 0) {
                                setValue(SELECTED_ADDRESS,
                                    currentTempSelectedAddress);
                                appStore.selectedAddressId =
                                    currentTempSelectedAddress;
                              }
                              if (currentTempIsCurrentLocation == true) {
                                appStore.setCurrentLocation(true);
                                appStore.setCustomeLocation(false);
                              } else {
                                appStore.setCurrentLocation(false);
                                appStore.setCustomeLocation(true);
                              }
                              Navigator.of(context).pop();
                              // DashboardScreen().launch(context, isNewTask: true);
                            }
                          },
                        ),
                      )
                    ],
                  )));
        },
      );
    });
  }

  showConfirmClearCart(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              language.lblCofirmation,
              style: boldTextStyle(size: 16),
            ),
            content: Text(language.changeAddressContainItemInCartAlert),
            actions: <Widget>[
              AppButton(
                text: language.lblNo,
                textColor: Colors.white,
                color: warningColor,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              AppButton(
                text: language.lblOk,
                textColor: Colors.white,
                color: primaryColor,
                onTap: () {
                  appStore.setLoading(true);
                  double currentTempLat = getDoubleAsync(TEMP_LATITUDE);
                  double currentTempLong = getDoubleAsync(TEMP_LONGITUDE);
                  int currentTempSelectedAddress =
                      getIntAsync(TEMP_SELECTED_ADDRESS);
                  String currentTempAddress =
                      getStringAsync(TEMP_CURRENT_ADDRESS);

                  bool currentTempIsCurrentLocation =
                      getBoolAsync(TEMP_IS_CURRENT_LOCATION);

                  setValue(CURRENT_ADDRESS, currentTempAddress);
                  setValue(BOOKING_LATITUDE, currentTempLat);
                  setValue(BOOKING_LONGITUDE, currentTempLong);
                  setValue(LATITUDE, currentTempLat);
                  setValue(LONGITUDE, currentTempLong);
                  setValue(SELECTED_ADDRESS, currentTempSelectedAddress);
                  // appStore.selectedAddressId = currentTempSelectedAddress;
                  if (currentTempIsCurrentLocation == true) {
                    appStore.setCurrentLocation(true);
                    appStore.setCustomeLocation(false);
                  } else {
                    appStore.setCurrentLocation(false);
                    appStore.setCustomeLocation(true);
                  }

                  setValue('cart_items', 0);
                  setValue('item_quantity', 0);
                  setValue('total_price', 0.0);
                  setValue('isButtonEnabled', false);
                  setValue(BOOKING_INFO, "");
                  Navigator.of(context).pop();
                  dbHelper!.deleteAllCartItem().then((value) {
                    appStore.setLoading(false);
                    DashboardScreen().launch(context, isNewTask: true);
                  });
                  appStore.setLoading(false);
                },
              ),
            ],
          );
        });
  }
}
