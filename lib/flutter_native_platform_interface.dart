// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'flutter_native_channel.dart';
import 'kaleyra_video_flutter_plugin.dart';

///
/// @nodoc
///
abstract class FlutterNativePlatformInterface extends PlatformInterface with KaleyraVideo {

  /// Constructs a FlutterNativePlatformInterface.
  FlutterNativePlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static FlutterNativePlatformInterface _instance = FlutterNativeChannel();

  /// The default instance of [FlutterNativePlatformInterface] to use.
  ///
  /// Defaults to [FlutterNativeChannel].
  static FlutterNativePlatformInterface get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterNativePlatformInterface] when
  /// they register themselves.
  static set instance(FlutterNativePlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<KaleyraVideo> configure(Configuration configuration);

  void reset();
}
