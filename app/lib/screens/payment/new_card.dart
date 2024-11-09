import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/utils/colors.dart';
import 'package:com.gogospider.booking/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class NewCardScreen extends StatefulWidget {
  @override
  NewCardScreenState createState() => NewCardScreenState();
}

class NewCardScreenState extends State<NewCardScreen> {
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CardSystemData? cardSystemData;
  String? iconCard = ic_visa_card;
  int? maxLegnthInput = 5;
  int? digitPlus = 1;
  // TextEditingController cardNumber = TextEditingController();
  // TextEditingController cardName = TextEditingController();
  // TextEditingController cvv = TextEditingController();
  // TextEditingController expireDate = TextEditingController();

  FocusNode cardNumberFocus = FocusNode();
  FocusNode cardNameFocus = FocusNode();
  FocusNode cvvFocus = FocusNode();
  FocusNode expireDateFocus = FocusNode();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  OutlineInputBorder? errorBorder;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderRadius: BorderRadius.all(radiusCircular(15)),
      borderSide: BorderSide(
        color: borderTextFiled,
        width: 1.0,
      ),
    );

    errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(radiusCircular(15)),
      borderSide: BorderSide(
        color: primaryColor,
        width: 1.0,
      ),
    );
    super.initState();
    // init();
  }

  // Future<void> init() async {
  //   // afterBuildCreated(() {
  //   //   appStore.setLoading(true);
  //   // });

  //   // cardNameFocus.text = appStore.car.validate();
  //   // lNameCont.text = appStore.userLastName.validate();
  //   // emailCont.text = appStore.userEmail.validate();
  //   // userNameCont.text = appStore.userName.validate();
  // }
  // Future<void> update() async {
  //   hideKeyboard(context);

  //   MultipartRequest multiPartRequest =
  //       await getMultiPartRequest('update-profile');
  //   multiPartRequest.fields[UserKeys.firstName] = fNameCont.text;
  //   multiPartRequest.fields[UserKeys.lastName] = lNameCont.text;
  //   multiPartRequest.fields[UserKeys.userName] = userNameCont.text;
  //   multiPartRequest.fields[UserKeys.userType] = LOGIN_TYPE_USER;
  //   multiPartRequest.fields[UserKeys.contactNumber] = mobileCont.text;
  //   multiPartRequest.fields[UserKeys.email] = emailCont.text;
  //   multiPartRequest.fields[UserKeys.countryId] = countryId.toString();
  //   multiPartRequest.fields[UserKeys.stateId] = stateId.toString();
  //   multiPartRequest.fields[UserKeys.cityId] = cityId.toString();
  //   multiPartRequest.fields[CommonKeys.address] = addressCont.text;
  //   if (imageFile != null) {
  //     multiPartRequest.files.add(
  //         await MultipartFile.fromPath(UserKeys.profileImage, imageFile!.path));
  //   } else {
  //     Image.asset(ic_home, fit: BoxFit.cover);
  //   }

  //   Map<String, dynamic> req = {
  //     UserKeys.firstName: userNameCont.text,
  //     UserKeys.firstName: fNameCont.text,
  //     UserKeys.uid: getStringAsync(UID),
  //     'updatedAt': Timestamp.now(),
  //   };

  //   log('req: $req');

  //   multiPartRequest.headers.addAll(buildHeaderTokens());
  //   appStore.setLoading(true);

  //   sendMultiPartRequest(
  //     multiPartRequest,
  //     onSuccess: (data) async {
  //       appStore.setLoading(false);
  //       if (data != null) {
  //         if ((data as String).isJson()) {
  //           LoginResponse res = LoginResponse.fromJson(jsonDecode(data));

  //           saveUserData(res.data!);
  //           finish(context);
  //           toast(res.message.validate().capitalizeFirstLetter());
  //         }
  //       }
  //     },
  //     onError: (error) {
  //       toast(error.toString(), print: true);
  //       appStore.setLoading(false);
  //     },
  //   ).catchError((e) {
  //     appStore.setLoading(false);
  //     toast(e.toString(), print: true);
  //   });
  // }

  // @override
  // void setState(fn) {
  //   if (mounted) super.setState(fn);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.payment,
          color: context.primaryColor,
          textColor: Colors.white,
          backWidget: BackWidget()),
      body: Stack(children: [
        Column(
          children: <Widget>[
            const SizedBox(
              height: 5,
            ),
            CreditCardWidget(
              glassmorphismConfig:
                  useGlassMorphism ? Glassmorphism.defaultConfig() : null,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              // bankName: 'Axis Bank',
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardBgColor: Colors.red,
              backgroundImage:
                  useBackgroundImage ? 'assets/images/card_bg.png' : null,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
              customCardTypeIcons: <CustomCardTypeIcon>[
                CustomCardTypeIcon(
                  cardType: CardType.mastercard,
                  cardImage: Image.asset(
                    'assets/images/mastercard.png',
                    height: 48,
                    width: 48,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${language.cardInfo}',
                      textAlign: TextAlign.left,
                      style: boldTextStyle(size: 20),
                    ).paddingOnly(left: 16, right: 16),
                    CreditCardForm(
                      // autovalidateMode: AutovalidateMode.always,
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      themeColor: Colors.blue,
                      textColor: appTextSecondaryColor,
                      cardNumberDecoration: InputDecoration(
                        labelText: 'Number',
                        hintText: 'XXXX XXXX XXXX XXXX',
                        hintStyle:
                            const TextStyle(color: appTextSecondaryColor),
                        labelStyle:
                            const TextStyle(color: appTextSecondaryColor),
                        focusedBorder: border,
                        enabledBorder: border,
                        errorBorder: errorBorder,
                      ),
                      expiryDateDecoration: InputDecoration(
                        hintStyle:
                            const TextStyle(color: appTextSecondaryColor),
                        labelStyle:
                            const TextStyle(color: appTextSecondaryColor),
                        focusedBorder: border,
                        enabledBorder: border,
                        errorBorder: errorBorder,
                        labelText: 'Expired Date',
                        hintText: 'ex.12/23',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        hintStyle:
                            const TextStyle(color: appTextSecondaryColor),
                        labelStyle:
                            const TextStyle(color: appTextSecondaryColor),
                        focusedBorder: border,
                        enabledBorder: border,
                        errorBorder: errorBorder,
                        labelText: 'CVV',
                        hintText: 'ex.123',
                      ),
                      cardHolderDecoration: InputDecoration(
                        hintStyle:
                            const TextStyle(color: appTextSecondaryColor),
                        labelStyle:
                            const TextStyle(color: appTextSecondaryColor),
                        focusedBorder: border,
                        enabledBorder: border,
                        errorBorder: errorBorder,
                        labelText: 'Card Holder',
                      ),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: RoundedCheckBox(
                        borderColor: context.primaryColor,
                        checkedColor: context.primaryColor,
                        isChecked: false,
                        text: language.setAsDefaultAddress,
                        textStyle: secondaryTextStyle(),
                        size: 20,
                        onTap: (value) async {
                          // await setValue(IS_REMEMBERED, isRemember);
                          // isRemember = !isRemember;
                          // setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
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
                          '${language.lblNext}',
                          textAlign: TextAlign.center,
                          style: boldTextStyle(
                              size: 20, color: scaffoldLightColor),
                        )).onTap(() {
                      if (formKey.currentState!.validate()) {
                        print('valid!');
                      } else {
                        print('invalid!');
                      }
                    })
                  ],
                ),
              ),
            )
          ],
        ),
      ]).paddingAll(16),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
