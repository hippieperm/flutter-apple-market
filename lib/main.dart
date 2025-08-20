import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'repositories/product_repository.dart';
import 'viewmodels/product_provider.dart';
import 'views/product_list_page.dart';

void main() {
  runApp(const AppleMarketApp());
}

class AppleMarketApp extends StatelessWidget {
  const AppleMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(ProductRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Apple Market',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF8A3D)),
          useMaterial3: true,
        ),
        home: const ProductListPage(),
      ),
    );
  }
}
