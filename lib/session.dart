// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

/// Session
class Session {
  Session(this.userId, this.accessTokenProvider);

  // ignore: unused_element
  Session._({
    required this.userId,
  });

  /// The user id you want to connect
  String userId;

  /// The accessTokenProvider
  Future<String> Function(String) accessTokenProvider = (userId) async {
    return "";
  };

  /// @nodoc
  String toJson() => json.encode(toMapJson());

  /// @nodoc
  Map<String, dynamic> toMapJson() => {
        "userID": userId,
      };
}
