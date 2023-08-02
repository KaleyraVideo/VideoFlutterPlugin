import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('Initialize', () {
    test('AudioCallOptions default initializer', () {
      final sut = AudioCallOptions(type: AudioCallType.audio);

      expect(sut.type, AudioCallType.audio);
      expect(sut.recordingType, null);
    });

    test('AudioCallOptions recording type', () {
      final sut = AudioCallOptions(
          recordingType: RecordingType.automatic, type: AudioCallType.audio);

      expect(sut.type, AudioCallType.audio);
      expect(sut.recordingType, RecordingType.automatic);
    });
  });

  group('JSON encode', () {
    test('AudioCallOptions toMapJson() function should return a valid Map<String, dynamic> object', () {
      final sut = AudioCallOptions(
          recordingType: RecordingType.manual, type: AudioCallType.audioUpgradable);

      var json = sut.toMapJson();

      expect(json, {
        "recordingType": "manual",
        "type": "audioUpgradable"
      });
    });

    test('AudioCallOptions toMapJson() when recordingType is missing', () {
      final sut = AudioCallOptions(type: AudioCallType.audioUpgradable);

      var json = sut.toMapJson();

      expect(json, {
        "recordingType": null,
        "type": "audioUpgradable"
      });
    });
  });
}
