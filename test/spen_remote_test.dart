import 'package:flutter_test/flutter_test.dart';
import 'package:spen_remote/spen_remote_platform_interface.dart';
import 'package:spen_remote/spen_remote_method_channel.dart';

void main() {
  final SpenRemotePlatform initialPlatform = SpenRemotePlatform.instance;

  test('$MethodChannelSpenRemote is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSpenRemote>());
  });
}
