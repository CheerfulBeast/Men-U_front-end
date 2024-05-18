import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherClient {
  final String apiKey = '6748b396c23952cf9fca';
  final String cluster = 'ap1';
  PusherChannelsFlutter? _pusher;
  final StreamController<PusherEvent> _eventController = StreamController<PusherEvent>.broadcast();

  Stream<PusherEvent> get eventStream => _eventController.stream;

  Future<void> init(String channelName) async {
    _pusher = PusherChannelsFlutter.getInstance();
    try {
      await _pusher!.init(
        apiKey: apiKey,
        cluster: cluster,
        onEvent: (event) {
          log('Pusher event received: ${event.data}');
          log('api key: $apiKey\ncluster: $cluster'); // Add logging for debugging

          // Parse event data if it's a JSON string
          if (event.data is String) {
            try {
              final parsedData = json.decode(event.data);
              event.data = parsedData;
            } catch (e) {
              log('Failed to parse event data: $e');
            }
          }

          _eventController.add(event);
        },
      );
      await _pusher!.subscribe(channelName: channelName);
      await _pusher!.connect();
    } catch (e) {
      print('Error initializing Pusher: $e');
    }
  }

  void dispose() {
    _eventController.close();
    _pusher?.disconnect();
  }
}
