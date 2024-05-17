import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  final String? url;
  final dynamic name;
  final VoidCallback callback;

  const Category({
    super.key,
    required this.url,
    required this.name,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      width: 108,
      child: ListTile(
        onTap: callback,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        title: Column(children: <Widget>[
          Card(
            surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      url ?? "https://w7.pngwing.com/pngs/29/173/png-transparent-null-pointer-symbol-computer-icons-pi-miscellaneous-angle-trademark.png"),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 100,
            ),
          ),
          Container(
            child: Text(
              name,
              textDirection: TextDirection.ltr,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ]),
      ),
    );
  }
}
