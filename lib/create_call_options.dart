// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

/// Options to be used when creating a call
class CreateCallOptions {
  CreateCallOptions({
    required this.callees,
    required this.callType,
    this.recordingType,
  });

  /// Array of Bandyer callees identifiers to call.
  List<String> callees;

  /// Type of call to create
  CallType callType;

  /// May have three different values, none, automatic, manual
  /// 
  /// <b><font color="blue">default</font>: none</b>
  RecordingType? recordingType;

  /// @nodoc
  String toJson() => json.encode(toMapJson());

  /// @nodoc
  Map<String, dynamic> toMapJson() => {
    "callees": List<dynamic>.from(callees.map((x) => x)),
    "callType": callType.name,
    "recordingType": recordingType?.name ?? RecordingType.none.name,
  };
}