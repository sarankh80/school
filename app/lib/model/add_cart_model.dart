import 'package:com.gogospider.booking/model/item_model.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';

class AddCartResponse {
  int? id;
  int? itemsCount;
  double? itemsQty;
  double? subTotal;
  double? grandTotal;
  double? taxTotal;
  double? discount;
  int? isActive;
  List<Items>? items;
  String? couponCode;
  UserData? customer;

  AddCartResponse(
      {this.id,
      this.itemsCount,
      this.itemsQty,
      this.subTotal,
      this.grandTotal,
      this.taxTotal,
      this.discount,
      this.isActive,
      this.items,
      this.couponCode,
      customer});
  factory AddCartResponse.fromJson(dynamic jsons) {
    // var jsonsError = jsons['data'];
    if (jsons == null || jsons['data'] == null) {
      return AddCartResponse();
    } else {
      var json = jsons['data'];
      return AddCartResponse(
          id: json['id'],
          itemsCount: json['items_count'],
          itemsQty: (json["items_qty"] != null
              ? double.parse(json["items_qty"].toString())
              : 0.00),
          subTotal: double.parse(json["sub_total"].toString()),
          grandTotal: double.parse(json["grand_total"].toString()),
          taxTotal: double.parse(json["tax_total"].toString()),
          discount: json["discount"] != null
              ? double.parse(json["discount"].toString())
              : 0,
          isActive: json['is_active'],
          items: json['items'] != null
              ? (json['items'] as List).map((i) => Items.fromJson(i)).toList()
              : null,
          couponCode: json['coupon_code'] != null ? json['coupon_code'] : null,
          customer: UserData.fromJson(json['customer']));
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['items_count'] = this.itemsCount;
    data['items_qty'] = this.itemsQty;
    data['sub_total'] = this.subTotal;
    data['grand_total'] = this.grandTotal;
    data['tax_total'] = this.taxTotal;
    data['discount'] = this.discount;
    data['is_active'] = this.isActive;
    if (this.items != null) {
      data['items'] = this.items;
    }
    data['coupon_code'] = this.couponCode;
    data['customer'] = this.customer;

    return data;
  }
}
