import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/products_grid.dart';
import '../widgets/product_item.dart';

class ProductsOverviewScreen extends StatelessWidget {
  // const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MySHop'),
      ),
      body: ProductsGrid(),
    );
  }
}
