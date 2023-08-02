import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  test('RecordingType enum cases name value', () {
    expect(RecordingType.automatic.name, "automatic");
    expect(RecordingType.manual.name, "manual");
    expect(RecordingType.none.name, "none");
  });
}