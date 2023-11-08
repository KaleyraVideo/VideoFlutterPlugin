// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

/// Configuration for iOS platform
///
/// Define to customize the iOS configuration
class IosConfiguration {
  IosConfiguration({
    this.callkit,
    this.voipHandlingStrategy,
  });

  /// Specify the callkit configuration to enable the usage and it's behaviour
  ///
  /// <b><font color="blue">default</font>: enabled</b>
  CallKitConfiguration? callkit;

  /// Specify the voip handling strategy.
  ///
  /// This allows you to disable or leave the plugin behaviour for handling the voip
  /// notifications.
  ///
  /// <b><font color="blue">default</font>: VoipHandlingStrategy.automatic </b>
  VoipHandlingStrategy? voipHandlingStrategy;

  /// @nodoc
  String toJson() => json.encode(toMapJson());

  /// @nodoc
  Map<String, dynamic> toMapJson() => {
        "callkit": callkit?.toMapJson(),
        "voipHandlingStrategy": voipHandlingStrategy?.name,
      };
}
