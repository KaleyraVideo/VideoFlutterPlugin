// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

// import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_native_platform_interface.dart';
import 'kaleyra_video_flutter_plugin.dart';
import 'channel_events.dart';

/// An implementation of [FlutterNativePlatformInterface] that uses method channels.
/// 
/// @nodoc
class FlutterNativeChannel extends FlutterNativePlatformInterface {

  @override
  ChannelEvents get events => _channelEvents;

  @visibleForTesting
  static const dartChannel = MethodChannel('kaleyra_dart_channel');

  @visibleForTesting
  static const MethodChannel nativeChannel = MethodChannel('kaleyra_native_channel');

  final _channelEvents = ChannelEvents(channel: dartChannel);

  static KaleyraVideo? instance;

  @override
  Future<KaleyraVideo> configure(Configuration configuration) async {
    if (configuration.appID == "") {
      throw Exception("Expected a not empty appId!");
    }

    if (instance != null) {
      return instance!;
    }

    await nativeChannel.invokeMethod('configureBridge', configuration.toJson()).whenComplete(() => instance = FlutterNativeChannel());
    return instance!;
  }

  @override
  void connect(Session session) {
    if (session.userId == "") throw Exception("Expected a not empty userId!");
    _channelEvents.accessTokenRequest = (String userId) => session.accessTokenProvider(userId);
    nativeChannel.invokeMethod('connect', session.userId);
  }

  @override
  Future<String?> getCurrentVoIPPushToken() {
    if (Platform.isIOS) {
      return nativeChannel.invokeMethod("getCurrentVoIPPushToken");
    } else {
      return Future.error("getCurrentVoIPPushToken() not implemented on this platform");
    }
  } 

  @override
  void reset() => nativeChannel.invokeMethod("reset");

  @override
  void startCall(CreateCallOptions callOptions) => nativeChannel.invokeMethod("startCall", callOptions.toJson());

  @override
  void startChat(String userID) => nativeChannel.invokeMethod("startChat", userID);

  @override
  void startCallFrom(String url) => nativeChannel.invokeMethod("startCallUrl", jsonEncode(url));

  @override
  void disconnect() => nativeChannel.invokeMethod("disconnect");

  @override
  void clearUserCache() => nativeChannel.invokeMethod("clearUserCache");

  @override
  void handlePushNotificationPayload(String payload) => nativeChannel.invokeMethod("handlePushNotificationPayload", jsonEncode(payload));

  @override
  void removeUsersDetails() => nativeChannel.invokeMethod("removeUsersDetails");

  @override
  void addUsersDetails(List<UserDetails> userDetails) => nativeChannel.invokeMethod("addUsersDetails", List<dynamic>.from(userDetails.map((x) => x.toJson())));

  @override
  void setUserDetailsFormat(UserDetailsFormat format) => nativeChannel.invokeMethod("setUserDetailsFormat", format.toJson());

  @override
  void setDisplayModeForCurrentCall(CallDisplayMode mode) => nativeChannel.invokeMethod("setDisplayModeForCurrentCall", mode.name);

  @override
  void verifyCurrentCall(bool verify) => nativeChannel.invokeMethod("verifyCurrentCall", verify);
}
