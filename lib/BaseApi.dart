// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BaseAPI {
  static var rootUrl = "http://192.168.1.29:8000/";
  static var api = "${rootUrl}api/";

  static String? token; // Make token nullable

  // Constructor to initialize token
  BaseAPI() {
    initializeToken();
  }

  // Initialize token from SharedPreferences
  Future<void> initializeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  // Function to update headers with token
  Map<String, String> getHeaders() {
    return {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
  }

  // Routes
  var getItems = "${api}test/";
  var getCategories = "${api}getCategories/";
  var order = "${api}order/";
  var fetchOrder = "${api}getOrder/";
  var passOrder = "${api}order/passOrder/";
  var login = "${api}login/";
  var getTable = "${api}table/";
  var deleteOrder = "${api}order/";
  static var images = "${rootUrl}storage/images/";
}

class MenuActions extends BaseAPI {
  List<dynamic> itemsData = [];
  List<dynamic> categoriesData = [];
  List<dynamic> languagesData = [];
  Map<String, dynamic> userData = {};
  int? language;

  Future<http.Response> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response;
    if (language != null) {
      response = await http.get(Uri.parse('${super.getItems}$language'), headers: super.getHeaders());
    } else {
      response = await http.get(Uri.parse(super.getItems), headers: super.getHeaders());
    }

    try {
      Map<String, dynamic> responseData = json.decode(response.body);
      itemsData = responseData['items'];
      categoriesData = responseData['categories'];
      languagesData = responseData['languages'];
      userData = responseData['user'];
    } catch (e) {
      prefs.setBool('isLoggedIn', false);
      HttpException('error: $e');
    }
    return response;
  }

  Future<http.Response> updateData(int id, int? language) async {
    try {
      http.Response response = await http.get(Uri.parse("${super.getCategories}$id/$language"), headers: super.getHeaders());
      var responseData = json.decode(response.body);
      itemsData = responseData['items'];
      print('API URL: ${super.getCategories}$id');
      return response;
    } catch (e) {
      throw HttpException('Error Fetching Data: $e');
    }
  }
}

class ProductActions extends BaseAPI {
  Future<http.Response> orderProduct(int? orderId, itemId, price, quantity) async {
    try {
      http.Response response = await http.post(
        Uri.parse(super.order),
        headers: super.getHeaders(),
        body: jsonEncode(
          <String, dynamic>{
            'order_id': orderId,
            'item_id': itemId,
            'price': price,
            'quantity': quantity,
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Request Successful\nRequest Body: ${response.body}');
      } else {
        print("Error OrderProduct: ${response.statusCode}");
        print("Error body: ${response.body}");
        print("order ID: $orderId\nitem ID: $itemId \nPrice: $price\nQuantity: $quantity");
      }

      return response;
    } catch (e) {
      throw HttpException('Erorr Adding To Cart: $e');
    }
  }
}

class OrderActions extends BaseAPI {
  var statusCode = 0;
  List<dynamic> resource = [];
  List<dynamic> orders = [];
  Map<String, dynamic> language = {};

  Future<void> getOrder() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var table = prefs.getInt('table');
      var lang = prefs.getInt('language');
      http.Response response = await http.get(
        Uri.parse('${super.fetchOrder}$table/$lang'),
        headers: super.getHeaders(),
      );

      // orders = response.statusCode == 200 ? jsonDecode(response.body) : [];
      var responseData = jsonDecode(response.body);

      orders = responseData['orders'] ?? [];
      language = responseData['language'] ?? [];
    } on Exception catch (e) {
      // TODO
      throw HttpException('Error while fetching Data: $e');
    }
  }

  Future<List<dynamic>> updateCount(int id, bool operation) async {
    try {
      http.Response response = await http.put(Uri.parse('${super.order}$id'),
          headers: super.getHeaders(),
          body: jsonEncode(<String, dynamic>{
            'operation': operation,
          }));
      statusCode = response.statusCode;
      if (statusCode == 200) {
        resource = jsonDecode(response.body);
        print('Update count success\nResponse Body: ${response.body}');
      } else {
        print('Status Code: $statusCode\nResponse Body: ${response.body}');
      }
      return resource;
    } catch (e) {
      throw HttpException('Error updating order: $e\nStatus Code: $statusCode');
    }
  }

  Future<http.Response> orderDestroy(int id) async {
    http.Response response = await http.delete(Uri.parse('${super.deleteOrder}$id'), headers: super.getHeaders());

    if (response.statusCode == 200) {
      print('Deleted order');
    } else {
      print('Status Code: $statusCode\nResponse Body: ${response.body}');
    }
    return response;
  }
}

class LoginActions extends BaseAPI {
  late bool status;
  late String message;
  late String token;
  dynamic emailError;
  dynamic passwordError;
  // late Map<String, dynamic> errors;

  bool hasEmailError() {
    //return emailError != null;
    if (emailError == null) {
      return false;
    } else {
      return true;
    }
  }

  bool hasPasswordError() {
    if (emailError == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<http.Response> loginUser(String email, password) async {
    try {
      http.Response response = await http.post(
        Uri.parse(super.login),
        headers: super.getHeaders(),
        body: jsonEncode(<String, dynamic>{'email': email, 'password': password}),
      );

      Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        token = data['token'];
        print('');
        //sharedpreferences login token and logged in boolean status
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString('token', token);
      } else {
        if (data.containsKey('errors')) {
          Map<String, dynamic> errors = data['errors'];
          if (errors.containsKey('email')) {
            emailError = errors['email'].toString();
          }

          if (errors.containsKey('password')) {
            passwordError = errors['password'].toString();
          }
        } else {
          passwordError = null;
          emailError = null;
        }
      }

      status = data['status'];
      message = data['message'];

      return response;
    } catch (e) {
      throw HttpException("Error Message: $e");
    }
  }
}

class TableActions extends BaseAPI {
  List<dynamic> body = [];

  Future<void> getTables() async {
    http.Response response = await http.get(Uri.parse(super.getTable), headers: super.getHeaders());
    body = jsonDecode(response.body);
    print('BaseAPI class print output: $body');
  }

  Future<http.Response> confirmOrder(int? id) async {
    try {
      http.Response response = await http.get(
        Uri.parse('${super.passOrder}$id'),
        headers: super.getHeaders(),
      );

      // var body = jsonDecode(response.body);
      print('Confirmed Order: ${response.body}');

      return response;
    } catch (e) {
      throw HttpException('No Table Id Found || $e');
    }
  }
}
