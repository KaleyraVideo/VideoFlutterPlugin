// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

/// Chat tool configuration
///
/// Set to enable the chat feature
///
/// <b><font color="blue">default</font>: no chat</b>
class ChatToolConfiguration {
  ChatToolConfiguration({
    this.audioCallOption,
    this.videoCallOption,
  });

  /// Defining this object will enable an option to start an audio call from chat UI
  AudioCallOptions? audioCallOption;

  /// Defining this object will enable an option to start an audio&video call from chat UI
  CallOptions? videoCallOption;

  String toJson() => json.encode(toMapJson());

  Map<String, dynamic> toMapJson() => {
        "audioCallOption": audioCallOption?.toMapJson(),
        "videoCallOption": videoCallOption?.toMapJson(),
      };
}
