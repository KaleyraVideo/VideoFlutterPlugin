// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

part of 'kaleyra_video_flutter_plugin.dart';

/// This is used by Kaleyra Video to define the user details in the call/chat UI
class UserDetails {
  UserDetails({
    required this.userID,
    this.nickName,
    this.firstName,
    this.lastName,
    this.email,
    this.profileImageUrl,
  });

  /// Kaleyra Video user identifier
  String userID;

  /// Nickname for the user
  String? nickName;

  /// First name of the user
  String? firstName;

  /// Last name of the user
  String? lastName;

  /// Email of the user
  String? email;

  /// Image url to use as placeholder for the user.
  String? profileImageUrl;

  /// @nodoc
  String toJson() => json.encode(toMapJson());

  /// @nodoc
  Map<String, dynamic> toMapJson() => {
    "userID": userID,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "nickName": nickName,
    "profileImageURL": profileImageUrl,
  };
}