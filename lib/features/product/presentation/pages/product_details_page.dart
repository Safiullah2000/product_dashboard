import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product.dart';
import '../blocs/product_cubit.dart';
import '../widgets/product_form_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final int productId;
  const ProductDetailsPage({required this.productId, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductCubit>();

    final state = cubit.state;
    Product? product;
    if (state is ProductLoaded)
      product = state.products.firstWhere(
        (p) => p.id == productId,
        orElse:
            () => Product(
              id: 0,
              name: 'Not found',
              category: '-',
              price: 0,
              inStock: false,
            ),
      );

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            product == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Category: ${product.category}'),
                    const SizedBox(height: 8),
                    Text('Price: \$${product.price.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    Text(
                      'Stock: ${product.inStock ? 'In stock' : 'Out of stock'}',
                    ),
                    const SizedBox(height: 12),
                    Text(product.description ?? ''),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed:
                          () => showDialog(
                            context: context,
                            builder: (_) => ProductFormModel(product: product),
                          ),
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                  ],
                ),
      ),
    );
  }
}
