import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_dashboard/core/theme/theme_cubit.dart';

import '../blocs/product_cubit.dart';
import '../widgets/product_table.dart';
import '../widgets/product_form_model.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String? categoryFilter;
  String search = '';
  int selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<_NavItemData> navItems = [
    _NavItemData('Dashboard', Icons.dashboard),
    _NavItemData('Products', Icons.list),
    _NavItemData('Settings', Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          key: _scaffoldKey,
          drawer:
              isDesktop
                  ? null
                  : Drawer(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            // Icon(Icons.dashboard, size: 32),
                            // SizedBox(width: 8),
                            Text(
                              'Product Dashboard',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        ...navItems.asMap().entries.map((entry) {
                          int index = entry.key;
                          _NavItemData item = entry.value;
                          return ListTile(
                            leading: Icon(item.icon),
                            title: Text(item.label),
                            selected: selectedIndex == index,
                            onTap: () {
                              setState(() => selectedIndex = index);
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: const Text(
              "Product Dashboard",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            leading:
                isDesktop
                    ? null
                    : IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
            actions: [
              SizedBox(
                width: 260,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (v) {
                    setState(() => search = v);
                  },
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                tooltip: "Toggle Theme",
                icon: Icon(
                  Theme.of(context).brightness == Brightness.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Colors.purple,
                ),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
            ],
          ),
          body: Row(
            children: [
              if (isDesktop)
                Container(
                  width: 210,
                  color: Colors.grey.shade100,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      ...navItems.asMap().entries.map((entry) {
                        int index = entry.key;
                        _NavItemData item = entry.value;
                        return InkWell(
                          onTap: () => setState(() => selectedIndex = index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                            color:
                                selectedIndex == index
                                    ? Colors.purple.shade100
                                    : Colors.transparent,
                            child: Row(
                              children: [
                                Icon(
                                  item.icon,
                                  color:
                                      selectedIndex == index
                                          ? Colors.purple
                                          : Colors.black54,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        selectedIndex == index
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                    color:
                                        selectedIndex == index
                                            ? Colors.purple
                                            : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filters + Add Button
                      Row(
                        mainAxisAlignment:
                            isDesktop
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 160,
                                child: DropdownButtonFormField<String?>(
                                  value: categoryFilter,
                                  hint: Text('Filter by category'),

                                  items:
                                      <String?>[
                                            null,
                                            'Electronics',
                                            'Home',
                                            'Furniture',
                                          ]
                                          .map(
                                            (c) => DropdownMenuItem(
                                              value: c,
                                              child: Text(c ?? 'All'),
                                            ),
                                          )
                                          .toList(),
                                  onChanged:
                                      (v) => setState(() => categoryFilter = v),
                                  decoration: InputDecoration(
                                    labelText: '',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.purple[100]!,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ), // Green border
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.purple[100]!,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ), // Green border when enabled
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.purple[100]!,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ), // Green border when focused
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ), // Adjust padding
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              BlocBuilder<ProductCubit, ProductState>(
                                builder: (context, state) {
                                  return SizedBox(
                                    width: 160,
                                    child: DropdownButtonFormField<bool?>(
                                      value:
                                          context
                                              .read<ProductCubit>()
                                              .currentStockFilter,

                                      items: const [
                                        DropdownMenuItem(
                                          value: null,
                                          child: Text('All'),
                                        ),
                                        DropdownMenuItem(
                                          value: true,
                                          child: Text('In stock'),
                                        ),
                                        DropdownMenuItem(
                                          value: false,
                                          child: Text('Out of stock'),
                                        ),
                                      ],
                                      onChanged: (v) {
                                        context
                                            .read<ProductCubit>()
                                            .filterByStock(v);
                                      },
                                      hint: const Text('Availability'),
                                      decoration: InputDecoration(
                                        labelText: '',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.purple[100]!,
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0),
                                          ), // Green border
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.purple[100]!,
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0),
                                          ), // Green border when enabled
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.purple[100]!,
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0),
                                          ), // Green border when focused
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ), // Adjust padding
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          isDesktop
                              ? ElevatedButton.icon(
                                onPressed:
                                    () => showDialog(
                                      context: context,
                                      builder: (_) => const ProductFormModel(),
                                    ),
                                icon: const Icon(Icons.add),
                                label: const Text('Add Product'),
                              )
                              : SizedBox(width: 0),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Product Table
                      Expanded(
                        child: BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) {
                            if (state is ProductLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is ProductLoaded) {
                              var products = state.products;

                              if (categoryFilter != null) {
                                products =
                                    products
                                        .where(
                                          (p) => p.category == categoryFilter,
                                        )
                                        .toList();
                              }
                              if (search.isNotEmpty) {
                                products =
                                    products
                                        .where(
                                          (p) => p.name.toLowerCase().contains(
                                            search.toLowerCase(),
                                          ),
                                        )
                                        .toList();
                              }

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width -
                                      (isDesktop ? 250 : 0),
                                  child: ProductTable(
                                    products: products,
                                    onEdit:
                                        (p) => showDialog(
                                          context: context,
                                          builder:
                                              (_) =>
                                                  ProductFormModel(product: p),
                                        ),
                                    onView:
                                        (p) =>
                                            context.push('/products/${p.id}'),
                                    onDelete:
                                        (p) => context
                                            .read<ProductCubit>()
                                            .deleteProduct(p.id),
                                  ),
                                ),
                              );
                            } else if (state is ProductError) {
                              return Center(
                                child: Text('Error: ${state.message}'),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton:
              isDesktop
                  ? null
                  : FloatingActionButton(
                    onPressed:
                        () => showDialog(
                          context: context,
                          builder: (_) => const ProductFormModel(),
                        ),
                    child: Icon(Icons.add),
                  ),
        );
      },
    );
  }
}

class _NavItemData {
  final String label;
  final IconData icon;
  _NavItemData(this.label, this.icon);
}
