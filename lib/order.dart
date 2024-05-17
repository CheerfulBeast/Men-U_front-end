// ignore_for_file: must_be_immutable, avoid_print
import 'package:flutter/material.dart';
import 'package:men_u/BaseApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  List<dynamic> orders = [];
  Map<String, dynamic> lang = {};
  int? language = 0;

  OrderActions orderActions = OrderActions();

  @override
  void initState() {
    super.initState();
    fetchData();
    print('Orders: {$orders}');
  }

  Future<void> fetchData() async {
    await orderActions.getOrder();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var prefsLang = prefs.getInt('language');
    setState(() {
      orders = orderActions.orders;
      language = prefsLang;
    });
    lang = orderActions.language;
  }

  void updateOrderItemCount(int index, bool operation) async {
    var resource = await orderActions.updateCount(orders[index]['id'], operation);

    if (operation == false && orders[index]['quantity'] == 1) {
      if (!mounted) return;
      setState(() {
        if (index >= 0 && index < orders.length) {
          orders.removeAt(index); // Remove the order item from the list
        }
      });
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order item removed'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    if (orderActions.statusCode == 200) {
      if (resource.isNotEmpty) {
        setState(() {
          if (index >= 0 && index < orders.length) {
            orders[index]['quantity'] = resource[index]['quantity'];
            orders[index]['price'] = resource[index]['price'];
          }
        });
      } else {
        // If the resource is empty, remove the order item from the list
        setState(() {
          if (index >= 0 && index < orders.length) {
            orders.removeAt(index);
          }
        });
      }
    } else {
      // If there's an error, trigger a rebuild
      setState(() {});
    }
  }

  num grandtotal() {
    late num grandtotal = 0; // Initialize grandtotal to zero
    for (var order in orders) {
      grandtotal += order['price'];
    }
    return grandtotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cart",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: orders.isEmpty
          ? const ShimmerList()
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                if (order['quantity'] == 0) {
                  // Return an empty widget when count is zero
                  return SizedBox.shrink();
                }
                return OrderItem(
                  index: index,
                  id: order['id'],
                  price: order['price'],
                  name: order['item']['title'],
                  url: '${BaseAPI.images}${order['item']['img']}',
                  count: order['quantity'],
                  currency: lang['currency'],
                  updateCount: (operation) => updateOrderItemCount(index, operation),
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        height: 100,
        child: Expanded(
          child: Column(children: [
            Text(
              'Grand Total: ${grandtotal()}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton.icon(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onTertiary),
                  textStyle: MaterialStateProperty.all(Theme.of(context).textTheme.titleLarge),
                  backgroundColor: MaterialStateProperty.all(Theme.of(context).buttonTheme.colorScheme?.tertiary),
                  overlayColor: MaterialStateProperty.all(Theme.of(context).splashColor)),
              onPressed: () async {
                //TODO:: CHANGE PARAMETER TO PROPER ORDER ID, MAKE LOGIN THEN PERSISENT LOGIN THEN TABLE SELECT THEN PASS TABLE SELECT INTO URL PARAMETER
                TableActions tableActions = TableActions();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                int? tableId = prefs.getInt('table');
                tableActions.confirmOrder(tableId);
                print('token: ${prefs.getString('token')}');
                if (!context.mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order item removed'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text("Continue"),
            ),
          ]),
        ),
      ),
    );
  }
}

class OrderItem extends StatefulWidget {
  final int id;
  final int index;
  dynamic price;
  final dynamic name;
  int count;
  final String? url;
  final String currency;
  final void Function(bool operation) updateCount; // Callback function to update count

  OrderItem({
    Key? key,
    required this.id,
    required this.index,
    required this.count,
    required this.price,
    required this.name,
    required this.url,
    required this.currency,
    required this.updateCount, // Include the callback function in the constructor
  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var orderAction = OrderActions();

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
                      image: NetworkImage(widget.url ?? "https://t3.ftcdn.net/jpg/05/62/05/20/360_F_562052065_yk3KPuruq10oyfeu5jniLTS4I2ky3bYX.jpg"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          widget.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "${widget.currency}${widget.price}",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filledTonal(
                      visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                      onPressed: () {
                        setState(() {
                          widget.updateCount(false);
                        });
                      },
                      icon: const Icon(
                        Icons.remove_rounded,
                        size: 10,
                      ),
                    ),
                    Text('${widget.count}'),
                    IconButton.filled(
                        visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                        onPressed: () {
                          setState(() {
                            widget.updateCount(true);
                          });
                        },
                        icon: const Icon(
                          Icons.add_rounded,
                          size: 10,
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

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
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              ),
            );
          }),
    );
  }
}
