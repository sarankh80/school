import 'package:com.gogospider.booking/model/product_model.dart';
import 'package:flutter/material.dart';

class Items {
  final int? id;
  final int? productId;
  ValueNotifier<int>? quantity;
  final String? suk;
  final String? type;
  final String? name;
  final String? couponCode;
  double? price;
  double? total;
  final double? taxPercent;
  final double? taxAmount;
  final double? discountPercent;
  final double? discountAmount;
  // additionalReponse additional;
  final Products? product;
  final String? createdAt;
  final String? updatedAt;

  Items(
      {this.id,
      this.productId,
      this.quantity,
      this.suk,
      this.type,
      this.name,
      this.couponCode,
      this.price,
      this.total,
      this.taxPercent,
      this.taxAmount,
      this.discountPercent,
      this.discountAmount,
      // required this.additional,
      this.product,
      this.createdAt,
      this.updatedAt});
  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
        id: json['id'],
        productId: json['product_id'],
        quantity: ValueNotifier(json["quantity"]),
        suk: json['suk'],
        type: json['type'],
        name: json['name'],
        couponCode: json['coupon_code'],
        price: double.parse(json["price"].toString()),
        total: double.parse(json["total"].toString()),
        taxPercent: double.parse(json["tax_amount"].toString()),
        taxAmount: double.parse(json["tax_amount"].toString()),
        discountPercent: double.parse(json["discount_percent"].toString()),
        discountAmount: double.parse(json["discount_amount"].toString()),
        // additional: additionalReponse.fromJson(json['additional']),
        product: Products.fromJson(json['product']),
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['suk'] = this.suk;
    data['type'] = this.type;
    data['name'] = this.name;
    data['coupon_code'] = this.couponCode;
    data['price'] = this.price;
    data['total'] = this.total;
    data['tax_percent'] = this.taxPercent;
    data['tax_amount'] = this.taxAmount;
    data['discount_percent'] = this.discountPercent;
    data['discount_amount'] = this.discountAmount;
    // data['additional'] = this.additional;
    data['product'] = this.product;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
