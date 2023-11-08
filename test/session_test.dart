import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('Session Initialize', () {
    test('Session default initializer', () {
      accessTokenProvider(userId) async {
        return "";
      }

      final sut = Session("user_id", accessTokenProvider);

      expect(sut.userId, "user_id");
      expect(sut.accessTokenProvider, accessTokenProvider);
    });
  });

  group('Session JSON encode', () {
    test(
        'Session toMapJson() function should return a valid Map<String, dynamic> object',
        () {
      final sut = Session("user_id", (userId) async {
        return "";
      });

      var json = sut.toMapJson();

      expect(json, {
        "userID": "user_id",
      });
    });

    test(
        'ScreenShareToolConfiguration toJson() function should return a valid JSON string',
        () {
      final sut = Session("user_id", (userId) async {
        return "";
      });

      var jsonString = sut.toJson();

      expect(jsonString, "{\"userID\":\"user_id\"}");
    });
  });
}
