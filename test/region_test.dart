import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('Region Initialize', () {
    test('Region default initializer', () {
      final sut = Region(name: "region_name");

      expect(sut.name, "region_name");
    });

    test('Region.europe() factory method', () {
      final sut = Region.europe();

      expect(sut.name, "europe");
    });

    test('Region.india() factory method', () {
      final sut = Region.india();

      expect(sut.name, "india");
    });

    test('Region.us() factory method', () {
      final sut = Region.us();

      expect(sut.name, "us");
    });
  });

  group('Region subclasses', () {
    test('EuropeRegion class should create Region with europe name', () {
      final sut = EuropeRegion();

      expect(sut.name, "europe");
    });

    test('IndiaRegion class should create Region with india name', () {
      final sut = IndiaRegion();

      expect(sut.name, "india");
    });

    test('USRegion class should create Region with us name', () {
      final sut = USRegion();

      expect(sut.name, "us");
    });
  });

  group('Region JSON encode', () {
    test(
        'Region toMapJson() function should return a valid Map<String, dynamic> object',
        () {
      final sut = Region(name: "region_name");

      var json = sut.toMapJson();

      expect(json, {
        "name": "region_name",
      });
    });

    test('Region toJson() function should return a valid JSON string', () {
      final sut = Region(name: "region_name");

      var jsonString = sut.toJson();

      expect(jsonString, "{\"name\":\"region_name\"}");
    });
  });
}
