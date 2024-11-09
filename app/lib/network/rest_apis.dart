import 'dart:convert';

import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/add_cart_model.dart';
import 'package:com.gogospider.booking/model/address_model.dart';
import 'package:com.gogospider.booking/model/base_response_model.dart';
import 'package:com.gogospider.booking/model/booking_data_model.dart';
import 'package:com.gogospider.booking/model/booking_detail_model.dart';
import 'package:com.gogospider.booking/model/booking_list_model.dart';
import 'package:com.gogospider.booking/model/booking_status_model.dart';
import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/model/category_model.dart';
import 'package:com.gogospider.booking/model/city_list_model.dart';
import 'package:com.gogospider.booking/model/country_list_model.dart';
import 'package:com.gogospider.booking/model/dashboard_model.dart';
import 'package:com.gogospider.booking/model/login_model.dart';
import 'package:com.gogospider.booking/model/notification_model.dart';
import 'package:com.gogospider.booking/model/provider_info_response.dart';
import 'package:com.gogospider.booking/model/provider_list_model.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
import 'package:com.gogospider.booking/model/service_detail_response.dart';
import 'package:com.gogospider.booking/model/service_response.dart';
import 'package:com.gogospider.booking/model/service_review_response.dart';
import 'package:com.gogospider.booking/model/state_list_model.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/network/network_utils.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/common.dart';
import 'package:com.gogospider.booking/utils/configs.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:com.gogospider.booking/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/extension.dart';
import 'package:nb_utils/nb_utils.dart';

//region Auth Api
Future<LoginResponse> createUser(Map request) async {
  LoginResponse res = LoginResponse.fromJson(await (handleResponse(
      await buildHttpResponse('customers/register',
          request: request, method: HttpMethod.POST))));
  // log("Signup Res ${res.toJson()}");
  return res;
}

Future<LoginResponse> verificationUser(Map request) async {
  LoginResponse res = LoginResponse.fromJson(await (handleResponse(
      await buildHttpResponse('customers/phone-verification',
          request: request, method: HttpMethod.POST))));
  // log("Signup Res ${res.toJson()}");
  return res;
}

Future<LoginResponse> loginUser(Map request,
    {bool isSocialLogin = false}) async {
  LoginResponse res = LoginResponse.fromJson(await handleResponse(
      await buildHttpResponse(
          isSocialLogin ? 'social-login' : 'customers/login',
          request: request,
          method: HttpMethod.POST)));
  // if (!isSocialLogin) await appStore.setLoginType(LOGIN_TYPE_USER);
  log("Login Res ${res.toJson()}");
  return res;
}

Future<void> saveUserData(UserData data) async {
  log("user Data ${data.apiToken}");
  if (data.apiToken.validate().isNotNullAndNotEmpty)
    await appStore.setToken(data.apiToken.validate());

  await appStore.setUserId(data.id.validate());
  await appStore.setFirstName(data.firstName.validate());
  await appStore.setLastName(data.lastName.validate());
  await appStore.setUserEmail(data.email.validate());
  await appStore.setUserName(data.username.validate());
  await appStore.setCountryId(data.countryId.validate());
  await appStore.setStateId(data.stateId.validate());
  await appStore.setCityId(data.cityId.validate());
  await appStore.setContactNumber(data.contactNumber.validate());
  await appStore.setUId(data.uid.validate());
  // log("LOG UID :${data.contactNumber.validate()}");

  // await setValue(UID, data.uid.validate());
  if (data.loginType.validate().isNotEmpty)
    await appStore.setLoginType(data.loginType.validate());
  await appStore.setAddress(data.address.validate());

  if (data.loginType != LOGIN_TYPE_GOOGLE) {
    await appStore.setUserProfile(data.profileImage.validate());
  }
  appStore.setLoggedIn(true);

  userService.getUser(email: data.email.validate()).then((value) async {
    appStore.setUId(value.uid.validate());
    if (data.loginType == LOGIN_TYPE_GOOGLE) {
      appStore.setUserProfile(value.profileImage.validate());
    }
  }).catchError((e) {
    log(e.toString());

    if (e.toString() == USER_NOT_FOUND) {
      toast(USER_NOT_FOUND);
    }
  });

  userService
      .getUserByPhone(phone: data.contactNumber.validate())
      .then((value) async {
    appStore.setUId(value.uid.validate());
    if (data.loginType == LOGIN_TYPE_GOOGLE) {
      appStore.setUserProfile(value.profileImage.validate());
    }
  }).catchError((e) {
    log(e.toString());

    if (e.toString() == USER_NOT_FOUND) {
      toast(USER_NOT_FOUND);
    }
  });
}

Future<void> clearPreferences() async {
  if (!getBoolAsync(IS_REMEMBERED)) await appStore.setUserEmail('');

  await appStore.setFirstName('');
  await appStore.setLastName('');
  await appStore.setUserId(0);
  await appStore.setUserName('');
  await appStore.setContactNumber('');
  await appStore.setCountryId(0);
  await appStore.setStateId(0);
  await appStore.setUserProfile('');
  await appStore.setCityId(0);
  await appStore.setUId('');
  // await appStore.setLatitude(0.0);
  // await appStore.setLongitude(0.0);
  // await appStore.setCurrentAddress('');

  // await appStore.setCurrentLocation(false);

  await appStore.setToken('');
  await appStore.setPrivacyPolicy('');
  await appStore.setTermConditions('');
  await appStore.setInquiryEmail('');
  await appStore.setHelplineNumber('');

  await appStore.setLoggedIn(false);
  await removeKey(LOGIN_TYPE);
  await setValue('cart_items', 0);
  await appStore.setAlertChooseLocation(true);
}

Future<void> logout(BuildContext context) async {
  return showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    builder: (p0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(logout_image, width: context.width(), fit: BoxFit.cover),
          32.height,
          Text(language.lblLogoutTitle, style: boldTextStyle(size: 20)),
          16.height,
          Text(language.lblLogoutSubTitle, style: secondaryTextStyle()),
          28.height,
          Row(
            children: [
              AppButton(
                child: Text(language.lblNo, style: boldTextStyle()),
                elevation: 0,
                onTap: () {
                  finish(context);
                },
              ).expand(),
              16.width,
              AppButton(
                child:
                    Text(language.lblYes, style: boldTextStyle(color: white)),
                color: primaryColor,
                elevation: 0,
                onTap: () async {
                  finish(context);

                  if (await isNetworkAvailable()) {
                    appStore.setLoading(true);

                    logoutApi().then((value) async {
                      //
                    }).catchError((e) {
                      log(e.toString());
                    });

                    await clearPreferences();

                    appStore.setLoading(false);
                    // DashboardScreen().launch(context,
                    //     isNewTask: true,
                    //     pageRouteAnimation: PageRouteAnimation.Fade);
                  }
                },
              ).expand(),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 24);
    },
  );
}

Future<void> logoutApi() async {
  return await handleResponse(
      await buildHttpResponse('logout', method: HttpMethod.GET));
}

Future<BaseResponseModel> changeUserPassword(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('change-password',
          request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> forgotPassword(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('customers/forgot-password',
          request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> deleteAccountCompletely() async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('delete-user-account',
          request: {}, method: HttpMethod.POST)));
}

//endregion

//region Country Api
Future<List<CountryListResponse>> getCountryList() async {
  Iterable res = await (handleResponse(
      await buildHttpResponse('country-list', method: HttpMethod.POST)));
  return res.map((e) => CountryListResponse.fromJson(e)).toList();
}

Future<List<StateListResponse>> getStateList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('state-list',
      request: request, method: HttpMethod.POST)));
  return res.map((e) => StateListResponse.fromJson(e)).toList();
}

Future<List<CityListResponse>> getCityList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('city-list',
      request: request, method: HttpMethod.POST)));
  return res.map((e) => CityListResponse.fromJson(e)).toList();
}
//endregion

//region User Api
Future<DashboardResponse> userDashboard(
    {bool isCurrentLocation = false, double? lat, double? long}) async {
  appStore.setLoading(true);
  DashboardResponse? _dashboardResponse;

  /// If any below condition not satisfied, call this
  // String endPoint = 'dashboard-detail';
  String endPoint = 'customer-dashboard';

  if (isCurrentLocation &&
      appStore.isLoggedIn &&
      appStore.userId.validate() != 0) {
    endPoint =
        "$endPoint?latitude=$lat&longitude=$long&?customer_id=${appStore.userId.validate()}";
  } else if (isCurrentLocation) {
    endPoint = "$endPoint?latitude=$lat&longitude=$long";
  } else if (appStore.isLoggedIn && appStore.userId.validate() != 0) {
    endPoint = "$endPoint?customer_id=${appStore.userId.validate()}";
  }

  _dashboardResponse = DashboardResponse.fromJson(await handleResponse(
      await buildHttpResponse(endPoint, method: HttpMethod.GET)));

  if (_dashboardResponse.privacyPolicy != null) {
    if (_dashboardResponse.privacyPolicy!.value != null) {
      appStore
          .setPrivacyPolicy(_dashboardResponse.privacyPolicy!.value.validate());
    } else {
      appStore.setPrivacyPolicy(PRIVACY_POLICY_URL);
    }
  } else {
    appStore.setPrivacyPolicy(PRIVACY_POLICY_URL);
  }

  if (_dashboardResponse.termConditions != null) {
    if (_dashboardResponse.termConditions?.value != null) {
      appStore.setTermConditions(
          _dashboardResponse.termConditions!.value.validate());
    } else {
      appStore.setTermConditions(TERMS_CONDITION_URL);
    }
  } else {
    appStore.setTermConditions(TERMS_CONDITION_URL);
  }

  if (!_dashboardResponse.inquiryEmail.isEmptyOrNull) {
    appStore.setInquiryEmail(_dashboardResponse.inquiryEmail.validate());
  } else {
    appStore.setInquiryEmail(HELP_SUPPORT_URL);
  }

  if (!_dashboardResponse.helplineNumber.isEmptyOrNull) {
    appStore.setHelplineNumber(_dashboardResponse.helplineNumber.validate());
  } else {
    appStore.setHelplineNumber(HELP_SUPPORT_URL);
  }

  if (_dashboardResponse.languageOption != null) {
    setValue(SERVER_LANGUAGES,
        jsonEncode(_dashboardResponse.languageOption!.toList()));
  }

  if (_dashboardResponse.configurations
      .validate()
      .any((element) => element.type == CONFIGURATION_TYPE_CURRENCY)) {
    Configuration data = _dashboardResponse.configurations!
        .firstWhere((element) => element.type == CONFIGURATION_TYPE_CURRENCY);

    if (data.country!.currencyCode.validate() != appStore.currencyCode)
      appStore.setCurrencyCode(data.country!.currencyCode.validate());
    if (data.country!.id.validate().toString() != appStore.countryId.toString())
      appStore.setCurrencyCountryId(data.country!.id.validate().toString());
    if (data.country!.symbol.validate() != appStore.currencySymbol)
      appStore.setCurrencySymbol(data.country!.symbol.validate());
  }

  if (_dashboardResponse.configurations
      .validate()
      .any((element) => element.key == CONFIGURATION_TYPE_CURRENCY_POSITION)) {
    Configuration data = _dashboardResponse.configurations!.firstWhere(
        (element) => element.key == CONFIGURATION_TYPE_CURRENCY_POSITION);

    if (data.value.validate().isNotEmpty) {
      setValue(CURRENCY_POSITION, data.value);
    }
  }

  if (_dashboardResponse.paymentSettings != null) {
    setValue(PAYMENT_LIST,
        PaymentSetting.encode(_dashboardResponse.paymentSettings.validate()));
  }
  appStore.setLoading(false);

  return _dashboardResponse;
}
//endregion

//region Service Api
Future<ServiceDetailResponse> getServiceDetail(Map request) async {
  return ServiceDetailResponse.fromJson(await handleResponse(
      // await buildHttpResponse('service-detail',
      await buildHttpResponse('services',
          request: request, method: HttpMethod.GET)));
}

Future<ServiceDetailResponse> getServiceDetails(
    {required int serviceId, int? customerId}) async {
  Map request = {
    CommonKeys.serviceId: serviceId,
    if (appStore.isLoggedIn) CommonKeys.customerId: customerId
  };
  // print("Request Detail List $request");
  return ServiceDetailResponse.fromJson(
    await handleResponse(
      // await buildHttpResponse('service-detail',
      await buildHttpResponse('services/$serviceId',
          // request: request, method: HttpMethod.GET)));
          request: request,
          method: HttpMethod.GET),
    ),
  );
}

Future<ServiceResponse> getSearchListServices({
  String categoryId = '',
  String providerId = '',
  String handymanId = '',
  String isPriceMin = '',
  String isPriceMax = '',
  String search = '',
  String latitude = '',
  String longitude = '',
  String isFeatured = '',
  String subCategory = '',
  String brandId = '',
  int page = 1,
}) async {
  // log(subCategory);
  String categoryIds = categoryId.isNotEmpty ? 'category_id=$categoryId&' : '';
  String searchPara = search.isNotEmpty ? 'search=$search&' : '';
  String providerIds = providerId.isNotEmpty ? 'provider_id=$providerId&' : '';
  String isPriceMinPara =
      isPriceMin.isNotEmpty ? 'is_price_min=$isPriceMin&' : '';
  String isPriceMaxPara =
      isPriceMax.isNotEmpty ? 'is_price_max=$isPriceMax&' : '';
  String latitudes = latitude.isNotEmpty ? 'latitude=$latitude&' : '';
  String longitudes = longitude.isNotEmpty ? 'longitude=$longitude&' : '';
  String isFeatures = isFeatured.isNotEmpty ? 'is_featured=$isFeatured&' : '';
  String subCategorys = subCategory.validate().isNotEmpty
      ? subCategory != "-1"
          ? 'subcategory_id=$subCategory&'
          : ''
      : '';
  String brandIds = brandId.validate().isNotEmpty
      ? brandId != "-1"
          ? 'brand_id=$brandId&'
          : ''
      : '';
  String pages = 'page=$page&';
  String perPages = 'per_page=$PER_PAGE_ITEM';

  return ServiceResponse.fromJson(await handleResponse(
    await buildHttpResponse(
        // 'search-list?$categoryIds$providerIds$isPriceMinPara$isPriceMaxPara$subCategorys$searchPara$latitudes$longitudes$isFeatures$pages$perPages'),
        'services?$categoryIds$brandIds$providerIds$isPriceMinPara$isPriceMaxPara$subCategorys$searchPara$latitudes$longitudes$isFeatures$pages$perPages'),
  ));
}

Future<ServiceResponse> getServiceList(int page,
    {bool isCurrentLocation = false,
    String? searchTxt,
    bool isSearch = false,
    int? categoryId,
    bool isCategoryWise = false,
    int? customerId,
    double? lat,
    double? long}) async {
  if (isCategoryWise) {
    if (isCurrentLocation) {
      return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse(
          'services?per_page=$PER_PAGE_ITEM&category_id=$categoryId&page=$page&customer_id=$customerId&latitude=$lat&longitude=$long',
          // 'service-list?per_page=$PER_PAGE_ITEM&category_id=$categoryId&page=$page&customer_id=$customerId&latitude=$lat&longitude=$long',
          method: HttpMethod.GET)));
    } else {
      return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse(
          'services?per_page=$PER_PAGE_ITEM&category_id=$categoryId&page=$page&customer_id=$customerId',
          method: HttpMethod.GET)));
    }
  } else if (isSearch) {
    if (isCurrentLocation)
      return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse(
          'services?per_page=$PER_PAGE_ITEM&page=$page&customer_id=$customerId&search=$searchTxt&latitude=$lat&longitude=$long',
          method: HttpMethod.GET)));
    else
      return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse(
          'services?per_page=$PER_PAGE_ITEM&page=$page&customer_id=$customerId&search=$searchTxt',
          method: HttpMethod.GET)));
  } else {
    if (isCurrentLocation)
      return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse(
          'services?per_page=$PER_PAGE_ITEM&page=$page&customer_id=$customerId&latitude=$lat&longitude=$long',
          method: HttpMethod.GET)));
    else
      return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse(
          'services?per_page=$PER_PAGE_ITEM&page=$page&customer_id=$customerId',
          method: HttpMethod.GET)));
  }
}

Future<ServiceResponse> getProductServiceList(int page,
    {int? categoryId, int? customerId, double? lat, double? long}) async {
  return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse(
      'services?per_page=$PER_PAGE_ITEM&page=$page&category_id=$categoryId&customer_id=$customerId&latitude=$lat&longitude=$long',
      method: HttpMethod.GET)));
}
//endregion

//region Category Api
Future<CategoryResponse> getCategoryList(String page) async {
  return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse(
      'category-list?page=$page&per_page=$PER_PAGE_ITEM',
      method: HttpMethod.GET)));
}

//endregion
//new Api Category
Future<CategoriesResponse> getCategoriesList() async {
  return CategoriesResponse.fromJson(await handleResponse(
      await buildHttpResponse('categories?orderBy=position&sortedBy=asc',
          method: HttpMethod.GET)));
}

Future<CategoriesResponse> getCategoriesListID({required int catId}) async {
  return CategoriesResponse.fromJson(await handleResponse(
      await buildHttpResponse('categories/$catId', method: HttpMethod.GET)));
}

Future<CategoriesResponse> getCategoriesListByID(
    {required int catId, int page = 1}) async {
  return CategoriesResponse.fromJson(await handleResponse(
      await buildHttpResponse(
          'categories/find/$catId?page=$page&orderBy=position&sortedBy=asc',
          method: HttpMethod.GET)));
}

//region SubCategory Api
Future<CategoryResponse> getSubCategoryList({required int catId}) async {
  return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse(
      'subcategory-list?category_id=$catId&per_page=all',
      method: HttpMethod.GET)));
}
//endregion

//region Provider Api
Future<ProviderInfoResponse> getProviderDetail(int id) async {
  return ProviderInfoResponse.fromJson(await handleResponse(
      await buildHttpResponse('user-detail?id=$id', method: HttpMethod.GET)));
  // return ProviderInfoResponse.fromJson(await handleResponse(
  //     await buildHttpResponse('providers/$id/addresses?page=1',
  //         method: HttpMethod.GET)));
}

Future<ProviderListResponse> getProvider(
    {String? userType = "provider"}) async {
  return ProviderListResponse.fromJson(await handleResponse(
      await buildHttpResponse('user-list?user_type=$userType&per_page=all',
          method: HttpMethod.GET)));
}
//endregion

//region Handyman Api
Future<UserData> getHandymanDetail(int id) async {
  return UserData.fromJson(await handleResponse(
      await buildHttpResponse('user-detail?id=$id', method: HttpMethod.GET)));
}

Future<BaseResponseModel> handymanRating(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('save-handyman-rating',
          request: request, method: HttpMethod.POST)));
}
//endregion

//region Booking Api
Future<List<BookingData>> getBookingList(int customerId, int page,
    {var perPage = PER_PAGE_ITEM,
    String status = '',
    required List<BookingData> bookings,
    Function(bool)? lastPageCallback}) async {
  appStore.setLoading(true);
  BookingListResponse res;

  if (status == BOOKING_TYPE_ALL) {
    res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse(
        'bookings?customer_id=$customerId&orderBy=id&sortedBy=desc&per_page=$perPage&page=$page',
        method: HttpMethod.GET)));
  } else {
    res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse(
        'bookings?customer_id=$customerId&orderBy=id&sortedBy=desc&status=$status&per_page=$perPage&page=$page',
        method: HttpMethod.GET)));
  }

  if (page == 1) bookings.clear();
  bookings.addAll(res.data.validate());
  lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

  appStore.setLoading(false);

  return bookings;
}

Future<BookingDetailResponse> getBookingDetail(
    Map request, int bookingId) async {
  // BookingDetailResponse bookingDetailResponse = BookingDetailResponse.fromJson(
  //     await handleResponse(await buildHttpResponse('booking-detail',
  //         request: request, method: HttpMethod.POST)));
  BookingDetailResponse bookingDetailResponse = BookingDetailResponse.fromJson(
      await handleResponse(await buildHttpResponse('bookings/$bookingId',
          request: request, method: HttpMethod.GET)));
  calculateTotalAmount(
    serviceDiscountPercent: bookingDetailResponse.service != null
        ? bookingDetailResponse.service!.discount
        : null,
    qty: bookingDetailResponse.bookingDetail!.quantity != null
        ? bookingDetailResponse.bookingDetail!.quantity!.toInt()
        : 0,
    detail: bookingDetailResponse.service,
    servicePrice: bookingDetailResponse.service != null
        ? bookingDetailResponse.service!.price.validate()
        : 0,
    taxes: bookingDetailResponse.bookingDetail != null
        ? bookingDetailResponse.bookingDetail!.taxes.validate()
        : null,
    couponData: bookingDetailResponse.couponData,
  );
  return bookingDetailResponse;
}

Future<BaseResponseModel> updateBooking(Map request) async {
  BaseResponseModel baseResponse = BaseResponseModel.fromJson(
      await handleResponse(await buildHttpResponse('booking-update',
          request: request, method: HttpMethod.POST)));
  LiveStream().emit(LIVESTREAM_UPDATE_BOOKING_LIST);

  return baseResponse;
}

Future bookTheServices(Map request) async {
  return await handleResponse(await buildHttpResponse('booking-save',
      request: request, method: HttpMethod.POST));
}

Future bookingServices(Map request) async {
  return await handleResponse(await buildHttpResponse('bookings-save',
      request: request, method: HttpMethod.POST));
}

Future<List<BookingStatusResponse>> bookingStatus() async {
  Iterable res = await (handleResponse(
      await buildHttpResponse('booking-status', method: HttpMethod.GET)));
  return res.map((e) => BookingStatusResponse.fromJson(e)).toList();
}
//endregion

//region Payment Api
Future<BaseResponseModel> savePayment(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('save-payment',
          request: request, method: HttpMethod.POST)));
}
//endregion

//region Notification Api
Future<NotificationListResponse> getNotification(Map request,
    {int? page = 1}) async {
  return NotificationListResponse.fromJson(await handleResponse(
      await buildHttpResponse(
          'notification-list?customer_id=${appStore.userId}',
          request: request,
          method: HttpMethod.POST)));
}
//endregion

//region Review Api
Future<BaseResponseModel> updateReview(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('save-booking-rating',
          request: request, method: HttpMethod.POST)));
}

Future<List<RatingData>> serviceReviews(Map request) async {
  ServiceReviewResponse res = ServiceReviewResponse.fromJson(
      await handleResponse(await buildHttpResponse(
          'service-reviews?per_page=all',
          request: request,
          method: HttpMethod.POST)));
  return res.ratingList.validate();
}

Future<List<RatingData>> handymanReviews(Map request) async {
  ServiceReviewResponse res = ServiceReviewResponse.fromJson(
      await handleResponse(await buildHttpResponse(
          'handyman-reviews?per_page=all',
          request: request,
          method: HttpMethod.POST)));
  return res.ratingList.validate();
}

Future<BaseResponseModel> deleteReview({required int id}) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('delete-booking-rating',
          request: {"id": id}, method: HttpMethod.POST)));
}

Future<BaseResponseModel> deleteHandymanReview({required int id}) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('delete-handyman-rating',
          request: {"id": id}, method: HttpMethod.POST)));
}
//endregion

//region WishList Api
Future<List<ServiceData>> getWishlist(int page,
    {var perPage = PER_PAGE_ITEM,
    required List<ServiceData> services,
    Function(bool)? lastPageCallBack}) async {
  appStore.setLoading(true);

  ServiceResponse serviceResponse = ServiceResponse.fromJson(
      await (handleResponse(await buildHttpResponse(
          'user-favourite-service?per_page=$perPage&page=$page',
          method: HttpMethod.GET))));

  if (page == 1) services.clear();
  services.addAll(serviceResponse.serviceList.validate());

  lastPageCallBack
      ?.call(serviceResponse.serviceList.validate().length != PER_PAGE_ITEM);

  appStore.setLoading(false);
  return services;
}

Future<BaseResponseModel> addWishList(request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('save-favourite',
          method: HttpMethod.POST, request: request)));
}

Future<BaseResponseModel> removeWishList(request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('delete-favourite',
          method: HttpMethod.POST, request: request)));
}
//endregion

//User saved Address

Future<List<SavedAddress>> userSavedAddress(
    {required List<SavedAddress> savedAddress}) async {
  int userId = appStore.userId.validate() != 0 ? appStore.userId.validate() : 0;
  appStore.setLoading(true);
  SavedAddressListResponse res;

  res = SavedAddressListResponse.fromJson(await handleResponse(
      await buildHttpResponse(
          'customers/$userId/addresses?page=1&orderBy=id&sortedBy=desc',
          method: HttpMethod.GET)));
  savedAddress.addAll(res.data.validate());
  appStore.setLoading(false);

  return savedAddress;
}

Future<SavedAddressListResponse> getSavedAddress() async {
  int userId = appStore.userId.validate() != 0 ? appStore.userId.validate() : 0;

  return SavedAddressListResponse.fromJson(await handleResponse(
      // await buildHttpResponse(
      //     'customers/$userId/addresses?page=1&orderBy=id&sortedBy=desc',
      //     method: HttpMethod.GET)));
      await buildHttpResponse(
          'customers/$userId/addresses?orderBy=id&sortedBy=desc',
          method: HttpMethod.GET)));
}

Future<AddressResponse> getAddress({int? page}) async {
  int userId = appStore.userId.validate() != 0 ? appStore.userId.validate() : 0;
  if (page != null) {
    return AddressResponse.fromJson(await handleResponse(
        await buildHttpResponse('customers/$userId/addresses?page=$page',
            method: HttpMethod.GET)));
  }

  return AddressResponse.fromJson(await handleResponse(await buildHttpResponse(
      'customers/$userId/addresses?orderBy=id&sortedBy=desc',
      method: HttpMethod.GET)));
}

Future<dynamic> deletedAddress(id) async {
  int userId = appStore.userId.validate() != 0 ? appStore.userId.validate() : 0;
  return await handleResponse(await buildHttpResponse(
      'customers/$userId/addresses/$id',
      method: HttpMethod.DELETE));
}

/////////////////////// Add to Cart ///////////////////////////

Future<AddCartResponse> getCartResponse() async {
  if (appStore.isLoggedIn) {
    return AddCartResponse.fromJson(await handleResponse(
        await buildHttpResponse('customer/cart', method: HttpMethod.GET)));
  } else {
    return AddCartResponse();
  }
}

Future<AddCartResponse> updateCartResponse(Map request) async {
  return AddCartResponse.fromJson(await handleResponse(await buildHttpResponse(
      'customer/cart/update',
      method: HttpMethod.PUT,
      request: request)));
}

Future<AddCartResponse> insertCartResponse(Map request, id) async {
  return AddCartResponse.fromJson(await handleResponse(await buildHttpResponse(
      'customer/cart/add/$id',
      method: HttpMethod.POST,
      request: request)));
}

Future<AddCartResponse> deleteCartResponse(int id) async {
  return AddCartResponse.fromJson(await handleResponse(await buildHttpResponse(
      'customer/cart/remove/$id',
      method: HttpMethod.DELETE)));
}

Future<AddCartResponse> deleteAllCartResponse() async {
  return AddCartResponse.fromJson(await handleResponse(await buildHttpResponse(
      'customer/cart/empty',
      method: HttpMethod.DELETE)));
}

Future<ServiceData> getServiceDetailId({required int serviceId}) async {
  appStore.setLoading(true);
  ServiceData serviceData = ServiceData.fromJson(await handleResponse(
      await buildHttpResponse('services/$serviceId', method: HttpMethod.GET)));
  appStore.setLoading(false);
  return serviceData;
}

Future<SavedAddress> getUserAddreses({required int customerId}) async {
  return SavedAddress.fromJson(await handleResponse(await buildHttpResponse(
      'customers/$customerId/addresses',
      method: HttpMethod.GET)));
}
