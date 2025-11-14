part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final String? filter;
  final String? search;

  ProductLoaded({required this.products, this.filter, this.search});

  ProductLoaded copyWith({
    List<Product>? products,
    String? filter,
    String? search,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      filter: filter ?? this.filter,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props => [products, filter, search];
}

class ProductError extends ProductState {
  final String message;
  ProductError({required this.message});

  @override
  List<Object?> get props => [message];
}
