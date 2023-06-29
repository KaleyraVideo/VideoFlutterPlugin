// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import 'package:shared_preferences/shared_preferences.dart';

class SignedUser {

  // ignore: prefer_typing_uninitialized_variables
  static var _sharedPrefs;

  factory SignedUser() => SignedUser._internal();

  SignedUser._internal();

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  bool get isSignedIn => userID != null;

  String? get userID => _sharedPrefs.getString('userID');

  signIn(String userID) => _sharedPrefs.setString("userID", userID);

  signOut() => _sharedPrefs.remove("userID");
}
