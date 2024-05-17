// ignore_for_file: use_key_in_widget_constructors, unnecessary_this, prefer_const_constructors, prefer_const_literals_to_create_immutables, overridden_fields
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:men_u/BaseApi.dart';
import 'package:men_u/login.dart';
import 'package:men_u/table.dart';
import 'package:men_u/widgets/category.dart';
import 'package:men_u/widgets/item.dart';
import 'package:men_u/widgets/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is resolving, you can show a loading indicator
          return CircularProgressIndicator();
        } else {
          // Once the future is resolved, determine the home screen based on the result
          bool isLoggedIn = snapshot.data ?? false;
          return MaterialApp(
            title: 'Men-U',
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(brightness: Brightness.light, seedColor: Color.fromRGBO(50, 34, 25, 1)),
            ),
            home: MyHomePage(),
            routes: {
              '/home': (context) => MyHomePage(),
            },
          );
        }
      },
    );
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
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
  List<Map<String, dynamic>> languages = [];
  Map<String, dynamic> user = {};
  late int language = user['language'];
  //api action instance class
  var menuActions = MenuActions();

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
    var response = await menuActions.getData();
    if (response.statusCode == 200) {
      setState(() {
        items = List<Map<String, dynamic>>.from(menuActions.itemsData);
        categories = List<Map<String, dynamic>>.from(menuActions.categoriesData);
        languages = List<Map<String, dynamic>>.from(menuActions.languagesData);
        user = Map<String, dynamic>.from(menuActions.userData);
      });
      //print(categories);
    } else {
      print('Failed to load data \nResponse status: ${response.statusCode}');
    }
  }

  Future<void> updateItems(int menuId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var language = prefs.getInt('language');
    print('==============language================\n$language ');
    var response = await menuActions.updateData(menuId, language);
    if (response.statusCode == 200) {
      print('Category body: ${response.body}');
      setState(() {
        items = List<Map<String, dynamic>>.from(menuActions.itemsData);
      });
      if (items.isNotEmpty) {
        print('Item: ${items[0]['title']}\nallergens:\n${items[0]['allergens']}');
      }
    } else {
      print('error');
    }
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 50,
        child: Column(
          children: [
            DrawerHeader(child: Text('Choose a language')),
            Expanded(
              child: ListView.builder(
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    title: Text(languages[index]['language']),
                    onTap: () async {
                      setState(() {
                        language = menuActions.language = languages[index]['id'];
                        // language = languages[index]['id'];
                        fetchData();
                      });
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setInt('language', languages[index]['id']);
                      print('language id: $language');
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.language_rounded));
        }),
        title: GestureDetector(
          onTap: () async {
            count++;
            final String? token;
            if (count == 5) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
              token = prefs.getString('token');

              if (!context.mounted) return;
              if (isLoggedIn) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return TablePick();
                }));
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return LoginScreen();
                }));
              }
              count = 0;
            } else {
              token = 'no token';
            }
            print('Token: $token');
            print('Count: $count');
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
                    itemCount: categories.isNotEmpty ? categories.length + 1 : 1,
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
                          url: "${BaseAPI.images}${categories[index - 1]['img']}",
                          name: categories[index - 1]['title'],
                          callback: () => updateItems(categories[index - 1]['id']),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            Container(
                width: double.infinity, margin: EdgeInsets.symmetric(horizontal: 15), child: Text("Available", style: Theme.of(context).textTheme.titleLarge)),
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
                //TODO: Add prefs langauge
                return Item(
                  id: items[index]['id'],
                  allergens: items[index]['allergens'] ?? [],
                  name: items[index]["title"],
                  description: items[index]["summary"],
                  price: items[index]["price"],
                  currency: languages[language - 1 ?? user['language']]['currency'],
                  url: items[index]['img'] != null
                      ? "${BaseAPI.images}${items[index]['img']}"
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
