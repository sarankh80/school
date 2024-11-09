import 'package:com.gogospider.booking/model/pagination_model.dart';

class AddressResponse {
  List<AddressData>? addressList;
  Pagination? pagination;

  AddressResponse({this.addressList, this.pagination});

  factory AddressResponse.fromJson(Map<String, dynamic> json) {
    return AddressResponse(
      addressList: json['data'] != null
          ? (json['data'] as List).map((i) => AddressData.fromJson(i)).toList()
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressList != null) {
      data['data'] = this.addressList!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class AddressData {
  int? id;
  int? customerId;
  String? latitude;
  String? longitude;
  String? type;
  String? floor;
  String? title;
  String? note;
  String? address;
  int? isDefault;
  int? status;
  String? image;
  String? createdAt;
  String? updatedAt;
  AddressData(
      {this.id,
      this.customerId,
      this.latitude,
      this.longitude,
      this.type,
      this.title,
      this.floor,
      this.note,
      this.address,
      this.isDefault,
      this.status,
      this.image,
      this.createdAt,
      this.updatedAt});

  factory AddressData.fromJson(Map<String, dynamic> json) {
    return AddressData(
      id: json['id'],
      customerId: json['customer_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      type: json['type'],
      floor: json['floor'],
      title: json['title'],
      note: json['note'],
      address: json['address'],
      isDefault: json['is_default'],
      status: json['status'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['type'] = this.type;
    data['title'] = this.title;
    data['floor'] = this.floor;
    data['note'] = this.note;
    data['address'] = this.address;
    data['is_default'] = this.isDefault;
    data['status'] = this.status;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
