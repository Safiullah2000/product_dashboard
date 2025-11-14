import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String category;
  final double price;
  final bool inStock;
  final String? description;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.inStock,
    this.description,
  });

  Product copyWith({
    int? id,
    String? name,
    String? category,
    double? price,
    bool? inStock,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      inStock: inStock ?? this.inStock,
      description: description ?? this.description,
    );
  }

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'] as int,
    name: j['name'] as String,
    category: j['category'] as String,
    price: (j['price'] as num).toDouble(),
    inStock: j['inStock'] as bool,
    description: j['description'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'price': price,
    'inStock': inStock,
    'description': description,
  };

  @override
  List<Object?> get props => [id, name, category, price, inStock, description];
}
