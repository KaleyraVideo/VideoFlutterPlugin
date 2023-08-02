import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('Configuration Initialize', () {
    test('Configuration default initializer', () {
      final environment = Environment.sandbox();
      final region = Region.europe();
      final sut = Configuration(
          appID: "app_id", environment: environment, region: region);

      expect(sut.appID, "app_id");
      expect(sut.environment, environment);
      expect(sut.region, region);
      expect(sut.logEnabled, null);
      expect(sut.tools, null);
      expect(sut.iosConfig, null);
    });

    test('Configuration initializer with logEnabled', () {
      final environment = Environment.sandbox();
      final region = Region.europe();
      final sut = Configuration(
          appID: "app_id",
          environment: environment,
          region: region,
          logEnabled: false);

      expect(sut.appID, "app_id");
      expect(sut.environment, environment);
      expect(sut.region, region);
      expect(sut.logEnabled, false);
      expect(sut.tools, null);
      expect(sut.iosConfig, null);
    });

    test('Configuration initializer with tools', () {
      final environment = Environment.sandbox();
      final region = Region.europe();
      final tools = Tools();
      final sut = Configuration(
          appID: "app_id",
          environment: environment,
          region: region,
          tools: tools);

      expect(sut.appID, "app_id");
      expect(sut.environment, environment);
      expect(sut.region, region);
      expect(sut.logEnabled, null);
      expect(sut.tools, tools);
      expect(sut.iosConfig, null);
    });

    test('Configuration initializer with iosConfig', () {
      final environment = Environment.sandbox();
      final region = Region.europe();
      final iosConfig = IosConfiguration();
      final sut = Configuration(
          appID: "app_id",
          environment: environment,
          region: region,
          iosConfig: iosConfig);

      expect(sut.appID, "app_id");
      expect(sut.environment, environment);
      expect(sut.region, region);
      expect(sut.logEnabled, null);
      expect(sut.tools, null);
      expect(sut.iosConfig, iosConfig);
    });
  });

  group('Configuration JSON encode', () {
    test(
        'Configuration toMapJson() function should return a valid Map<String, dynamic> object',
        () {
      final environment = Environment.sandbox();
      final region = Region.europe();
      final tools = Tools();
      final iosConfig = IosConfiguration();
      final sut = Configuration(
          appID: "app_id",
          environment: environment,
          region: region,
          logEnabled: true,
          tools: tools,
          iosConfig: iosConfig);

      var json = sut.toMapJson();

      expect(json, {
        "appID": "app_id",
        "environment": environment.toMapJson(),
        "region": region.toMapJson(),
        "tools": tools.toMapJson(),
        "iosConfig": iosConfig.toMapJson(),
        "logEnabled": true,
      });
    });

    test('Configuration toMapJson() when optional properties are missing', () {
      final environment = Environment.sandbox();
      final region = Region.europe();
      final sut = Configuration(
          appID: "app_id", environment: environment, region: region);

      var json = sut.toMapJson();

      expect(json, {
        "appID": "app_id",
        "environment": environment.toMapJson(),
        "region": region.toMapJson(),
        "tools": null,
        "iosConfig": null,
        "logEnabled": null,
      });
    });
  });
}
