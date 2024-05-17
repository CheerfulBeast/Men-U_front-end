import "package:flutter/material.dart";
import "package:men_u/BaseApi.dart";
import "package:men_u/login.dart";
import "package:shared_preferences/shared_preferences.dart";

class TablePick extends StatelessWidget {
  TablePick({super.key});

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.setString('token', '');
  }

  TableActions tableActions = TableActions();

  Future<void> tables() async {
    await tableActions.getTables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Pick a table'),
          actions: [
            IconButton(
                onPressed: () {
                  logout();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }));
                },
                icon: const Icon(Icons.logout_rounded))
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed('/home');
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: FutureBuilder(
            future: tables(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (tableActions.body.isNotEmpty) {
                print('body: ${tableActions.body}');
                return ListView.builder(
                    itemCount: tableActions.body.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Table ${tableActions.body[index]['id']}'),
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setInt('table', tableActions.body[index]['id']);
                          Navigator.of(context).popUntil(
                            (route) {
                              return route.settings.name == '/';
                            },
                          );
                          print('prefs table id: ${prefs.getInt('table')}');
                        },
                      );
                    });
              } else {
                print(tableActions.body);
                return const Center(
                  child: Text('No tables is set'),
                );
              }
            }));
  }
}
