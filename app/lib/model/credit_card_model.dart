import 'package:com.gogospider.booking/model/pagination_model.dart';

class CreditCardResponse {
  List<CareditCardData>? creditCardList;
  Pagination? pagination;

  CreditCardResponse({this.creditCardList, this.pagination});

  factory CreditCardResponse.fromJson(Map<String, dynamic> json) {
    return CreditCardResponse(
      creditCardList: json['data'] != null
          ? (json['data'] as List)
              .map((i) => CareditCardData.fromJson(i))
              .toList()
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.creditCardList != null) {
      data['data'] = this.creditCardList!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class CareditCardData {
  String? cardNumber;
  String? expireDate;
  int? cvv;
  int? id;
  int? isPrimary;
  String? cardName;
  int? status;
  bool isSelected;
  String? icon;

  CareditCardData(
      {this.cardNumber,
      this.expireDate,
      this.cvv,
      this.id,
      this.isPrimary,
      this.cardName,
      this.status,
      this.isSelected = false,
      this.icon});

  factory CareditCardData.fromJson(Map<String, dynamic> json) {
    return CareditCardData(
        cardNumber: json['card_number'],
        expireDate: json['expire_date'],
        cvv: json['cvv'],
        id: json['id'],
        isPrimary: json['is_primary'],
        cardName: json['card_name'],
        status: json['status'],
        icon: json['icon']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['card_number'] = this.cardNumber;
    data['expire_date'] = this.expireDate;
    data['cvv'] = this.cvv;
    data['id'] = this.id;
    data['is_primary'] = this.isPrimary;
    data['card_name'] = this.cardName;
    data['status'] = this.status;
    data['icon'] = this.icon;
    return data;
  }
}
