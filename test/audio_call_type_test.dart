import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  test('AudioCallType enum cases name value', () {
    expect(AudioCallType.audio.name, "audio");
    expect(AudioCallType.audioUpgradable.name, "audioUpgradable");
  });
}
