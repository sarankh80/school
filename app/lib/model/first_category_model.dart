import 'package:com.gogospider.booking/model/pagination_model.dart';

class FirstCategoryResponse {
  List<FirstCategoryData>? categoryList;
  Pagination? pagination;

  FirstCategoryResponse({this.categoryList, this.pagination});

  factory FirstCategoryResponse.fromJson(Map<String, dynamic> json) {
    return FirstCategoryResponse(
      categoryList: json['data'] != null
          ? (json['data'] as List)
              .map((i) => FirstCategoryData.fromJson(i))
              .toList()
          : null,
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryList != null) {
      data['data'] = this.categoryList!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class FirstCategoryData {
  String? categoryImage;
  String? color;
  String? description;
  int? id;
  int? isFeatured;
  String? nameEn;
  String? nameKh;
  int? status;

  FirstCategoryData(
      {this.categoryImage,
      this.color,
      this.description,
      this.id,
      this.isFeatured,
      this.nameEn,
      this.nameKh});

  factory FirstCategoryData.fromJson(Map<String, dynamic> json) {
    return FirstCategoryData(
      categoryImage: json['category_image'],
      color: json['color'],
      description: json['description'],
      id: json['id'],
      isFeatured: json['is_featured'],
      nameEn: json['name_en'],
      nameKh: json['name_kh'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_image'] = this.categoryImage;
    data['color'] = this.color;
    data['description'] = this.description;
    data['id'] = this.id;
    data['is_featured'] = this.isFeatured;
    data['name_en'] = this.nameEn;
    data['name_kh'] = this.nameKh;
    return data;
  }
}
