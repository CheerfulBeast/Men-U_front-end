import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  double phoneHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    double height = phoneHeight(context);
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
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return OrderItem();
          }),
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
          onPressed: () {},
          icon: Icon(Icons.play_arrow_rounded),
          label: Text("Continue"),
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
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
                    child: const Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://cdn.dribbble.com/users/1376976/screenshots/19271210/media/8f64e24f47ef442d4ec27987e12110f0.png?resize=1000x750&vertical=center"),
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
                          "Name",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "PHP100",
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
                          VisualDensity(horizontal: -3, vertical: -3),
                      onPressed: () {},
                      icon: const Icon(
                        Icons.remove_rounded,
                        size: 10,
                      ),
                    ),
                    Text("$count"),
                    IconButton.filled(
                        visualDensity:
                            VisualDensity(horizontal: -3, vertical: -3),
                        onPressed: () {},
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
