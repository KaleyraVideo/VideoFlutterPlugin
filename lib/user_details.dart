// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

/// This is used by Kaleyra Video to define the user details in the call/chat UI
class UserDetails {
  UserDetails({
    required this.userID,
    this.name,
    this.imageUrl,
  });

  /// Kaleyra Video user identifier
  String userID;

  /// The user's display name.
  String? name;

  /// Image url to use as placeholder for the user.
  String? imageUrl;

  /// @nodoc
  String toJson() => json.encode(toMapJson());

  /// @nodoc
  Map<String, dynamic> toMapJson() => {
        "userID": userID,
        "name": name,
        "imageUrl": imageUrl,
      };
}
