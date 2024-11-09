import 'brand_model.dart';

class CategoriesResponse {
  List<CategoriesData>? categoriesList;

  CategoriesResponse({this.categoriesList});

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      categoriesList: json['data'] != null
          ? (json['data'] as List)
              .map((i) => CategoriesData.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoriesList != null) {
      data['data'] = this.categoriesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoriesData {
  int? id;
  String? name;
  int? parentId;
  String? description;
  String? image;
  String? color;
  int? isFeatured;
  int? status;
  bool isSelected;
  List<BrandResponse>? brands;
  List<CategoriesData>? children;
  bool? home;
  int? countChild;

  CategoriesData(
      {this.id,
      this.name,
      this.parentId,
      this.image,
      this.description,
      this.color,
      this.isFeatured,
      this.status,
      this.isSelected = false,
      this.brands,
      this.children,
      this.home = false,
      this.countChild});

  factory CategoriesData.fromJson(Map<String, dynamic> json) {
    if (json['parent_id'] == null) {
      json['parent_id'] = 0;
    } else {
      json['parent_id'] = json['parent_id'];
    }
    return CategoriesData(
        image: json['image'],
        color: json['color'],
        parentId: json['parent_id'],
        description: json['description'],
        id: json['id'],
        isFeatured: json['is_featured'],
        name: json['name'],
        status: json['status'],
        brands: json['brands'] != null
            ? (json['brands']["data"] as List)
                .map((i) => BrandResponse.fromJson(i))
                .toList()
            : null,
        children: json['children'] != null
            ? (json['children']["data"] as List)
                .map((i) => CategoriesData.fromJson(i))
                .toList()
            : null,
        countChild: json["counts"] != null ? json["counts"] : 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['color'] = this.color;
    data['description'] = this.description;
    data['id'] = this.id;
    data['is_featured'] = this.isFeatured;
    data['name'] = this.name;
    data['parent_id'] = this.parentId;
    data['status'] = this.status;
    if (this.brands != null) {
      data['brands'] = this.brands;
    }
    if (this.children != null) {
      data['children'] = this.children;
    }

    return data;
  }
}
