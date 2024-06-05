import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:men_u/BaseApi.dart';
import 'package:men_u/Localization.dart';
import 'package:men_u/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Language extends StatelessWidget {
  LanguageActions languageAction = LanguageActions();
  dynamic languages;

  String translatedText(int index) {
    switch (index) {
      case 0:
        return '普通话';
      case 1:
        return 'Français';
      case 2:
        return 'Deutsch';
      case 3:
        return 'Español';
      case 4:
        return 'English';
      default:
        return 'No Language';
    }
  }

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
                                    translatedText(index),
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
