import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  test('CallType enum cases name value', () {
    expect(CallType.audio.name, "audio");
    expect(CallType.audioUpgradable.name, "audioUpgradable");
    expect(CallType.audioVideo.name, "audioVideo");
  });
}
