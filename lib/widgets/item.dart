// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import "package:flutter/material.dart";
import "package:men_u/payment.dart";
import "package:men_u/product.dart";

class Item extends StatelessWidget {
  final String? url;
  final dynamic id;
  final dynamic name;
  final dynamic description;
  final dynamic price;
  final dynamic currency;
  final List<dynamic> allergens;

  const Item(
      {super.key,
      this.url,
      required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.currency,
      required this.allergens});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Product(
                id: id,
                name: name,
                description: description ?? "",
                price: price,
                url: url,
                allergens: allergens,
                currency: currency,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Hero(
              tag: 'tag-$id',
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(
                        url ?? "https://w7.pngwing.com/pngs/29/173/png-transparent-null-pointer-symbol-computer-icons-pi-miscellaneous-angle-trademark.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    name.toString(),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            // SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$currency$price",
                    overflow: TextOverflow.clip,
                  ),
                  SizedBox.square(
                    dimension: 30,
                    // child: IconButton.filledTonal(
                    //   padding: EdgeInsets.all(0),
                    //   onPressed: () {
                    //     //TODO:: Ordering Store API CALL only add 1
                    //     Navigator.of(context).push(MaterialPageRoute(builder: (contexdt) {
                    //       return Receipt();
                    //     }));
                    //   },
                    //   icon: Icon(Icons.add_rounded),
                    // ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
