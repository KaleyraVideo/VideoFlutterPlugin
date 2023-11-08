// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

/// Configuration for callkit
///
/// Specify the callkit configuration to enable the usage and it's behaviour
///
/// <b><font color="blue">default</font>: enabled</b>
class CallKitConfiguration {
  CallKitConfiguration({
    this.appIconName,
    this.enabled,
    this.ringtoneSoundName,
  });

  /// The icon resource name to be used in the callkit UI to represent the app
  ///
  /// <b><font color="blue">default</font>: null</b>
  String? appIconName;

  /// Set to false to disable
  ///
  /// <b><font color="blue">default</font>: true</b>
  bool? enabled;

  /// The ringtone resource name to be used when callkit is launched
  ///
  /// <b><font color="blue">default</font>: system</b>
  String? ringtoneSoundName;

  /// @nodoc
  String toJson() => json.encode(toMapJson());

  /// @nodoc
  Map<String, dynamic> toMapJson() => {
        "appIconName": appIconName,
        "enabled": enabled,
        "ringtoneSoundName": ringtoneSoundName,
      };
}
