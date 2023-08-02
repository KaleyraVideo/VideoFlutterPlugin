import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('ChatToolConfiguration Initialize', () {
    test('ChatToolConfiguration default initializer', () {
      final sut = ChatToolConfiguration();

      expect(sut.audioCallOption, null);
      expect(sut.videoCallOption, null);
    });

    test('ChatToolConfiguration initializer with audioCallOption', () {
      final audioCallOption =
          AudioCallOptions(type: AudioCallType.audioUpgradable);
      final sut = ChatToolConfiguration(audioCallOption: audioCallOption);

      expect(sut.audioCallOption, audioCallOption);
      expect(sut.videoCallOption, null);
    });
    test('ChatToolConfiguration initializer with videoCallOption', () {
      final videoCallOption = CallOptions();
      final sut = ChatToolConfiguration(videoCallOption: videoCallOption);

      expect(sut.audioCallOption, null);
      expect(sut.videoCallOption, videoCallOption);
    });
  });

  group('ChatToolConfiguration JSON encode', () {
    test(
        'ChatToolConfiguration toMapJson() function should return a valid Map<String, dynamic> object',
        () {
      final audioCallOption =
          AudioCallOptions(type: AudioCallType.audioUpgradable);
      final videoCallOption = CallOptions();
      final sut = ChatToolConfiguration(
          audioCallOption: audioCallOption, videoCallOption: videoCallOption);

      var json = sut.toMapJson();

      expect(json, {
        "audioCallOption": audioCallOption.toMapJson(),
        "videoCallOption": videoCallOption.toMapJson()
      });
    });

    test('CallOptions toMapJson() when recordingType is missing', () {
      final sut = CallOptions();

      var json = sut.toMapJson();

      expect(json, {"recordingType": null});
    });

    test('ChatToolConfiguration toMapJson() when audioCallOption is missing',
        () {
      final videoCallOption = CallOptions();
      final sut = ChatToolConfiguration(videoCallOption: videoCallOption);

      var json = sut.toMapJson();

      expect(json, {
        "audioCallOption": null,
        "videoCallOption": videoCallOption.toMapJson()
      });
    });

    test('ChatToolConfiguration toMapJson() when videoCallOption is missing',
        () {
      final audioCallOption =
          AudioCallOptions(type: AudioCallType.audioUpgradable);
      final sut = ChatToolConfiguration(audioCallOption: audioCallOption);

      var json = sut.toMapJson();

      expect(json, {
        "audioCallOption": audioCallOption.toMapJson(),
        "videoCallOption": null
      });
    });

    test(
        'ChatToolConfiguration toMapJson() when audioCallOption and videoCallOption are missing',
        () {
      final sut = ChatToolConfiguration();

      var json = sut.toMapJson();

      expect(json, {"audioCallOption": null, "videoCallOption": null});
    });
  });
}
