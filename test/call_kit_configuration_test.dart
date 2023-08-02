import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('CallKitConfiguration Initialize', () {
    test('CallKitConfiguration default initializer', () {
      final sut = CallKitConfiguration();

      expect(sut.appIconName, null);
      expect(sut.enabled, null);
      expect(sut.ringtoneSoundName, null);
    });

    test('CallKitConfiguration initializer with appIconName', () {
      final sut = CallKitConfiguration(appIconName: "app_icon_name");

      expect(sut.appIconName, "app_icon_name");
      expect(sut.enabled, null);
      expect(sut.ringtoneSoundName, null);
    });

    test('CallKitConfiguration initializer with enabled', () {
      final sut = CallKitConfiguration(enabled: true);

      expect(sut.appIconName, null);
      expect(sut.enabled, true);
      expect(sut.ringtoneSoundName, null);
    });

    test('CallKitConfiguration initializer with ringtoneSoundName', () {
      final sut =
          CallKitConfiguration(ringtoneSoundName: "ringtone_sound_name");

      expect(sut.appIconName, null);
      expect(sut.enabled, null);
      expect(sut.ringtoneSoundName, "ringtone_sound_name");
    });
  });

  group('JSON encode', () {
    test(
        'CallKitConfiguration toMapJson() function should return a valid Map<String, dynamic> object',
        () {
      final sut = CallKitConfiguration(
          appIconName: "app_icon_name",
          enabled: false,
          ringtoneSoundName: "ringtone_sound_name");

      var json = sut.toMapJson();

      expect(json, {
        "appIconName": "app_icon_name",
        "enabled": false,
        "ringtoneSoundName": "ringtone_sound_name"
      });
    });

    test('CallKitConfiguration toMapJson() when appIconName is missing', () {
      final sut = CallKitConfiguration(
          enabled: false, ringtoneSoundName: "ringtone_sound_name");

      var json = sut.toMapJson();

      expect(json, {
        "appIconName": null,
        "enabled": false,
        "ringtoneSoundName": "ringtone_sound_name"
      });
    });

    test('CallKitConfiguration toMapJson() when enabled is missing', () {
      final sut = CallKitConfiguration(
          appIconName: "app_icon_name",
          ringtoneSoundName: "ringtone_sound_name");

      var json = sut.toMapJson();

      expect(json, {
        "appIconName": "app_icon_name",
        "enabled": null,
        "ringtoneSoundName": "ringtone_sound_name"
      });
    });

    test('CallKitConfiguration toMapJson() when ringtoneSoundName is missing',
        () {
      final sut =
          CallKitConfiguration(appIconName: "app_icon_name", enabled: false);

      var json = sut.toMapJson();

      expect(json, {
        "appIconName": "app_icon_name",
        "enabled": false,
        "ringtoneSoundName": null
      });
    });

    test('CallKitConfiguration toMapJson() when all properties are missing',
        () {
      final sut = CallKitConfiguration();

      var json = sut.toMapJson();

      expect(json,
          {"appIconName": null, "enabled": null, "ringtoneSoundName": null});
    });
  });
}
