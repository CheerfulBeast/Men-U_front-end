import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:men_u/BaseApi.dart';
import 'package:men_u/Localization.dart';
import 'package:men_u/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Language extends StatelessWidget {
  LanguageActions languageAction = LanguageActions();
  dynamic languages;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: languageAction.getLanguages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(LocalizedText().chooseLanguage ?? 'No Translation'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(LocalizedText().chooseLanguage ?? 'No Translation'),
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(LocalizedText().chooseLanguage ?? 'No Translation'),
              ),
              body: languageAction.languages.isNotEmpty
                  ? ListView.builder(
                      itemCount: languageAction.languages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.all(30),
                            child: FilledButton(
                                onPressed: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setInt('language', languageAction.languages[index]['id']);
                                  LocalizedText textTranslation = LocalizedText();
                                  textTranslation.translate(prefs.getInt('language') ?? 5);
                                  if (!context.mounted) return;
                                  Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                                    return const MyHomePage();
                                  })));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    '${languageAction.languages[index]['language']}',
                                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),
                                  ),
                                )));
                      },
                    )
                  : const Text('No data'));
        }
      },
    );
  }
}
