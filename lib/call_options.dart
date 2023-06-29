// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

/// Options available for a call
///
/// Defining this object will enable an option to start an audio&video call from chat UI
class CallOptions {
  CallOptions({
    this.recordingType,
  });

  /// May have three different values, none, automatic, manual
  /// 
  /// <b><font color="blue">default</font>: none</b>
  RecordingType? recordingType;

  /// @nodoc
  String toJson() => json.encode(toMapJson());

  /// @nodoc
  Map<String, dynamic> toMapJson() => {
    "recordingType": recordingType?.name,
  };
}