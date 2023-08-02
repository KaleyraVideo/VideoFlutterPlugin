import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  test('VoipHandlingStrategy enum cases name value', () {
    expect(VoipHandlingStrategy.automatic.name, "automatic");
    expect(VoipHandlingStrategy.disabled.name, "disabled");
  });
}