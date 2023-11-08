import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('ScreenShareToolConfiguration Initialize', () {
    test('ScreenShareToolConfiguration default initializer', () {
      final sut = ScreenShareToolConfiguration();

      expect(sut.inApp, null);
      expect(sut.wholeDevice, null);
    });

    test('ScreenShareToolConfiguration initializer with inApp', () {
      final sut = ScreenShareToolConfiguration(inApp: true);

      expect(sut.inApp, true);
      expect(sut.wholeDevice, null);
    });

    test('ScreenShareToolConfiguration initializer with wholeDevice', () {
      final sut = ScreenShareToolConfiguration(wholeDevice: true);

      expect(sut.inApp, null);
      expect(sut.wholeDevice, true);
    });
  });

  group('ScreenShareToolConfiguration JSON encode', () {
    test(
        'ScreenShareToolConfiguration toMapJson() function should return a valid Map<String, dynamic> object',
        () {
      final sut = ScreenShareToolConfiguration(inApp: true, wholeDevice: true);

      var json = sut.toMapJson();

      expect(json, {
        "inApp": true,
        "wholeDevice": true,
      });
    });

    test(
        'ScreenShareToolConfiguration toMapJson() when optional properties are missing',
        () {
      final sut = ScreenShareToolConfiguration();

      var json = sut.toMapJson();

      expect(json, {
        "inApp": false,
        "wholeDevice": false,
      });
    });

    test(
        'ScreenShareToolConfiguration toJson() function should return a valid JSON string',
        () {
      final sut = ScreenShareToolConfiguration(inApp: true, wholeDevice: true);

      var jsonString = sut.toJson();

      expect(jsonString, "{\"inApp\":true,\"wholeDevice\":true}");
    });
  });
}
