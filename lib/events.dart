// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

///
/// This class defines all the events that may be handled
///
/// You can listen to these events via:
/// ```dart
/// kaleyraVideoPlugin.events.onCallModuleStatusChanged = (status) => {};
/// ```
///
abstract class Events {
  
  /// @nodoc
  Events();

  ///
  /// Used to notify setup errors
  ///
  Function(String reason)? onSetupError;

  ///
  /// Used to notify call module status changed
  ///
  Function(String state)? onCallModuleStatusChanged;

  ///
  /// Used to notify call errors
  ///
  Function(String reason)? onCallError;

  ///
  /// Used to notify chat errors
  ///
  Function(String reason)? onChatError;

  ///
  /// Used to notify chat module status changed
  /// 
  Function(String state)? onChatModuleStatusChanged;

  ///
  /// Used to notify voip push token updates
  ///
  Function(String token)? oniOSVoipPushTokenUpdated;

  ///
  /// Used to notify voip push token invalidation
  ///
  Function()? oniOSVoipPushTokenInvalidated;
}
