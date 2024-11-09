import 'package:com.gogospider.booking/component/back_widget.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:nb_utils/nb_utils.dart';

class CreditCardFormatPage extends StatefulWidget {
  @override
  _CreditCardFormatPageState createState() => _CreditCardFormatPageState();
}

class _CreditCardFormatPageState extends State<CreditCardFormatPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CardSystemData? _cardSystemData;

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();

  Widget _getText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
      ),
      child: Text(
        text,
        style: boldTextStyle(size: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: appBarWidget(language.payment,
          color: context.primaryColor,
          textColor: Colors.white,
          backWidget: BackWidget()),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _getText(
                      'This form allows you to easily type a credit / debit card data'),
                  SizedBox(height: 20.0),
                  _getText('Any small latin letter'),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '#### #### #### ####',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(.3),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      MaskedInputFormatter(
                        "#### #### #### ####",
                      ),
                    ],
                  ),
                  _getText('Card number'),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'CARD NUMBER',
                      labelStyle: TextStyle(color: textPrimaryColorGlobal),
                      // fillColor: textPrimaryColorGlobal,
                      // hintStyle: TextStyle(
                      //   color: textPrimaryColorGlobal,
                      // ),
                      errorStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      CreditCardNumberInputFormatter(
                        useSeparators: true,
                        onCardSystemSelected: (CardSystemData? cardSystemData) {
                          setState(() {
                            _cardSystemData = cardSystemData;
                          });
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                    ),
                    child: Text(
                      _cardSystemData?.system ?? '',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  _getText(
                    'Valid through\n (this formatter won\'t let you type the "month" part value larger than 12)',
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '00/00',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(.3),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      CreditCardExpirationDateFormatter(),
                    ],
                  ),
                  _getText('CVV code'),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '000',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(.3),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      CreditCardCvcInputFormatter(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
