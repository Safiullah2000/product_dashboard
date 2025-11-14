import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product.dart';
import '../blocs/product_cubit.dart';

class ProductFormModel extends StatefulWidget {
  final Product? product;
  const ProductFormModel({this.product, Key? key}) : super(key: key);

  @override
  State<ProductFormModel> createState() => _ProductFormModalState();
}

class _ProductFormModalState extends State<ProductFormModel> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String category;
  late String price;
  bool inStock = true;
  late String description;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    name = p?.name ?? '';
    category = p?.category ?? '';
    price = p != null ? p.price.toString() : '';
    inStock = p?.inStock ?? true;
    description = p?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.product == null ? 'Add Product' : 'Edit Product',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: name,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator:
                          (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      onSaved: (v) => name = v ?? '',
                    ),
                    TextFormField(
                      initialValue: category,
                      decoration: const InputDecoration(labelText: 'Category'),
                      validator:
                          (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      onSaved: (v) => category = v ?? '',
                    ),
                    TextFormField(
                      initialValue: price,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        final parsed = double.tryParse(v);
                        if (parsed == null) return 'Invalid number';
                        return null;
                      },
                      onSaved: (v) => price = v ?? '0',
                    ),
                    TextFormField(
                      initialValue: description,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      onSaved: (v) => description = v ?? '',
                    ),
                    Row(
                      children: [
                        const Text('In stock'),
                        Switch(
                          value: inStock,
                          onChanged: (v) => setState(() => inStock = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              final p = widget.product;
                              final product = Product(
                                id: p?.id ?? 0,
                                name: name,
                                category: category,
                                price: double.parse(price),
                                inStock: inStock,
                                description: description,
                              );

                              final cubit = context.read<ProductCubit>();
                              if (p == null)
                                cubit.addProduct(product);
                              else
                                cubit.updateProduct(product);

                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
