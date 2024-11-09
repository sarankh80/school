import 'package:com.gogospider.booking/model/categories_model.dart';
import 'package:com.gogospider.booking/model/service_detail_response.dart';

class ServiceData {
  int? id;
  String? name;
  int? categoryId;
  int? providerId;
  double? price;
  double? basePrice;
  // String? priceFormat;
  // String? type;
  double? discount;
  String? duration;
  int? status;
  String? description;
  String? included;
  String? excluded;
  String? unit;
  bool? isFeatured;
  String? providerName;
  String? categoryName;
  // String? subCategoryName;
  List<String>? attachments;
  num? totalReview;
  num? totalRating;
  bool? isFavourite;
  List<ServiceAddressMapping>? serviceAddressMapping;

  String? providerImage;
  int? cityId;

  String? createdAt;
  String? customerName;
  List<String>? serviceAttachments;
  num? serviceId;
  num? userId;

  num? totalAmount;
  num? discountPrice;
  num? taxAmount;
  num? couponDiscountAmount;
  String? dateTimeVal;
  String? bookingDescription;
  String? couponCode;
  num? qty;
  String? address;
  int? bookingAddressId;
  CouponData? appliedCouponData;

  List<ServiceData>? children;
  List<ServiceData>? relatedServices;
  List<CategoriesData>? relatedCategories;
  //Local

  // bool get isHourlyService => type.validate() == SERVICE_TYPE_HOURLY;
  bool get isHourlyService => false;

  // bool get isFixedService => type.validate() == SERVICE_TYPE_FIXED;
  bool get isFixedService => false;

  ServiceData({
    this.attachments,
    this.categoryId,
    this.categoryName,
    this.cityId,
    this.description,
    this.included,
    this.excluded,
    this.discount,
    this.duration,
    this.id,
    this.isFeatured,
    this.name,
    this.price,
    this.basePrice,
    this.unit,
    // this.priceFormat,
    this.providerId,
    this.providerName,
    this.status,
    this.totalRating,
    this.totalReview,
    this.providerImage,
    // this.type,
    this.isFavourite,
    this.serviceAddressMapping,
    // this.subCategoryName,
    this.createdAt,
    this.customerName,
    this.serviceAttachments,
    this.serviceId,
    this.userId,
    this.totalAmount,
    this.discountPrice,
    this.taxAmount,
    this.dateTimeVal,
    this.couponCode,
    this.qty,
    this.bookingAddressId,
    this.couponDiscountAmount,
    this.children,
    this.relatedServices,
    this.relatedCategories,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    if (json["data"] == null) {
      json = json;
    } else {
      json = json['data'];
    }
    if (json['discount'] == null) {
      json['discount'] = 0.0;
    } else {
      json['discount'] = double.parse(json['discount'].toString());
    }
    return ServiceData(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      providerId: json['provider_id'],
      price: double.parse(json["price"].toString()),
      basePrice: double.parse(json["base_price"].toString()),
      // priceFormat: json['price_format'],
      // type: json['type'],
      // subCategoryName: json['subcategory_name'],
      discount: json["discount"],
      unit: json['unit'],
      duration: json['duration'],
      status: json['status'],
      description: json['description'],
      included: json['included'],
      excluded: json['excluded'],
      isFeatured: json['is_featured'],
      providerName: json['provider_name'],
      categoryName: json['category_name'],
      attachments: json['attchments'] != null
          ? new List<String>.from(json['attchments'])
          : null,
      totalReview: json['total_review'],
      totalRating: json['total_rating'],
      isFavourite: json['is_favourite'] = false,

      cityId: json['city_id'],
      providerImage: json['provider_image'],
      serviceAddressMapping: json['service_address_mapping'] != null
          ? (json['service_address_mapping'] as List)
              .map((i) => ServiceAddressMapping.fromJson(i))
              .toList()
          : null,
      createdAt: json['created_at'],
      customerName: json['customer_name'],
      serviceAttachments: json['service_attchments'] != null
          ? new List<String>.from(json['service_attchments'])
          : null,
      serviceId: json['service_id'],
      userId: json['user_id'],
      children: json['children'] != null
          ? (json['children']["data"] as List)
              .map((i) => ServiceData.fromJson(i))
              .toList()
          : null,
      relatedServices: json['related_services'] != null
          ? (json['related_services']["data"] as List)
              .map((i) => ServiceData.fromJson(i))
              .toList()
          : null,
      relatedCategories: json['related_categories'] != null
          ? (json['related_categories']["data"] as List)
              .map((i) => CategoriesData.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['city_id'] = this.cityId;
    data['description'] = this.description;
    data['included'] = this.included;
    data['excluded'] = this.excluded;
    data['discount'] = this.discount;
    data['duration'] = this.duration;
    data['id'] = this.id;
    data['is_featured'] = this.isFeatured;
    data['name'] = this.name;
    data['unit'] = this.unit;
    data['price'] = this.price;
    data['base_price'] = this.basePrice;
    // data['price_format'] = this.priceFormat;
    data['provider_id'] = this.providerId;
    data['provider_name'] = this.providerName;
    data['status'] = this.status;
    data['total_rating'] = this.totalRating;
    data['total_review'] = this.totalReview;
    data['provider_image'] = this.providerImage;
    // data['subcategory_name'] = this.subCategoryName;
    data['created_at'] = this.createdAt;
    data['customer_name'] = this.customerName;
    data['service_id'] = this.serviceId;
    data['user_id'] = this.userId;
    // data['type'] = this.type;
    if (this.serviceAttachments != null) {
      data['service_attchments'] = this.serviceAttachments;
    }
    if (this.attachments != null) {
      data['attchments'] = this.attachments;
    }
    data['is_favourite'] = this.isFavourite;
    if (this.serviceAddressMapping != null) {
      data['service_address_mapping'] =
          this.serviceAddressMapping!.map((v) => v.toJson()).toList();
    }
    if (this.children != null) {
      data['children'] = this.children;
    }
    if (this.relatedServices != null) {
      data['related_services'] = this.relatedServices;
    }
    if (this.children != null) {
      data['related_categories'] = this.relatedCategories;
    }
    return data;
  }
}

class ServiceAddressMapping {
  int? id;
  int? serviceId;
  int? providerAddressId;
  String? createdAt;
  String? updatedAt;
  ProviderAddressMapping? providerAddressMapping;

  ServiceAddressMapping(
      {this.id,
      this.serviceId,
      this.providerAddressId,
      this.createdAt,
      this.updatedAt,
      this.providerAddressMapping});

  ServiceAddressMapping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    providerAddressId = json['provider_address_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    providerAddressMapping = json['provider_address_mapping'] != null
        ? new ProviderAddressMapping.fromJson(json['provider_address_mapping'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_id'] = this.serviceId;
    data['provider_address_id'] = this.providerAddressId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.providerAddressMapping != null) {
      data['provider_address_mapping'] = this.providerAddressMapping!.toJson();
    }
    return data;
  }
}

class ProviderAddressMapping {
  int? id;
  int? providerId;
  String? address;
  String? latitude;
  String? longitude;
  var status;
  String? createdAt;
  String? updatedAt;

  ProviderAddressMapping(
      {this.id,
      this.providerId,
      this.address,
      this.latitude,
      this.longitude,
      this.status,
      this.createdAt,
      this.updatedAt});

  ProviderAddressMapping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_id'] = this.providerId;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
