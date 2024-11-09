import 'dart:ffi';

class BookingInsertResponse {
  Int? couponId;
  Int? customerId;
  Int? providerId;
  Double? amount;
  Double? totalAmount;
  String? date;
  List<ItemData>? items;
  BookingInsertResponse(
      {this.couponId,
      this.customerId,
      this.providerId,
      this.amount,
      this.totalAmount,
      this.date,
      this.items});
  factory BookingInsertResponse.fromJson(Map<String, dynamic> json) {
    return BookingInsertResponse(
      couponId: json['coupon_id'],
      customerId: json['customer_id'],
      providerId: json['provider_id'],
      amount: json['amount'],
      totalAmount: json['total_amount'],
      date: json['date'],
      items: json['items'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coupon_id'] = this.couponId;
    data['customer_id'] = this.customerId;
    data['provider_id'] = this.providerId;
    data['amount'] = this.amount;
    data['total_amount'] = this.totalAmount;
    data['date'] = this.date;
    data['items'] = this.items;
    return data;
  }
}

class ItemData {
  Int? serviceId;
  Int? quantity;
  Double? discount;
  Double? total;
  ItemData({this.serviceId, this.quantity, this.discount, this.total});
  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
        serviceId: json['service_id'],
        quantity: json['quantity'],
        discount: json['discount'],
        total: json['total']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['quantity'] = this.quantity;
    data['discount'] = this.discount;
    data['total'] = this.total;
    return data;
  }
}
