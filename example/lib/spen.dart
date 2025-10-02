import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:spen_remote/spen_remote.dart';

class SPen {
  StreamSubscription? _eventSubscription;

  void initSPen() {
    debugPrint('Attempting to initialize S Pen...');
    SpenRemote.connect();

    _eventSubscription = SpenRemote.events.listen((event) {
      SpenRemote.events.listen(
        (event) {
          if (event.type == "button" && event.action == 0) {
            debugPrint("Button pressed!");
          } else if (event.type == "button" && event.action == 1) {
            debugPrint("Button released!");
          } else if (event.type == "motion") {
            debugPrint("dx=${event.dx}, dy=${event.dy}");
          }
        },
        onError: (error) {
          debugPrint('Error listening to S Pen events: $error');
        },
        onDone: () {
          debugPrint('S Pen event stream closed');
        },
      );
      debugPrint('S Pen initialized and listening for events.');
    });
  }

  void dispose() {
    debugPrint('Disposing SPen service...');
    _eventSubscription?.cancel();
    SpenRemote.disconnect();
    debugPrint('SPen service disposed.');
  }
}
