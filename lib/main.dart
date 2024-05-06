// ignore_for_file: use_key_in_widget_constructors, unnecessary_this, prefer_const_constructors, prefer_const_literals_to_create_immutables, overridden_fields

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:men_u/login.dart';
import 'package:men_u/widgets/category.dart';
import 'package:men_u/widgets/item.dart';
import 'package:men_u/widgets/cart.dart';

void main() {
  runApp(MainApp());
}

// var url = Uri.parse('http://192.168.1.29:8000/api/test/');
// var response = await http.get(url);
// print('Response status: ${response.statusCode}');
// print('Response body: ${response.body}');

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Men-U',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: Color.fromRGBO(50, 34, 25, 1)),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> categories = [];

  final List<String> images = [
    "https://www.foodiesfeed.com/wp-content/uploads/2023/06/burger-with-melted-cheese.jpg",
    "https://www.foodiesfeed.com/wp-content/uploads/2023/06/pouring-honey-on-pancakes.jpg"
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Uri.parse('http://192.168.1.29:8000/api/test/');
    var response = await http.get(url);
    Map<String, dynamic> responseData = json.decode(response.body);
    List<dynamic> itemsData = responseData['items'];
    List<dynamic> categoriesData = responseData['categories'];
    if (response.statusCode == 200) {
      //print('Response body: ${response.body}');
      setState(() {
        items = List<Map<String, dynamic>>.from(itemsData);
        categories = List<Map<String, dynamic>>.from(categoriesData);
      });
      //print(categories);
    } else {
      print('Failed to load data \nResponse status: ${response.statusCode}');
    }
  }

  Future<void> updateItems(int menuId) async {
    var url = Uri.parse('http://192.168.1.29:8000/api/getCategories/$menuId');
    var response = await http.get(url);
    var responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      print('Category body: ${response.body}');
      setState(() {
        items = List<Map<String, dynamic>>.from(responseData);
      });
    } else {
      print('error');
    }
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            count++;
            if (count == 5) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                }),
              );
              count = 0;
            }
          },
          child: const Text(
            "Menu",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        scrolledUnderElevation: 1,
        actions: <Widget>[
          Cart(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  child: Text(
                    "Categories",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        categories.isNotEmpty ? categories.length + 1 : 1,
                    itemBuilder: (context, index) {
                      print("index category: $index");
                      if (index == 0) {
                        print("index category: $index");
                        return Category(
                          url: images[0],
                          name: "All",
                          callback: () => fetchData(),
                        );
                      } else {
                        return Category(
                          url:
                              "http://192.168.1.29:8000/storage/images/${categories[index - 1]['img']}",
                          name: categories[index - 1]['title'],
                          callback: () =>
                              updateItems(categories[index - 1]['id']),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text("Available",
                    style: Theme.of(context).textTheme.titleLarge)),
            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15),
              itemCount: items.length,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: .75,
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Item(
                  id: items[index]['id'],
                  name: items[index]["title"],
                  description: items[index]["summary"],
                  price: items[index]["price"],
                  url: items[index]['img'] != null
                      ? "http://192.168.1.29:8000/storage/images/${items[index]['img']}"
                      : "https://w7.pngwing.com/pngs/29/173/png-transparent-null-pointer-symbol-computer-icons-pi-miscellaneous-angle-trademark.png",
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
