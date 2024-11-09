import 'dart:convert';

import 'package:com.gogospider.booking/model/booking_list_model.dart';
import 'package:com.gogospider.booking/model/service_detail_response.dart';
import 'package:com.gogospider.booking/model/user_data_model.dart';
import 'package:com.gogospider.booking/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingData {
  int? id;
  SavedAddress? address;
  int? customerId;
  String? customerName;
  int? serviceId;
  int? providerId;
  int? quantity;
  double? price;
  String? type;
  double? discount;
  String? statusLabel;
  String? description;
  String? providerName;
  String? serviceName;
  String? paymentStatus;
  String? paymentMethod;
  String? date;
  String? durationDiff;
  int? paymentId;
  int? bookingAddressId;
  String? durationDiffHour;
  double? totalAmount;
  double? amount;

  CouponData? couponData;
  List<Handyman>? handyman;
  List<String>? serviceAttachments;
  String? status;
  List<TaxData>? taxes;
  List<BookingItem>? items;

  String? reason;
  int? totalReview;
  num? totalRating;
  String? startAt;
  String? endAt;

  //Local
  bool get isHourlyService => type.validate() == SERVICE_TYPE_HOURLY;
  bool get isProviderAndHandymanSame => handyman.validate().isNotEmpty
      ? handyman.validate().first.handymanId.validate() == providerId.validate()
      : false;

  BookingData(
      {this.address,
      this.bookingAddressId,
      this.couponData,
      this.amount,
      this.customerId,
      this.customerName,
      this.date,
      this.description,
      this.discount,
      this.durationDiff,
      this.durationDiffHour,
      this.handyman,
      this.id,
      this.paymentId,
      this.paymentMethod,
      this.paymentStatus,
      this.price,
      this.providerId,
      this.providerName,
      this.quantity,
      this.serviceAttachments,
      this.serviceId,
      this.serviceName,
      this.status,
      this.statusLabel,
      this.taxes,
      this.totalAmount,
      this.type,
      this.reason,
      this.totalReview,
      this.totalRating,
      this.startAt,
      this.endAt,
      this.items});

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      address: json['address'] != null
          ? SavedAddress.fromJson(json['address']["data"])
          : null,
      amount: double.parse(json['amount']),
      totalAmount: double.parse(json['total_amount']),
      bookingAddressId: json['booking_address_id'],
      couponData: json['coupon_data'] != null
          ? CouponData.fromJson(json['coupon_data'])
          : null,
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      date: json['date'],
      description: json['description'],
      discount: 0.00,
      durationDiff: json['duration_diff'],
      durationDiffHour: json['duration_diff_hour'],
      handyman: json['handyman'] != null
          ? (json['handyman'] as List).map((i) => Handyman.fromJson(i)).toList()
          : null,
      id: json['id'],
      paymentId: json['payment_id'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      price: 0.00,
      providerId: json['provider_id'],
      providerName: json['provider_name'],
      quantity: json['quantity'],
      serviceAttachments: json['service_attchments'] != null
          ? new List<String>.from(json['service_attchments'])
          : null,
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      status: json['status'],
      statusLabel: json['status_label'],
      taxes: json['taxes'] != null
          ? (json['taxes'] as List).map((i) => TaxData.fromJson(i)).toList()
          : null,
      type: json['type'],
      reason: json['reason'],
      totalReview: json['total_review'],
      totalRating: json['total_rating'],
      startAt: json['start_at'],
      endAt: json['end_at'],
      items: json['items']["data"] != null
          ? (json['items']["data"] as List)
              .map((i) => BookingItem.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['booking_address_id'] = this.bookingAddressId;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['total_amount'] = this.totalAmount;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['duration_diff'] = this.durationDiff;
    data['duration_diff_hour'] = this.durationDiffHour;
    data['id'] = this.id;
    data['payment_id'] = this.paymentId;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['price'] = this.price;
    data['provider_id'] = this.providerId;
    data['provider_name'] = this.providerName;
    data['quantity'] = this.quantity;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['status'] = this.status;
    data['status_label'] = this.statusLabel;
    data['type'] = this.type;
    data['reason'] = this.reason;
    data['total_review'] = this.totalReview;
    data['total_rating'] = this.totalRating;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    if (this.couponData != null) {
      data['coupon_data'] = this.couponData!.toJson();
    }
    if (this.handyman != null) {
      data['handyman'] = this.handyman!.map((v) => v.toJson()).toList();
    }
    if (this.serviceAttachments != null) {
      data['service_attchments'] = this.serviceAttachments;
    }
    if (this.taxes != null) {
      data['taxes'] = this.taxes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookingInfo {
  String? date;
  String? address;
  double? latitude;
  double? longtitude;
  String? bookingDate;
  String? bookingTime;
  String? bookingDateTime;
  String? bookingDateFormat;
  BookingInfo(
      {this.date,
      this.address,
      this.latitude,
      this.longtitude,
      this.bookingDate,
      this.bookingTime,
      this.bookingDateTime,
      this.bookingDateFormat});
  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    return BookingInfo(
      date: json['date'],
      address: json['address'],
      latitude: json['latitude'],
      longtitude: json['longtitude'],
      bookingDate: json['bookingDate'],
      bookingTime: json['bookingtTime'],
      bookingDateTime: json['bookingDateTime'],
      bookingDateFormat: json['bookingDateFormat'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longtitude'] = this.longtitude;
    data['bookingDate'] = this.bookingDate;
    data['bookingTime'] = this.bookingTime;
    data['bookingDateTime'] = this.bookingDateTime;
    data['bookingDateFormat'] = this.bookingDateFormat;

    return data;
  }

  static Map<String, dynamic> toMap(BookingInfo bookingInfo) => {
        'date': bookingInfo.date,
        'address': bookingInfo.address,
        'latitude': bookingInfo.latitude,
        'longtitude': bookingInfo.longtitude,
        'bookingDate': bookingInfo.bookingDate,
        'bookingTime': bookingInfo.bookingTime,
        'bookingDateTime': bookingInfo.bookingDateTime,
        'bookingDateFormat': bookingInfo.bookingDateFormat,
      };
  static String encode(List<BookingInfo> bookingInfo) => json.encode(
        bookingInfo
            .map<Map<String, dynamic>>(
                (bookingInfo) => BookingInfo.toMap(bookingInfo))
            .toList(),
      );

  static List<BookingInfo> decode(String bookingInfo) =>
      (json.decode(bookingInfo) as List<dynamic>)
          .map<BookingInfo>((item) => BookingInfo.fromJson(item))
          .toList();
}

class BookingItem {
  int? id;
  int? bookingId;
  String? serviceName;
  List<String>? serviceAttachments;
  double? price;
  int? quantity;
  double? discount;
  double? total;

  BookingItem(
      {this.id,
      this.bookingId,
      this.serviceName,
      this.serviceAttachments,
      this.price,
      this.quantity,
      this.discount,
      this.total});

  factory BookingItem.fromJson(Map<String, dynamic> json) {
    return BookingItem(
      id: json['id'],
      bookingId: json['booking_id'],
      serviceName: json['service_name'],
      serviceAttachments: json['service_attchments'] != null
          ? new List<String>.from(json['service_attchments'])
          : null,
      price: double.parse(json['price'].toString()),
      quantity: json['quantity'],
      discount:
          json['discount'] != null ? double.parse(json['discount']) : 0.00,
      total: json['total'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['service_name'] = this.serviceName;
    if (this.serviceAttachments != null) {
      data['service_attchments'] = this.serviceAttachments;
    }
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['discount'] = this.discount;
    data['total'] = this.total;

    return data;
  }
}
