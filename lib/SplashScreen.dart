import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:men_u/PusherClient.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:convert';

class Splashscreen extends StatefulWidget {
  final int orderId;
  const Splashscreen({required this.orderId, super.key});

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final PusherClient _pusherClient = PusherClient();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: StreamBuilder<PusherEvent>(
          stream: _pusherClient.eventStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final event = snapshot.data!;
              log('Event data received: ${event.data}'); // Add logging

              if (event.data['status'] == 'Done') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).popAndPushNamed('/home');
                });
              }
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Cooking.gif',
                  height: 250,
                  width: 250,
                ),
                Text(
                  "Your Order Is Cooking...",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
