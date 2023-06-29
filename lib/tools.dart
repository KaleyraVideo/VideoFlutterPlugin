// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

///
/// Define the tools to use
/// 
class Tools {
  Tools({
    this.chat,
    this.feedback,
    this.fileShare,
    this.screenShare,
    this.whiteboard,
  });

  /// Set to enable the chat feature
  /// 
  /// <b><font color="blue">default</font>: no chat</b>
  ///
  ChatToolConfiguration? chat;

  /// Set to true to enable the feedback request after a call ends.
  /// 
  /// <b><font color="blue">default</font>: false</b>
  bool? feedback = false;

  /// Set to true to enable the file sharing feature
  /// 
  /// <b><font color="blue">default</font>: false</b>
  bool? fileShare = false;

  /// Set to enable the screen sharing feature
  /// 
  /// <b><font color="blue">default</font>: no screen share</b>
  ScreenShareToolConfiguration? screenShare;

  /// Set to true to enable the whiteboard feature
  /// 
  /// <b><font color="blue">default</font>: false</b>
  bool? whiteboard = false;

  /// @nodoc
  String toJson() => json.encode(toMapJson());

  /// @nodoc
  Map<String, dynamic> toMapJson() => {
        "chat": chat?.toMapJson(),
        "feedback": feedback ?? false,
        "fileShare": fileShare ?? false,
        "screenShare": screenShare?.toMapJson(),
        "whiteboard": whiteboard ?? false,
      };
}
