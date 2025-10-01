import 'dart:async';
import 'package:flutter/services.dart';

/// S Pen events, such as button presses and motion
class SPenEvent {
  SPenEvent({required this.type, this.action, this.dx, this.dy});

  /// Can be "button" or "motion"
  final String type;

  /// Button action code (only for "button") 0 = press, 1 = release
  final int? action;

  /// Motion delta X (only for "motion")
  final double? dx;

  /// Motion delta Y (only for "motion")
  final double? dy;

  /// Convert from a map to SPenEvent()
  factory SPenEvent.fromMap(Map<dynamic, dynamic> map) {
    return SPenEvent(
      type: map['type'] as String,
      action: map['action'] as int?,
      dx: (map['dx'] as num?)?.toDouble(),
      dy: (map['dy'] as num?)?.toDouble(),
    );
  }
}

/// A Flutter plugin to integrate with the Samsung S Pen Remote SDK
class SpenRemote {
  static const MethodChannel _method = MethodChannel('spen_remote/methods');
  static const EventChannel _events = EventChannel('spen_remote/events');

  static Future<void> connect() async => _method.invokeMethod('connect');
  static Future<void> disconnect() async => _method.invokeMethod('disconnect');

  static Stream<SPenEvent> get events => _events.receiveBroadcastStream().map(
    (e) => SPenEvent.fromMap(e as Map<dynamic, dynamic>),
  );
}
