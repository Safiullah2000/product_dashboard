import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_dashboard/core/theme/app_theme.dart';
import 'package:product_dashboard/core/theme/theme_cubit.dart';

import 'features/product/presentation/pages/product_list_page.dart';
import 'features/product/presentation/pages/product_details_page.dart';
import 'features/product/presentation/blocs/product_cubit.dart';
import 'features/product/data/product_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = ProductRepository();
  await repository.loadInitial();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()), // <-- ADD HERE
      ],
      child: MyApp(repository: repository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ProductRepository repository;
  MyApp({required this.repository, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      initialLocation: '/products',
      routes: [
        GoRoute(
          path: '/products',
          builder: (context, state) => ProductListPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
                return ProductDetailsPage(productId: id);
              },
            ),
          ],
        ),
      ],
    );

    return RepositoryProvider.value(
      value: repository,
      child: BlocProvider(
        create: (_) => ProductCubit(repository: repository)..loadProducts(),
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              title: 'Product Dashboard',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeMode,
              routerConfig: _router,
            );
          },
        ),
      ),
    );
  }
}
