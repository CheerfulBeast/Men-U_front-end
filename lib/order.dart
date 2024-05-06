import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Uri.parse('http://192.168.1.29:8000/api/order/');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> ordersData = json.decode(response.body);
        setState(() {
          orders = List<Map<String, dynamic>>.from(ordersData);
        });
      } else {
        print(
            'Failed to load data \nResponse status: ${response.statusCode} \n data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cart",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: orders.isEmpty
          ? ShimmerList()
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return OrderItem(
                  index: index,
                  id: orders[index]['id'],
                  price: orders[index]['price'],
                  name: orders[index]['item']['title'],
                  url:
                      'http://192.168.1.29:8000/storage/images/${orders[index]['item']['img']}',
                  count: orders[index]['quantity'],
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: TextButton.icon(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.onTertiary),
              textStyle: MaterialStateProperty.all(
                  Theme.of(context).textTheme.titleLarge),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).buttonTheme.colorScheme?.tertiary),
              overlayColor:
                  MaterialStateProperty.all(Theme.of(context).splashColor)),
          onPressed: () async {
            //TODO:: CHANGE PARAMETER TO PROPER ORDER ID, MAKE LOGIN THEN PERSISENT LOGIN THEN TABLE SELECT THEN PASS TABLE SELECT INTO URL PARAMETER
            var response = await http.get(
                Uri.parse("http://192.168.1.29:8000/api/order/passOrder/1"));

            print(
                "Response Status Code: ${response.statusCode} \nResponse Body: ${response.body}");
          },
          icon: Icon(Icons.play_arrow_rounded),
          label: Text("Continue"),
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return ListTile(
              title: Container(
                height: 130,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          }),
    );
  }
}

class OrderItem extends StatefulWidget {
  final int id;
  final int index;
  final dynamic price;
  final dynamic name;
  int count;
  final String? url;

  OrderItem({
    super.key,
    required this.id,
    required this.index,
    required this.count,
    required this.price,
    required this.name,
    required this.url,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  Future<void> updateCount(int id, bool operation) async {
    String uri = "http://192.168.1.29:8000/api/order/$id";
    final response = await http.put(
      Uri.parse(uri),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        'operation': operation,
      }),
    );

    if (response.statusCode == 200) {
      print('Request Successful: ${response.statusCode}');
      List<dynamic> resource = jsonDecode(response.body);
      print('Response Body: $resource');

      print(resource);
      setState(() {
        //TODO:: update count state
        widget.count = resource[widget.index]['quantity'];
      });
    } else {
      print('Request Failed: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: 130,
        child: Card.outlined(
          borderOnForeground: true,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.url ??
                          "https://t3.ftcdn.net/jpg/05/62/05/20/360_F_562052065_yk3KPuruq10oyfeu5jniLTS4I2ky3bYX.jpg"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Category",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.grey.shade500),
                        ),
                        Text(
                          widget.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "PHP${widget.price}",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filledTonal(
                      visualDensity:
                          const VisualDensity(horizontal: -3, vertical: -3),
                      onPressed: () {
                        //TODO:: update count to minus one
                        updateCount(widget.id, false);
                      },
                      icon: const Icon(
                        Icons.remove_rounded,
                        size: 10,
                      ),
                    ),
                    Text('${widget.count}'),
                    IconButton.filled(
                        visualDensity:
                            const VisualDensity(horizontal: -3, vertical: -3),
                        onPressed: () {
                          //TODO:: update count to plus one
                          updateCount(widget.id, true);
                        },
                        icon: const Icon(
                          Icons.add_rounded,
                          size: 10,
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
