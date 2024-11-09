import 'package:flutter/material.dart';

class Cart {
  late final int? id;
  final int? productId;
  final String? productName;
  final double? initialPrice;
  final double? discountProduct;
  final double? productPrice;
  final ValueNotifier<int>? quantity;
  final String? unitTag;
  final String? image;

  Cart(
      {required this.id,
      required this.productId,
      required this.productName,
      required this.discountProduct,
      required this.initialPrice,
      required this.productPrice,
      required this.quantity,
      required this.unitTag,
      required this.image});

  Cart.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        productId = int.parse(data['productId'].toString()),
        productName = data['productName'],
        initialPrice = data['initialPrice'].toDouble(),
        discountProduct = data['discountProduct'].toDouble(),
        productPrice = data['productPrice'].toDouble(),
        quantity = ValueNotifier(data['quantity']),
        unitTag = data['unitTag'],
        image = data['image'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'initialPrice': initialPrice!.toDouble(),
      'discountProduct': discountProduct!.toDouble(),
      'productPrice': productPrice!.toDouble(),
      'quantity': quantity?.value,
      'unitTag': unitTag,
      'image': image,
    };
  }

  Map<String, dynamic> quantityMap() {
    return {
      'productId': productId,
      'quantity': quantity!.value,
    };
  }
}
