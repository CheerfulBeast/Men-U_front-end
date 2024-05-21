// ignore_for_file: unrelated_type_equality_checks

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:men_u/Localization.dart';
import 'package:men_u/PusherClient.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:convert';

class Splashscreen extends StatefulWidget {
  final int orderId;
  final int? step;
  const Splashscreen({
    required this.orderId,
    this.step,
    super.key,
  });

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final PusherClient _pusherClient = PusherClient();
  String text = '';
  @override
  void initState() {
    super.initState();
    _pusherClient.init('order-status.${widget.orderId}');
  }

  @override
  void dispose() {
    _pusherClient.dispose();
    super.dispose();
  }

  String determineText(int? step) {
    if (step == null) {
      return LocalizedText().step1 ?? 'No Translation';
    } else if (step == 7) {
      return LocalizedText().wait ?? 'No Translation';
    } else {
      return 'wala na determine';
    }
  }

  bool checkstep(int step) {
    return step == 7;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: StreamBuilder<PusherEvent>(
          stream: _pusherClient.eventStream,
          builder: (context, snapshot) {
            text = determineText(widget.step);
            if (snapshot.hasData) {
              var event = snapshot.data!;
              log('Event data received: ${event.data}'); // Add logging

              if (event.data['status'] == 'Done') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).popUntil((route) => route.settings.name == '/');
                });
              }

              if (event.data['status'] == 'Ready to Pay') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).popAndPushNamed('/payment');
                });
              }
              if (event.data != null && event.data['step'] != null) {
                // Update the text based on the 'step' value
                switch (event.data['step']) {
                  case 1:
                    text = LocalizedText().step1 ?? 'No translation';
                    break;
                  case 2:
                    text = LocalizedText().step2 ?? 'No translation';
                    break;
                  case 3:
                    text = LocalizedText().step3 ?? 'No translation';
                    break;
                  case 4:
                    text = LocalizedText().step4 ?? 'No Translation';
                    break;
                  case 6:
                    text = LocalizedText().step6 ?? 'No Translation';
                    break;
                  case 7:
                    text = LocalizedText().step7 ?? 'No Translation';
                  // Add more cases for other steps if needed
                  default:
                    text = 'No translation';
                }
              }
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/Cooking.gif',
                    height: 250,
                    width: 250,
                  ),
                  Text(
                    text,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Visibility(
                    visible: snapshot.data?.data['step'] == 7,
                    child: FilledButton.tonal(
                        onPressed: () {
                          Navigator.of(context).popAndPushNamed('/payment');
                        },
                        child: Text(LocalizedText().ready ?? 'No Translation')),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
