import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('CallOptions Initialize', () {
    test('CallOptions default initializer', () {
      final sut = CallOptions();

      expect(sut.recordingType, null);
    });

    test('CallOptions initializer with recordingType', () {
      final sut = CallOptions(recordingType: RecordingType.manual);

      expect(sut.recordingType, RecordingType.manual);
    });
  });

  group('CallOptions JSON encode', () {
    test(
        'CallOptions toMapJson() function should return a valid Map<String, dynamic> object',
        () {
      final sut = CallOptions(recordingType: RecordingType.automatic);

      var json = sut.toMapJson();

      expect(json, {"recordingType": "automatic"});
    });

    test('CallOptions toMapJson() when recordingType is missing', () {
      final sut = CallOptions();

      var json = sut.toMapJson();

      expect(json, {"recordingType": null});
    });
  });
}
