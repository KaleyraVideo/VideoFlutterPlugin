import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('UserDetails Initialize', () {
    test('UserDetails default initializer', () {
      final sut = UserDetails(userID: "user_id");

      expect(sut.userID, "user_id");
      expect(sut.nickName, null);
      expect(sut.firstName, null);
      expect(sut.lastName, null);
      expect(sut.email, null);
      expect(sut.profileImageUrl, null);
    });

    test('UserDetails initializer with optional params', () {
      final sut = UserDetails(
          userID: "user_id",
          nickName: "nick_name",
          firstName: "first name",
          lastName: "last name",
          email: "email",
          profileImageUrl: "profile_url");

      expect(sut.userID, "user_id");
      expect(sut.nickName, "nick_name");
      expect(sut.firstName, "first name");
      expect(sut.lastName, "last name");
      expect(sut.email, "email");
      expect(sut.profileImageUrl, "profile_url");
    });
  });

  group('UserDetails JSON encode', () {
    test(
        'UserDetails toMapJson() function should return a valid Map<String, dynamic> object',
        () {
      final sut = UserDetails(
          userID: "user_id",
          nickName: "nick_name",
          firstName: "first name",
          lastName: "last name",
          email: "email",
          profileImageUrl: "profile_url");

      var json = sut.toMapJson();

      expect(json, {
        "userID": "user_id",
        "firstName": "first name",
        "lastName": "last name",
        "email": "email",
        "nickName": "nick_name",
        "profileImageURL": "profile_url",
      });
    });

    test('UserDetails toMapJson() when optional properties are missing', () {
      final sut = UserDetails(userID: "user_id");

      var json = sut.toMapJson();

      expect(json, {
        "userID": "user_id",
        "firstName": null,
        "lastName": null,
        "email": null,
        "nickName": null,
        "profileImageURL": null,
      });
    });

    test('UserDetails toJson() function should return a valid JSON string', () {
      final sut = UserDetails(
          userID: "user_id",
          nickName: "nick_name",
          firstName: "first name",
          lastName: "last name",
          email: "email",
          profileImageUrl: "profile_url");

      var jsonString = sut.toJson();

      expect(jsonString,
          "{\"userID\":\"user_id\",\"firstName\":\"first name\",\"lastName\":\"last name\",\"email\":\"email\",\"nickName\":\"nick_name\",\"profileImageURL\":\"profile_url\"}");
    });
  });
}
