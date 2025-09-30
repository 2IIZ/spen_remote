import 'dart:async';
import 'package:flutter/services.dart';

class SPenEvent {
  final String type;
  final int? action;
  final double? dx;
  final double? dy;

  SPenEvent({required this.type, this.action, this.dx, this.dy});

  factory SPenEvent.fromMap(Map<dynamic, dynamic> map) {
    return SPenEvent(
      type: map['type'] as String,
      action: map['action'] as int?,
      dx: (map['dx'] as num?)?.toDouble(),
      dy: (map['dy'] as num?)?.toDouble(),
    );
  }
}

class SpenRemote {
  static const MethodChannel _method = MethodChannel('spen_remote/methods');
  static const EventChannel _events = EventChannel('spen_remote/events');

  static Future<void> connect() async => _method.invokeMethod('connect');
  static Future<void> disconnect() async => _method.invokeMethod('disconnect');

  static Stream<SPenEvent> get events => _events.receiveBroadcastStream().map(
    (e) => SPenEvent.fromMap(e as Map<dynamic, dynamic>),
  );
}
