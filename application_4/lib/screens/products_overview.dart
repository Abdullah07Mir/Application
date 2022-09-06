// ignore_for_file: prefer_const_constructors

import 'package:application_4/providers/product.dart';
import 'package:application_4/widgets/app_drawer.dart';

import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterdOptions {
  Favorite,
  All,
}

class ProductOverview extends StatefulWidget {
  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  var _showOnlyFavorites = false;
  var _isInIt = true;
  var _isLoading = false;
  /* void initState() {   --> first technique for fatching data
  @override
    //Provider.of<Product>(context).fetchAndSetProducts();
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Product>(context).fetchAndSetProducts();
    });
    super.initState();
  }*/

  @override
  void didChangeDependencies() {
    // Second Technique
    if (_isInIt) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Product>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInIt = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Product>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterdOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterdOptions.Favorite) {
                  // productsContainer.showFavoritesOnly();
                  _showOnlyFavorites = true;
                } else {
                  // productsContainer.showAll();
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterdOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterdOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              // ignore: sort_child_properties_last
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  }),
              value: cart.itemCount.toString(),
              // ignore: deprecated_member_use
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
