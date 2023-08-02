import 'package:kaleyra_video_flutter_plugin/flutter_native_platform_interface.dart';
import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  test('FlutterNativePlatformInterface static instance setter/getter', () {
    final dummyInstance = DummyFlutterNativePlatformInterface();

    FlutterNativePlatformInterface.instance = dummyInstance;

    expect(
        FlutterNativePlatformInterface.instance, dummyInstance);
  });
}

class DummyFlutterNativePlatformInterface
    extends FlutterNativePlatformInterface {
  @override
  Future<KaleyraVideo> configure(Configuration configuration) {
    throw UnimplementedError();
  }

  @override
  void reset() {}
}
