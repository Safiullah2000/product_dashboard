// import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product.dart';
import '../../data/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository repository;
  ProductCubit({required this.repository}) : super(ProductInitial());

  bool? _stockFilter;
  bool? get currentStockFilter => _stockFilter;
  List<Product> _allProducts = [];

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final products = await repository.fetchProducts();
      _allProducts = products;
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  List<Product> _applyFilters() {
    List<Product> filtered = [..._allProducts];

    // Stock filter
    if (_stockFilter != null) {
      if (_stockFilter == true) {
        filtered = filtered.where((p) => p.inStock == true).toList();
      } else {
        filtered = filtered.where((p) => p.inStock == false).toList();
      }
    }

    return filtered;
  }

  void filterByStock(bool? value) {
    _stockFilter = value;
    if (state is ProductLoaded) {
      emit(ProductLoaded(products: _applyFilters()));
    }
  }

  Future<void> addProduct(Product product) async {
    if (state is ProductLoaded) {
      await repository.addProduct(product);
      await loadProducts();
    }
  }

  Future<void> updateProduct(Product product) async {
    if (state is ProductLoaded) {
      await repository.updateProduct(product);
      await loadProducts();
    }
  }

  Future<void> deleteProduct(int id) async {
    if (state is ProductLoaded) {
      await repository.deleteProduct(id);
      await loadProducts();
    }
  }
}
