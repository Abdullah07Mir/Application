import 'package:application_4/providers/cart.dart';
import 'package:application_4/providers/product.dart';
import 'package:application_4/providers/products.dart';
import 'package:application_4/screens/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class ProductItems extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // ProductItems(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData= Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        // ignore: sort_child_properties_last
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetail.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Products>(
            //can be used to the rebuild part of the trees
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              // ignore: deprecated_member_use
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toogleFavoriteState(authData.token!, authData.userId);
              },
              // ignore: deprecated_member_use
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItems(product.id, product.price, product.title);
              // ignore: deprecated_member_use
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              // ignore: deprecated_member_use
             ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added items to the Cart',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            // ignore: deprecated_member_use
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
