import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:men_u/BaseApi.dart';
import 'package:men_u/Localization.dart';
import 'package:men_u/widgets/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Product extends StatefulWidget {
  final String? url;
  final int id;
  final String name;
  final String description;
  final int price;
  final dynamic currency;
  final List<dynamic> allergens;

  const Product(
      {super.key,
      required this.allergens,
      this.url,
      required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.currency});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  int table = 1;
  var productActions = ProductActions();

  String getImageUrl() {
    return widget.url ?? "tae";
    //"https://media.istockphoto.com/id/1342278794/vector/error-icon-in-the-form-of-pixel-graphics-error-means-that-this-site-is-unavailable-cant-be.jpg?s=612x612&w=0&k=20&c=OAAYswfa8cZ2WfiCKDKRO2MHNkfGAJ4QWVYt2SoRA6k=";
  }

  int count = 1;

  int getPrice() {
    int price = widget.price;
    return price;
  }

  int calculatePrice() {
    int price = widget.price;
    if (count == 0) {
      return price;
    } else {
      return price * count;
    }
  }

  Widget allergenCheck(List<dynamic> list) {
    var iniPrice = getPrice();
    if (list.isNotEmpty) {
      return SizedBox(
        height: 30, // Specify a fixed height or use Expanded to take up remaining space
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: list.length + 1,
          itemBuilder: ((context, index) {
            if (index == 0) {
              return Card.filled(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "${widget.currency}$iniPrice",
                  ),
                ),
              );
            } else {
              return Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "${widget.allergens[index - 1]['allergen']}",
                  ),
                ),
              );
            }
          }),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Card.filled(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "${widget.currency}$iniPrice",
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String image = getImageUrl();
    String name = widget.name;
    String description = widget.description;
    int price = calculatePrice();
    int iniPrice = getPrice();
    int id = widget.id;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: const <Widget>[Cart()],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Material(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () async {
                    try {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      int? orderId = prefs.getInt('table');
                      if (orderId != null) {
                        await productActions.orderProduct(orderId, id, price, count);
                      } else {
                        print('No table set');
                      }
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    } catch (e) {
                      print("Error: $e");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SizedBox(
                      height: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.currency}$price",
                            style:
                                Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            LocalizedText().addtocart ?? 'No Translation',
                            style:
                                Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$count'),
              ),
            ),
            Card(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(
                        () {
                          if (count != 1) {
                            count -= 1;
                          }
                          print(count);
                        },
                      );
                    },
                    icon: const Icon(Icons.remove_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(
                        () {
                          count += 1;
                          print(count);
                        },
                      );
                    },
                    icon: const Icon(Icons.add_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  Hero(
                    tag: 'tag-${widget.id}',
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      name,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  allergenCheck(widget.allergens),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Description",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
