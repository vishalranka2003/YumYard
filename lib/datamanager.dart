import 'dart:convert';
import 'package:flutter/material.dart';

import 'datamodel.dart';
import 'package:http/http.dart' as http;
import './pages/order_page.dart';

class DataManager {
  List<Category>? _menu;
  List<ItemInCart> cart = [];

  fetchMenu() async {
    try {
      const url = 'https://shreyadr09.github.io/Food_app_api/api/menu.json';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        _menu = [];
        var decodedData = jsonDecode(response.body) as List<dynamic>;
        for (var json in decodedData) {
          _menu?.add(Category.fromJson(json));
        }
      } else {
        throw Exception("Error loading data");
      }
    } catch (e) {
      throw Exception("Error loading data");
    }
  }

  Future<List<Category>> getMenu() async {
    if (_menu == null) {
      await fetchMenu();
    }
    return _menu!;
  }

  void cartAdd(Product p, BuildContext context) {
    bool found = false;
    for (var item in cart) {
      if (item.product.id == p.id) {
        item.quantity++;
        found = true;
      }
    }
    if (!found) {
      cart.add(ItemInCart(product: p, quantity: 1));
      showSnackbar(p.name, context);
    }
  }

  void showSnackbar(String productName, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName added to the cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  cartRemove(Product p) {
    cart.removeWhere((element) => element.product.id == p.id);
  }

  cartClear() {
    cart.clear();
  }

  double cartTotal() {
    var sum = 0.0;
    for (var item in cart) {
      sum += item.quantity * item.product.price;
    }
    return sum;
  }

  int getQuantityInCart(Product product) {
    int quantity = 0;
    for (var item in cart) {
      if (item.product.id == product.id) {
        quantity = item.quantity;
        break;
      }
    }
    return quantity;
  }
}
