import 'dart:convert';
import 'package:application_4/models/http_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'products.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Products> _items = [
    // Products(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Products(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Products(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Products(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

//  var _showFavoritesOnly = false;
  final String authToken;
  final String userId;

  Product(this.authToken,this.userId, this._items);
  

  List<Products> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Products> get favoriteItems {
    return _items.where((probItem) => probItem.isFavorite).toList();
  }

  Products findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts([bool filtterByUser = false]) async {
    final filterString= filtterByUser ? 'orderBy="creatorId"&equalTo="$userId"': '';
    try {
      final response = await http.get(Uri.parse(
          'https://my-shop-8c1ca-default-rtdb.firebaseio.com/product.json?auth=$authToken&$filterString'));
//      final response = await http.get(Url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final url = Uri.parse(
        'https://my-shop-8c1ca-default-rtdb.firebaseio.com/$userId.json');
      final favoriteResponse = await http.get(url);
      final favoriteData= json.decode(favoriteResponse.body);
      final List<Products> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Products(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: favoriteData[prodId],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      // ignore: use_rethrow_when_possible
      throw error;
    }
  }

  Future<void> addProduct(Products products) async {
    //const url = 'https://my-shop-8c1ca-default-rtdb.firebaseio.com/';
    try {
      final response = await http.post(
        Uri.parse(
            'https://my-shop-8c1ca-default-rtdb.firebaseio.com/product.json?auth=$authToken'),
        body: json.encode(
          {
            'title': products.title,
            'description': products.description,
            'price': products.price,
            'imageUrl': products.imageUrl,
            //'isFavorite': products.isFavorite,
            'creatorId': userId,
          },
        ),
      );

      final newProduct = Products(
          id: json.decode(response.body)['name'],
          title: products.title,
          description: products.description,
          price: products.price,
          imageUrl: products.imageUrl);
      _items.add(newProduct);
      notifyListeners();

      //print(error);
      //throw error;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Products newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final Url = await http.put(
        Uri.parse(
            'https://my-shop-8c1ca-default-rtdb.firebaseio.com/product/$id.json?auth=$authToken'),
        body: jsonEncode(<String, dynamic>{
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
          'isFavorite': newProduct.isFavorite
        }),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://my-shop-8c1ca-default-rtdb.firebaseio.com/product/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Products? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpExcaption('COuld not delete product.');
    }
    existingProduct = null;
  }
}
