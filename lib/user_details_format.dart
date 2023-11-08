// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

/// This is used by Kaleyra Video to display the user details in the call/chat UI
class UserDetailsFormat {
  UserDetailsFormat({
    this.androidNotification,
    required this.userDetailsFormatDefault,
  });

  /// Format to be used when displaying an android notification
  ///
  /// <b><font color="blue">default</font>: equals to UserDetailsFormatter.default</b>
  String? androidNotification;

  /// Format to be used to display a user details on the call/chat UI
  ///
  /// <b><font color="blue">default</font>: ${userAlias}</b>
  String userDetailsFormatDefault;

  /// @nodoc
  String toJson() => json.encode(_toMapJson());

  /// @nodoc
  Map<String, dynamic> _toMapJson() => {
        "default": userDetailsFormatDefault,
        "androidNotification": androidNotification ?? userDetailsFormatDefault,
      };
}
