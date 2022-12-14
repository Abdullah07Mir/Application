import 'dart:html';

import 'package:application_4/screens/edit_product_screen.dart';
import 'package:application_4/widgets/app_drawer.dart';
import 'package:application_4/widgets/user_product_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart ';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Product>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<Product>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Product>(
                      builder:(ctx, productData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productData.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                  productData.items[i].id,
                                  productData.items[i].title,
                                  productData.items[i].imageUrl),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
