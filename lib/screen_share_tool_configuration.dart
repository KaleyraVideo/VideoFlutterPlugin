// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

/// Screen Share tool configuration
///
/// Set to enable the screen sharing feature
///
/// <b><font color="blue">default</font>: no screen share</b>
class ScreenShareToolConfiguration {
  ScreenShareToolConfiguration({
    this.inApp,
    this.wholeDevice,
  });

  /// Set to true to enable the in app screen share
  ///
  /// <b><font color="blue">default</font>: false</b>
  bool? inApp;

  /// Set to true to enable the whole device screen share
  ///
  /// <b><font color="blue">default</font>: false</b>
  bool? wholeDevice;

  /// @nodoc
  String toJson() => json.encode(toMapJson());

  /// @nodoc
  Map<String, dynamic> toMapJson() => {
        "inApp": inApp ?? false,
        "wholeDevice": wholeDevice ?? false,
      };
}
