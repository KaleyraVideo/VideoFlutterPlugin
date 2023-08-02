import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  test('CallDisplayMode enum cases name value', () {
    expect(CallDisplayMode.background.name, "background");
    expect(CallDisplayMode.foreground.name, "foreground");
    expect(CallDisplayMode.foregroundPictureInPicture.name, "foregroundPictureInPicture");
  });
}