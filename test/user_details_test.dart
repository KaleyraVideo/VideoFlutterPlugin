import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('UserDetails Initialize', () {
    test('UserDetails default initializer', () {
      final sut = UserDetails(userID: "user_id");

      expect(sut.userID, "user_id");
      expect(sut.name, null);
      expect(sut.imageUrl, null);
    });

    test('UserDetails initializer with optional params', () {
      final sut = UserDetails(
          userID: "user_id",
          name: "nick_name",
          imageUrl: "profile_url");

      expect(sut.userID, "user_id");
      expect(sut.name, "nick_name");
      expect(sut.imageUrl, "profile_url");
    });
  });

  group('UserDetails JSON encode', () {
    test(
        'UserDetails toMapJson() function should return a valid Map<String, dynamic> object',
        () {
      final sut = UserDetails(
          userID: "user_id",
          name: "nick_name",
          imageUrl: "profile_url");

      var json = sut.toMapJson();

      expect(json, {
        "userID": "user_id",
        "name": "nick_name",
        "imageUrl": "profile_url",
      });
    });

    test('UserDetails toMapJson() when optional properties are missing', () {
      final sut = UserDetails(userID: "user_id");

      var json = sut.toMapJson();

      expect(json, {
        "userID": "user_id",
        "name": null,
        "imageUrl": null
      });
    });

    test('UserDetails toJson() function should return a valid JSON string', () {
      final sut = UserDetails(
          userID: "user_id",
          name: "nick_name",
          imageUrl: "profile_url");

      var jsonString = sut.toJson();

      expect(jsonString,
          "{\"userID\":\"user_id\",\"name\":\"nick_name\",\"imageUrl\":\"profile_url\"}");
    });
  });
}
