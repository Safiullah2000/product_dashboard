import 'dart:convert';
import '../models/product.dart';
import 'local_data_provider.dart';

class ProductRepository {
  final LocalDataProvider provider = LocalDataProvider();
  final List<Product> _products = [];

  Future<void> loadInitial() async {
    final raw = await provider.loadJsonAsset('assets/products.json');
    final list = json.decode(raw) as List<dynamic>;
    _products.clear();
    _products.addAll(
      list.map((e) => Product.fromJson(e as Map<String, dynamic>)),
    );
  }

  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List<Product>.from(_products);
  }

  Future<Product?> getById(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addProduct(Product product) async {
    final id =
        (_products.isEmpty)
            ? 1
            : (_products.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1);
    final newProduct = product.copyWith(id: id);
    _products.add(newProduct);
  }

  Future<void> updateProduct(Product product) async {
    final idx = _products.indexWhere((p) => p.id == product.id);
    if (idx >= 0) _products[idx] = product;
  }

  Future<void> deleteProduct(int id) async {
    _products.removeWhere((p) => p.id == id);
  }
}
