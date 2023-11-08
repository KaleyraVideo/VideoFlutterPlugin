import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('Configuration Initialize', () {
    test('Configuration default initializer', () {
      final sut = Environment(name: "env_name");

      expect(sut.name, "env_name");
    });

    test('Configuration.sandbox() factory method', () {
      final sut = Environment.sandbox();

      expect(sut.name, "sandbox");
    });

    test('Configuration.production() factory method', () {
      final sut = Environment.production();

      expect(sut.name, "production");
    });
  });

  group('Configuration subclasses', () {
    test(
        'SandboxEnvironment class should create Configuration with sandbox name',
        () {
      final sut = SandboxEnvironment();

      expect(sut.name, "sandbox");
    });

    test(
        'ProductionEnvironment class should create Configuration with production name',
        () {
      final sut = ProductionEnvironment();

      expect(sut.name, "production");
    });
  });
}
