// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import 'package:flutter/services.dart';
import 'kaleyra_video_flutter_plugin.dart';

///
/// @nodoc
///
class ChannelEvents extends Events {
  final MethodChannel channel;

  Future<String> Function(String userId)? accessTokenRequest;

  ChannelEvents({required this.channel}) {
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "accessTokenRequest":
          return await accessTokenRequest?.call(call.arguments);
        case "setupError":
          return onSetupError?.call(call.arguments);
        case "callModuleStatusChanged":
          return onCallModuleStatusChanged?.call(call.arguments);
        case "callError":
          return onCallError?.call(call.arguments);
        case "chatError":
          return onChatError?.call(call.arguments);
        case "chatModuleStatusChanged":
          return onChatModuleStatusChanged?.call(call.arguments);
        case "iOSVoipPushTokenUpdated":
          return oniOSVoipPushTokenUpdated?.call(call.arguments);
        case "iOSVoipPushTokenInvalidated":
          return oniOSVoipPushTokenInvalidated?.call();
      }
    });
  }
}
