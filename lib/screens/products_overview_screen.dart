import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/providers/cart.dart';
import 'package:test_app/screens/cart_screen.dart';
import 'package:test_app/widgets/app_drawer.dart';
import 'package:test_app/widgets/badge.dart';
import '../providers/product.dart';
import '../widgets/products_grid.dart';
import '../widgets/product_item.dart';

import '../providers/products.dart';

enum FilteredOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // const ProductsOverviewScreen({Key? key}) : super(key: key);
  var _showFavoritesOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MySHop'),
        actions: [
          PopupMenuButton(
            onSelected: ((FilteredOptions selectedValue) {
              setState(() {
                if (selectedValue == FilteredOptions.Favorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            }),
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilteredOptions.Favorites,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FilteredOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => Badge(
                child: child as Widget,
                value: cart.itemCount.toString(),
                color: Theme.of(context).accentColor),
            child: IconButton(
              onPressed: () =>
                  {Navigator.of(context).pushNamed(CartScreen.routeName)},
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showFavoritesOnly),
    );
  }
}
