import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'spen_remote_platform_interface.dart';

/// An implementation of [SpenRemotePlatform] that uses method channels.
class MethodChannelSpenRemote extends SpenRemotePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('spen_remote');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
