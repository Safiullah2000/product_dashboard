import 'package:flutter/material.dart';
import '../../models/product.dart';

class ProductTable extends StatelessWidget {
  final List<Product> products;
  final void Function(Product) onEdit;
  final void Function(Product) onView;
  final void Function(Product) onDelete;

  const ProductTable({
    required this.products,
    required this.onEdit,
    required this.onView,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Responsive: use DataTable on wide screens, GridView on narrow
    final width = MediaQuery.of(context).size.width;
    if (width > 900) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: SizedBox(
              width: constraints.maxWidth,
              child: DataTable(
                columnSpacing: 38,
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Stock')),
                  DataColumn(label: Text('Actions')),
                ],
                rows:
                    products
                        .map(
                          (p) => DataRow(
                            cells: [
                              DataCell(Text(p.id.toString())),
                              DataCell(Text(p.name), onTap: () => onView(p)),
                              DataCell(Text(p.category)),
                              DataCell(Text('\$${p.price.toStringAsFixed(2)}')),
                              DataCell(
                                Text(p.inStock ? 'In stock' : 'Out of stock'),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      hoverColor: Colors.purple[100],
                                      icon: const Icon(Icons.visibility),
                                      onPressed: () => onView(p),
                                    ),
                                    IconButton(
                                      hoverColor: Colors.purple[100],
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => onEdit(p),
                                    ),
                                    IconButton(
                                      hoverColor: Colors.purple[100],
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => onDelete(p),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
              ),
            ),
          );
        },
      );
    }

    // mobile / narrow: grid
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3,
      ),
      itemCount: products.length,
      itemBuilder: (context, i) {
        final p = products[i];
        return Card(
          child: ListTile(
            title: Text(p.name),
            subtitle: Text('${p.category} • \$${p.price.toStringAsFixed(2)}'),
            trailing: PopupMenuButton<int>(
              onSelected: (v) {
                if (v == 1) onView(p);
                if (v == 2) onEdit(p);
                if (v == 3) onDelete(p);
              },
              itemBuilder:
                  (_) => [
                    const PopupMenuItem(value: 1, child: Text('View')),
                    const PopupMenuItem(value: 2, child: Text('Edit')),
                    const PopupMenuItem(value: 3, child: Text('Delete')),
                  ],
            ),
          ),
        );
      },
    );
  }
}
