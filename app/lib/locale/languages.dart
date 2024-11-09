// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) =>
      Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get phone;

  String get walkTitle1;

  String get walkTitle2;

  String get walkTitle3;

  String get getStarted;

  String get welcomeTxt;

  String get signIn;

  String get signUp;

  String get signInTitle;

  String get signUpTitle;

  String get hintNameTxt;

  String get hintFirstNameTxt;

  String get hintLastNameTxt;

  String get hintContactNumberTxt;

  String get passwordErrorTxt;

  String get hintEmailAddressTxt;

  String get hintUserNameTxt;

  String get hintPasswordTxt;

  String get hintEmailTxt;

  String get hintConfirmPasswordTxt;

  String get forgotPassword;

  String get reset;

  String get signInWithTxt;

  String get alreadyHaveAccountTxt;

  String get rememberMe;

  String get forgotPasswordTitleTxt;

  String get resetPassword;

  String get dashboard;

  String get search;

  String get loginSuccessfully;

  String get saveChanges;

  String get camera;

  String get language;

  String get supportLanguage;

  String get appTheme;

  String get bookingHistory;

  String get history;

  String get rateUs;

  String get termsCondition;

  String get helpSupport;

  String get privacyPolicy;

  String get about;

  String get changePassword;

  String get logout;

  String get logoutTxt;

  String get editProfile;

  String get afterLogoutTxt;

  String get chooseTheme;

  String get selectCountry;

  String get selectState;

  String get selectCity;

  String get confirm;

  String get passwordNotMatch;

  String get doNotHaveAccount;

  String get hintReenterPasswordTxt;

  String get hintOldPasswordTxt;

  String get hintNewPasswordTxt;

  String get hintAddress;

  String get hintCouponCode;

  String get hintDescription;

  String get continueTxt;

  String get lblSeenMore;

  String get lblSeenLess;

  String get lblGallery;

  String get lblProvider;

  String get yourReview;

  String get review;

  String get lblAddress;

  String get lblCouponCode;

  String get lblDescription;

  String get lblNew;

  String get lblApply;

  String get bookTheService;

  String get cantLogin;

  String get contactAdmin;

  String get allServices;

  String get availableCoupon;

  String get duration;

  String get takeTime;

  String get hourly;

  String get providerDetail;

  String get contact;

  String get from;

  String get serviceList;

  String get serviceGallery;

  String get payment;

  String get done;

  String get paymentMethod;

  String get totalAmount;

  String get couponDiscount;

  String get discountOnMRP;

  String get quantity;

  String get rate;

  String get priceDetail;

  String get home;

  String get category;

  String get booking;

  String get profile;

  String get bookService;

  String get dateTime;

  String get selectDateTime;

  String get bookingSummary;

  String get bookingAt;

  String get lblAlertBooking;

  String get applyCoupon;

  String get bookingService;

  String get serviceName;

  String get customerName;

  String get expDate;

  String get discount;

  String get typeOfService;

  String get thingsInclude;

  String get safetyFee;

  String get itemTotal;

  String get loginToApply;

  String get service;

  String get viewAllService;

  String get lblCancelReason;

  String get lblreason;

  String get enterReason;

  String get noDataAvailable;

  String get contactProvider;

  String get contactHandyman;

  String get pricingDetail;

  String get lblOk;

  String get paymentDetail;

  String get paymentStatus;

  String get totalAmountPaid;

  String get viewDetail;

  String get bookingStatus;

  String get appThemeLight;

  String get appThemeDark;

  String get appThemeDefault;

  String get lblCheckInternet;

  String get markAsRead;

  String get deleteAll;

  String get lblInternetWait;

  String get toastPaymentFail;

  String get toastEnterDetail;

  String get toastEnterAddress;

  String get toastReason;

  String get lblComplete;

  String get lblHoldReason;

  String get cancelled;

  String get lblYes;

  String get lblNo;

  String get lblRateApp;

  String get lblRateTitle;

  String get lblHintRate;

  String get btnRate;

  String get btnLater;

  String get toastRateUs;

  String get toastAddReview;

  String get toastSorry;

  String get btnSubmit;

  String get walkThrough1;

  String get walkThrough2;

  String get walkThrough3;

  String get lblSkip;

  String get lnlNotification;

  String get lblUnAuthorized;

  String get btnNext;

  String get lblViewAll;

  String get notAvailable;

  String get serviceAvailable;

  String get writeMsg;

  String get dltMsg;

  String get lblFavorite;

  String get lblchat;

  String get lblcart;

  String get addAddess;

  String get allProvider;

  String get getLocation;

  String get setAddress;

  String get requiredText;

  String get phnrequiredtext;

  String get phnvalidation;

  String get lblVeiwAll;

  String get toastLocationOff;

  String get toastLocationOn;

  String get paymentConfirmation;

  String get lblCall;

  String get lblRateHandyman;

  String get msgForLocationOn;

  String get msgForLocationOff;

  String get btnCurrent;

  String get lblenterPhnNumber;

  String get btnSendOtp;

  String get enterOtp;

  String get lblLocationOff;

  String get ratings;

  String get lblAppSetting;

  String get lblVersion;

  String get txtProvider;

  String get lblShowMore;

  String get txtPassword;

  String get lblShowLess;

  String get lblSignInTitle;

  String get lblSignUpTitle;

  String get lblSignUpInfo;

  String get txtCreateAccount;

  String get lblSignInHere;

  String get lblLogInHere;

  String get lblTaxAmount;

  String get lblSubTotal;

  // Add data
  String get lblNoData;

  String get lblImage;

  String get lblVideo;

  String get lblAudio;

  String get lblChangePwdTitle;

  String get lblForgotPwdSubtitle;

  String get lblLoginTitle;

  String get lblLoginSubTitle;

  String get btnTextLogin;

  String get lblOrContinueWith;

  String get lblHelloUser;

  String get lblSignUpSubTitle;

  String get lblStepper1Title;

  String get lblDateAndTime;

  String get lblEnterDateAndTime;

  String get lblYourAddress;

  String get lblEnterYourAddress;

  String get lblUseCurrentLocation;

  String get lblEnterDescription;

  String get lblPrice;

  String get lblTax;

  String get lblDiscount;

  String get lblAvailableCoupons;

  String get lblPrevious;

  String get lblBooking;

  String get lblCoupon;

  String get lblEditYourReview;

  String get lblTime;

  String get textProvider;

  String get lblConfirmBooking;

  String get lblConfirmMsg;

  String get lblCancel;

  String get lblExpiryDate;

  String get lblRemoveCoupon;

  String get lblNoCouponsAvailable;

  String get lblStep1;

  String get lblStep2;

  String get lblBookingID;

  String get lblDate;

  String get lblAboutHandyman;

  String get lblAboutProvider;

  String get lblNotRatedYet;

  String get lblDeleteReview;

  String get lblConfirmReviewSubTitle;

  String get lblConfirmService;

  String get lblConFirmResumeService;

  String get lblEndServicesMsg;

  String get lblCancelBooking;

  String get lblStart;

  String get lblHold;

  String get lblResume;

  String get lblPayNow;

  String get lblCheckStatus;

  String get lblID;

  String get lblNoBookingsFound;

  String get lblCategory;

  String get lblYourComment;

  String get lblIntroducingCustomerRating;

  String get lblSeeYourRatings;

  String get lblFeatured;

  String get lblNoServicesFound;

  String get lblNoChatFound;

  String get lblGENERAL;

  String get lblAboutApp;

  String get lblPurchaseCode;

  String get lblReviewsOnServices;

  String get lblNoRateYet;

  String get lblSetting;

  String get lblMemberSince;

  String get lblFilterBy;

  String get lblAllFiltersCleared;

  String get lblClearFilter;

  String get lblNumber;

  String get lblNoReviews;

  String get lblUnreadNotification;

  String get lblChoosePaymentMethod;

  String get lblNoPayments;

  String get lblPayWith;

  String get payWith;

  String get lblYourRating;

  String get lblEnterReview;

  String get lblDelete;

  String get lblDeleteRatingMsg;

  String get lblSelectRating;

  String get lblServiceRatings;

  String get lblNoServiceRatings;

  String get lblSearchFor;

  String get lblRating;

  String get lblAvailableAt;

  String get lblRelatedServices;

  String get lblBookNow;

  String get lblWelcomeToHandyman;

  String get lblWalkThroughSubTitle;

  String get textHandyman;

  String get lblChooseFromMap;

  String get lblAbout;

  String get lblDeleteAddress;

  String get lblDeleteSunTitle;

  String get lblFaq;

  String get lblServiceFaq;

  String get lblLogoutTitle;

  String get lblLogoutSubTitle;

  String get lblFeaturedProduct;

  String get lblRequiredValidation;

  String get lblAlert;

  String get lblLocationOffMsg;

  String get lblOnBase;

  String get lblInvalidCoupon;

  String get lblSelectCode;

  String get lblBackPressMsg;

  String get lblHour;

  String get lblHr;

  String get lblOff;

  String get lblHelplineNumber;

  String get lblNotAvailableNumber;

  String get lblSubcategories;

  String get lblAgree;

  String get lblTermsOfService;

  String get lblPrivacyPolicy;

  String get lblWalkThrough0;

  String get lblServiceTotalTime;

  String get lblDateTimeUpdated;

  String get lblSelectDate;

  String get lblReasonCancelling;

  String get lblReasonRejecting;

  String get lblFailed;

  String get lblNoChatsFound;

  String get lblNotDescription;

  String get lblMaterialTheme;

  String get lblServiceProof;

  String get lblAndroid12Support;

  String get lblSignInWithGoogle;

  String get lblSignInWithOTP;

  String get lblEditService;

  String get lblOnlyUserCanLoggedInHere;

  String get lblDangerZone;

  String get lblDeleteAccount;

  String get lblUnderMaintenance;

  String get lblCatchUpAfterAWhile;

  String get lblId;

  String get lblMethod;

  String get lblStatus;

  String get lblPending;

  String get confirmationRequestTxt;

  String get lblDeleteAccountConformation;

  String get lblAutoSliderStatus;

  String get lblPickAddress;

  String get lblUpdateDateAndTime;

  String get lblRecheck;

  String get lblLoginAgain;

  String get lblAcceptTermsCondition;

  String get lblOTPLogin;

  String get lblUpdate;

  String get lblNewUpdate;

  String get lblOptionalUpdateNotify;

  String get lblAddToCart;

  String get lblOption;

  String get lblProduct;

  String get lblCleaningServices;

  String get lblInstallationServices;

  String get lblYourCart;

  String get lblRepairServices;

  String get lblMachines;

  String get lblIncluded;

  String get lblProductsandServices;

  String get lblUnit;

  String get lblItemName;

  String get lblFrequentlyAddedTogether;

  String get lblExcluded;

  String get lblViewCart;

  String get lblMenu;

  String get lblCustomerReviews;

  String get lblOurMarterialRate;

  String get lblAllItemYouHasBeenAddToCart;

  String get lblBackToHome;

  String get lblBookingSuccessful;

  String get lblType;

  String get lblServiceType;

  String get enterYourBookingId;

  String get item => "Item";

  String get ourHandymanIsOntheWay => "Our Handyman is on the way! Thank";

  String get ourHandyOnThank => "Our Handyman Not Fond!";

  String get qty => "Qty";

  String get amount => "Amount";

  String get viewAllItems => "View All Items";

  String get unPaid => "Unpaid";

  String get lblNext => "Next";

  String get lblExpireOn => "Expire on";

  String get lblPrimary => "Primary";

  String get lblPaymentSuccess => "Payment Successful";

  String get backHome => "Back Home";

  String get lblPaymentProcessing => "Payment Processing";

  String get addNew => "Add New";

  String get newCreditCard => "New Credit Card/Debit Card";

  String get cardInfo => "Card Information";

  String get setAsDefaultAddress => "Set as Default Address";

  String get lblNoThank => "No, Thank";

  String get lblYesChange => "Yes, Change";

  String get changeBookingAddress => "Change Booking Address";

  String get changeBookingAddressCommon =>
      "If you change your booking address, Item in your cart will be clear.";

  String get lblChooseYOurAddress => "Choose Your Address";

  String get searchLocation => "Search Location";

  String get savedAddress => "Saved Address";

  String get defaultAddress => "Default Address";

  String get allow => "Allow";

  String get enableLocationAccess => "Enable Location Access";

  String get enableLocationServiceDetail =>
      "Please Enable location access so we could provide you accurate  result nearest Handyman and provider";
  String get lblSelectAddress => "Select Your Address";

  String get note => "Note";

  String get floor => "Floor";

  String get title => "Title";

  String get addressTitle => "Address Title";

  String get addressType => "Address Type";

  String get chooseYourAvatar => "Choose Your Avatar";

  String get lblChooseYourAvatar => "It can be an emoji or an image";

  String get changeAvatar => "Change Avatar";

  String get newAddress => "New Address";

  String get codeVerification => "Code Verification";

  String get donotReveiveCode => "Don't receive the Code?";

  String get resendCode => "Resend Code";

  String get send => "Send";

  String get descriptionForgotPassword =>
      "Please enter your number Phone and We will send Verification Code your phone Numer";

  String get desNewPassword =>
      "Your New Password must be different from previous Password";

  String get selectLocationToFilterHandymanNearBy =>
      "Select your address to filter our handyman nearly by you address";

  String get bookingAddress => "Booking Address";

  String get textBookingsuccess =>
      "It is a long established fact that a reader will be distracted by the readable";

  String get goToBooking => "Go to Booking";

  String get addToCart => "Add to Cart";

  String get searchBoxLabel => "Search for products and services";

  String get chooseAddressType => 'Choose Address Type';

  String get lblYourSessionExpiredTitle => "Whoops, Your Session has Expixed";

  String get lblYourSessionExpiredSubTitle =>
      "Your session has expixed due to your inactivity. No worry, simply login again.";
  String get lblLogin => "Login";

  String get lblLoginFail => "Login Failed";

  String get lblCreateFail => "Create Failed";

  String get lblLoading => "Loading";

  String get welcomeBack;

  String get whatAddressDoYouWantBooking;

  String get selectDifferentLocation;

  String get lbConfirm;

  String get addDetailAddress;

  String get lblSaveContinue;

  String get allowYourLocationPermissionToAccessYourCurrentLocation;

  String get lblConfirmEnableLocationService;

  String get lblEnableLocationServiceTitle;

  String get lblClose;

  String get lblYourLocationServicesIsDeniedForever;

  String get lblBookingDate;

  String get lblAreyouSureBookingThisInfo;

  String get somethingWentWrong;

  String get verificationCodeNotSend;

  String get invalidVerificationCode;

  String get whereShouldWeSetBookingAddressToYourBooking;

  String get lblReviewDateBooking;

  String get lblReviewAddress;

  String get lblBookingAddress;

  String get lblEdit;

  String get changeAddressContainItemInCartAlert;

  String get lblCofirmation;

  String get pleaseChooseOneAddress;

  String get lblBookingProcessing;

  String get reload;

  String get errorInternetNotAvailable;

  String get tokenExpired;

  String get connectionTimeOut;

  String get errorSomethingWentWrong;

  String get selctedDateInvalid;

  String get yourCurrentTime;

  String get currentdateTime;

  String get shouldSelectedDate;

  String get lblUpdateNow;

  String
      get weFixeSomeBugAndAddedSomeFeatureToMakeYourExperienceAsSmoothAsPossible;

  String get lblTimeToUpdate;

  String get pleaseWait;

  String get back;

  String get lblGetDirection;

  String get searchLocationNearByYou;

  String get chooseThisAddress;

  String get bookingWith;

  String get your;

  String get onMap;

  String get locationThatSaved;

  String get bookingWithSavedLocations;

  String get bookingWithYourCurrentLocation;

  String get bookingDifferentLocationsUsingmap;

  String get lblTip;

  String get lblMapTipString;
}
