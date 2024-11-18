// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import 'dart:convert';

import 'flutter_native_platform_interface.dart';

part 'audio_call_options.dart';

part 'audio_call_type.dart';

part 'call_display_mode.dart';

part 'call_kit_configuration.dart';

part 'call_options.dart';

part 'call_type.dart';

part 'chat_tool_configuration.dart';

part 'configuration.dart';

part 'create_call_options.dart';

part 'environment.dart';

part 'events.dart';

part 'ios_configuration.dart';

part 'recording_type.dart';

part 'region.dart';

part 'screen_share_tool_configuration.dart';

part 'session.dart';

part 'tools.dart';

part 'user_details.dart';

part 'voip_handling_strategy.dart';

/// KaleyraVideo
abstract class KaleyraVideo {
  ///
  /// Call this method when device is ready to configure the module
  ///
  /// Throws Exception if the provided configuration is malformed, returns an instance of KaleyraVideo plugin.
  ///
  static Future<KaleyraVideo> configure(Configuration params) =>
      FlutterNativePlatformInterface.instance.configure(params);

  ///
  /// This method allows you to reset the configuration.
  ///
  static reset() => FlutterNativePlatformInterface.instance.reset();

  Events get events => FlutterNativePlatformInterface.instance.events;

  /// Connect the plugin
  ///
  /// Throws Exception if the provided session is malformed.
  ///
  connect(Session session) =>
      FlutterNativePlatformInterface.instance.connect(session);

  ///
  /// This method returns the current voip push token
  ///
  /// This function returns a Future<String?> with voipPushToken or null if has not been generated yet.
  Future<String?> getCurrentVoIPPushToken() =>
      FlutterNativePlatformInterface.instance.getCurrentVoIPPushToken();

  ///
  /// Start Call with the callee defined
  ///
  startCall(CreateCallOptions callOptions) =>
      FlutterNativePlatformInterface.instance.startCall(callOptions);

  ///
  /// Stop the plugin
  ///
  disconnect() => FlutterNativePlatformInterface.instance.disconnect();

  ///
  /// This method allows you to clear all user cached data, such as chat messages and generic information.
  ///
  clearUserCache() => FlutterNativePlatformInterface.instance.clearUserCache();

  ///
  /// Call this method to handle a notification
  ///
  /// Pass the notification payload as a JSON String
  ///
  handlePushNotificationPayload(String payload) =>
      FlutterNativePlatformInterface.instance
          .handlePushNotificationPayload(payload);

  ///
  /// Call this method to remove all the user details previously provided.
  ///
  removeUsersDetails() =>
      FlutterNativePlatformInterface.instance.removeUsersDetails();

  ///
  /// Call this method to provide the details for each user to be used to set up the UI
  ///
  addUsersDetails(List<UserDetails> userDetails) =>
      FlutterNativePlatformInterface.instance.addUsersDetails(userDetails);

  ///
  /// Set the UI display mode for the current call
  ///
  /// Possible values for [mode] param are 'background', 'foreground' and 'foregroundPictureInPicture'
  ///
  setDisplayModeForCurrentCall(CallDisplayMode mode) =>
      FlutterNativePlatformInterface.instance
          .setDisplayModeForCurrentCall(mode);

  ///
  /// Verify the user for the current call
  ///
  verifyCurrentCall(bool verify) =>
      FlutterNativePlatformInterface.instance.verifyCurrentCall(verify);

  ///
  /// Open chat
  ///
  startChat(String userID) =>
      FlutterNativePlatformInterface.instance.startChat(userID);

  ///
  /// Start Call from url
  ///
  startCallFrom(String url) =>
      FlutterNativePlatformInterface.instance.startCallFrom(url);
}
