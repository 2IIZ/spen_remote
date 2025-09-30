import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'spen_remote_method_channel.dart';

abstract class SpenRemotePlatform extends PlatformInterface {
  /// Constructs a SpenRemotePlatform.
  SpenRemotePlatform() : super(token: _token);

  static final Object _token = Object();

  static SpenRemotePlatform _instance = MethodChannelSpenRemote();

  /// The default instance of [SpenRemotePlatform] to use.
  ///
  /// Defaults to [MethodChannelSpenRemote].
  static SpenRemotePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SpenRemotePlatform] when
  /// they register themselves.
  static set instance(SpenRemotePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
