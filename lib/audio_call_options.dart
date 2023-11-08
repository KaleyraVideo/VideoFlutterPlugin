// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

/// Audio call options used for chat
///
/// Defining this object will enable an option to start an audio call from chat UI
class AudioCallOptions extends CallOptions {
  AudioCallOptions({
    recordingType,
    required this.type,
  }) : super(recordingType: recordingType);

  /// Type of audioCall to launch when an option of the chat is tapped.
  AudioCallType type;

  /// @nodoc
  @override
  String toJson() => json.encode(toMapJson());

  /// @nodoc
  @override
  Map<String, dynamic> toMapJson() => {
        "recordingType": recordingType?.name,
        "type": type.name,
      };
}
