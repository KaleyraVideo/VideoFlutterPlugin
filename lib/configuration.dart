// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

/// Generic configuration for the Kaleyra Video plugin
class Configuration {
  Configuration({required this.appID, required this.environment, required this.region, this.tools, this.iosConfig, this.logEnabled});

  /// This key will be provided to you by us.
  final String appID;

  /// This variable defines the environment where you will be sandbox or production.
  final Environment environment;

  /// This variable defines the region where you will be europe, india or us.
  final Region region;

  /// Set to true to enable log, default value is false
  final bool? logEnabled;

  /// Define the tools to use
  final Tools? tools;


  /// Define to customize the iOS configuration
  final IosConfiguration? iosConfig;

  /// @nodoc
  String toJson() => json.encode(toMapJson());

  /// @nodoc
  Map<String, dynamic> toMapJson() => {
        "appID": appID,
        "environment": environment.toMapJson(),
        "region": region.toMapJson(),
        "tools": tools?.toMapJson(),
        "iosConfig": iosConfig?.toMapJson(),
        "logEnabled": logEnabled,
      };
}
