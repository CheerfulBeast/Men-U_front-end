import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:men_u/BaseApi.dart';
import 'package:men_u/Localization.dart';
import 'package:men_u/SplashScreen.dart';
import 'package:men_u/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Receipt extends StatefulWidget {
  const Receipt({super.key});

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  List<dynamic> orders = [];

  OrderActions orderActions = OrderActions();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: orderActions.getOrder(),
      builder: (context, snapshot) {
        orders = orderActions.orders;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(LocalizedText().receipt ?? 'No Translation'),
            ),
            body: const ShimmerList(),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(LocalizedText().receipt ?? 'No Translation'),
            ),
            body: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(LocalizedText().receipt ?? 'No Translation'),
            ),
            body: orders.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      return PurchaseItem(
                        id: orders[index]['id'],
                        index: index,
                        count: orders[index]['quantity'],
                        price: orders[index]['price'],
                        name: orders[index]['item']['title'],
                        url: '${BaseAPI.images}${orders[index]['item']['img']}',
                        currency: orderActions.language['currency'],
                      );
                    },
                    itemCount: orders.length,
                  )
                : const Text('Receipt is empty'),
            bottomNavigationBar: BottomAppBar(
              elevation: 0,
              height: 150,
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        '${LocalizedText().grandTotal}: ${orderActions.grandtotal}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    FilledButton(
                        style: const ButtonStyle(visualDensity: VisualDensity(vertical: 4, horizontal: -4)),
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          var table = prefs.getInt('table');
                          TableActions().payStatus(table);
                          if (!context.mounted) return;
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return Splashscreen(
                              orderId: table ?? 0,
                              step: 7,
                            );
                          }));
                        },
                        child: Text(
                          LocalizedText().ready ?? 'No Translation',
                          style:
                              Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
                        ))
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class PurchaseItem extends StatelessWidget {
  final int id;
  final int index;
  dynamic price;
  final dynamic name;
  int count;
  final String? url;
  final String currency; // Callback function to update count

  PurchaseItem({
    super.key,
    required this.id,
    required this.index,
    required this.count,
    required this.price,
    required this.name,
    required this.url,
    required this.currency, // Include the callback function in the constructor
  });

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
                      image: NetworkImage(url ?? "https://t3.ftcdn.net/jpg/05/62/05/20/360_F_562052065_yk3KPuruq10oyfeu5jniLTS4I2ky3bYX.jpg"),
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
                          name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "$currency$price",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'x$count',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
