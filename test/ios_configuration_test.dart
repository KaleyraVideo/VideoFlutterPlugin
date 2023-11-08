import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('IosConfiguration Initialize', () {
    test('IosConfiguration default initializer', () {
      final sut = IosConfiguration();

      expect(sut.callkit, null);
      expect(sut.voipHandlingStrategy, null);
    });

    test('IosConfiguration initializer with callkit', () {
      final callkit = CallKitConfiguration();
      final sut = IosConfiguration(callkit: callkit);

      expect(sut.callkit, callkit);
      expect(sut.voipHandlingStrategy, null);
    });

    test('IosConfiguration initializer with voipHandlingStrategy', () {
      final sut =
          IosConfiguration(voipHandlingStrategy: VoipHandlingStrategy.disabled);

      expect(sut.callkit, null);
      expect(sut.voipHandlingStrategy, VoipHandlingStrategy.disabled);
    });
  });

  group('IosConfiguration JSON encode', () {
    test(
        'IosConfiguration toMapJson() function should return a valid Map<String, dynamic> object',
        () {
      final callkit = CallKitConfiguration();
      final sut = IosConfiguration(
          callkit: callkit,
          voipHandlingStrategy: VoipHandlingStrategy.disabled);

      var json = sut.toMapJson();

      expect(json, {
        "callkit": callkit.toMapJson(),
        "voipHandlingStrategy": VoipHandlingStrategy.disabled.name,
      });
    });

    test('IosConfiguration toMapJson() when optional properties are missing',
        () {
      final sut = IosConfiguration();

      var json = sut.toMapJson();

      expect(json, {
        "callkit": null,
        "voipHandlingStrategy": null,
      });
    });
  });
}
