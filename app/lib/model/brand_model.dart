class BrandResponse {
  int? id;
  String? name;
  int? status;

  BrandResponse({this.id, this.name, this.status});

  factory BrandResponse.fromJson(Map<String, dynamic> json) {
    return BrandResponse(
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
