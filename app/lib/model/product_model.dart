import 'package:com.gogospider.booking/model/service_data_model.dart';

class Products {
  int? id;
  String? name;
  int? categoryId;
  double? price;
  double? priceFormat;
  double? discount;
  String? duration;
  int? status;
  String description;
  bool isFeatured;
  String categoryName;
  List<String>? attchments;
  List<String>? serviceAttachments;
  int? totalReview;
  int? totalRating;
  int? isFavourite;
  List<ServiceAddressMapping>? serviceAddressMapping;

  Products({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.priceFormat,
    required this.discount,
    required this.duration,
    required this.status,
    required this.description,
    required this.isFeatured,
    required this.categoryName,
    required this.attchments,
    required this.totalReview,
    required this.totalRating,
    required this.isFavourite,
    // required this.serviceAddressMapping,
  });
  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      price: double.parse(json['price'].toString()),
      priceFormat: double.parse(json['price_format'].toString()),
      discount: json["discount"] != null
          ? double.parse(json['discount'].toString())
          : 0,
      duration: json['duration'],
      status: json['status'],
      description: json['description'] != null ? json['description'] : "",
      isFeatured: json['is_featured'],
      categoryName: json['category_name'],
      attchments: json['attchments'] != null
          ? new List<String>.from(json['attchments'])
          : null,
      totalReview: json['total_review'],
      totalRating: json['total_rating'],
      isFavourite: json['is_favourite'],
      // serviceAddressMapping: json['service_address_mapping'] != null
      //     ? (json['service_address_mapping'] as List)
      //         .map((i) => ServiceAddressMapping.fromJson(i))
      //         .toList()
      //     : null,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['discount'] = this.discount;
    data['duration'] = this.duration;
    data['status'] = this.status;
    data['description'] = this.description;
    data['is_featured'] = this.isFeatured;
    data['category_name'] = this.categoryName;
    data['attchments'] = this.attchments;
    data['total_review'] = this.totalReview;
    data['total_rating'] = this.totalRating;
    data['is_favourite'] = this.isFavourite;
    return data;
  }
}
