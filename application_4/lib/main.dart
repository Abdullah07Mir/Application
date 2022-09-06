import 'package:application_4/providers/auth.dart';
import 'package:application_4/providers/cart.dart';
import 'package:application_4/providers/orders.dart';
import 'package:application_4/providers/products.dart';
import 'package:application_4/screens/auth_screen.dart';
import 'package:application_4/screens/cart_screen.dart';
import 'package:application_4/screens/edit_product_screen.dart';
import 'package:application_4/screens/products_overview.dart';
import 'package:application_4/screens/user_products.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import './screens/product_detail.dart';
import './providers/product.dart';
import './screens/orders_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
       ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Product>(
          create: (_) => Product('','',[]),
          update : (ctx, auth, previousProducts) => Product(
                auth.token!,
               auth.userId,
                previousProducts == null ? [] : previousProducts.items,
              ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
       ChangeNotifierProxyProvider<Auth, Orders>(
        create: (_) => Orders('',[]),
          update: (ctx, auth, previousOrders) => Orders(
                auth.token!,
                //auth.userId,
                previousOrders == null ? [] : previousOrders.orders,
              ),
        ),
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _)=> MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          // ignore: deprecated_member_use
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: auth.isAuth ? ProductOverview():AuthScreen(),
        routes: {
          ProductDetail.routeName: (ctx) => ProductDetail(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProducts.routeName: (ctx) => UserProducts(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),) 
    );
  }
}