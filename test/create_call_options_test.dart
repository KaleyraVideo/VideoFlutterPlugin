import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('CreateCallOptions Initialize', () {
    test('CreateCallOptions default initializer', () {
      final sut = CreateCallOptions(
          callees: ["user_1", "user_2", "user_3"],
          callType: CallType.audioUpgradable);

      expect(sut.callees, ["user_1", "user_2", "user_3"]);
      expect(sut.callType, CallType.audioUpgradable);
      expect(sut.recordingType, null);
    });

    test('CreateCallOptions initializer with recordingType', () {
      final sut = CreateCallOptions(
          callees: ["user_1", "user_2", "user_3"],
          callType: CallType.audioUpgradable,
          recordingType: RecordingType.manual);

      expect(sut.callees, ["user_1", "user_2", "user_3"]);
      expect(sut.callType, CallType.audioUpgradable);
      expect(sut.recordingType, RecordingType.manual);
    });
  });

  group('CreateCallOptions JSON encode', () {
    test(
        'CreateCallOptions toMapJson() function should return a valid Map<String, dynamic> object',
        () {
     final sut = CreateCallOptions(
          callees: ["user_1", "user_2", "user_3"],
          callType: CallType.audioUpgradable,
          recordingType: RecordingType.manual);

      var json = sut.toMapJson();

      expect(json, {
        "callees": List<dynamic>.from(["user_1", "user_2", "user_3"]),
        "callType": CallType.audioUpgradable.name,
        "recordingType": RecordingType.manual.name,
      });
    });

    test('CreateCallOptions toMapJson() when recordingType is missing', () {
      final sut = CreateCallOptions(
          callees: ["user_1", "user_2", "user_3"],
          callType: CallType.audioUpgradable);

      var json = sut.toMapJson();

      expect(json, {
        "callees": List<dynamic>.from(["user_1", "user_2", "user_3"]),
        "callType": CallType.audioUpgradable.name,
        "recordingType": RecordingType.none.name,
      });
    });
  });
}
