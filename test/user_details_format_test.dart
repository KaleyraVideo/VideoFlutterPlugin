import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('UserDetailsFormat Initialize', () {
    test('UserDetailsFormat default initializer', () {
      final sut = UserDetailsFormat(userDetailsFormatDefault: "default");

      expect(sut.androidNotification, null);
      expect(sut.userDetailsFormatDefault, "default");
    });

    test('UserDetailsFormat initializer with androidNotification', () {
      final sut = UserDetailsFormat(
          androidNotification: "android", userDetailsFormatDefault: "default");

      expect(sut.androidNotification, "android");
      expect(sut.userDetailsFormatDefault, "default");
    });
  });

  group('UserDetailsFormat JSON encode', () {
    test(
        'UserDetailsFormat toJson() function should return a valid JSON string',
        () {
      final sut = UserDetailsFormat(
          androidNotification: "android", userDetailsFormatDefault: "default");

      var jsonString = sut.toJson();

      expect(jsonString,
          "{\"default\":\"default\",\"androidNotification\":\"android\"}");
    });
  });
}
