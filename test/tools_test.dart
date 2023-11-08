import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('Tools Initialize', () {
    test('Tools default initializer', () {
      final sut = Tools();

      expect(sut.chat, null);
      expect(sut.feedback, null);
      expect(sut.fileShare, null);
      expect(sut.screenShare, null);
      expect(sut.whiteboard, null);
    });

    test('Tools initializer with chat', () {
      final chat = ChatToolConfiguration();
      final sut = Tools(chat: chat);

      expect(sut.chat, chat);
      expect(sut.feedback, null);
      expect(sut.fileShare, null);
      expect(sut.screenShare, null);
      expect(sut.whiteboard, null);
    });

    test('Tools initializer with feedback', () {
      final sut = Tools(feedback: true);

      expect(sut.chat, null);
      expect(sut.feedback, true);
      expect(sut.fileShare, null);
      expect(sut.screenShare, null);
      expect(sut.whiteboard, null);
    });

    test('Tools initializer with fileShare', () {
      final sut = Tools(fileShare: true);

      expect(sut.chat, null);
      expect(sut.feedback, null);
      expect(sut.fileShare, true);
      expect(sut.screenShare, null);
      expect(sut.whiteboard, null);
    });

    test('Tools initializer with screenShare', () {
      final screenShare = ScreenShareToolConfiguration();
      final sut = Tools(screenShare: screenShare);

      expect(sut.chat, null);
      expect(sut.feedback, null);
      expect(sut.fileShare, null);
      expect(sut.screenShare, screenShare);
      expect(sut.whiteboard, null);
    });

    test('Tools initializer with whiteboard', () {
      final sut = Tools(whiteboard: true);

      expect(sut.chat, null);
      expect(sut.feedback, null);
      expect(sut.fileShare, null);
      expect(sut.screenShare, null);
      expect(sut.whiteboard, true);
    });
  });

  group('Tools JSON encode', () {
    test(
        'Tools toMapJson() function should return a valid Map<String, dynamic> object',
        () {
      final chat = ChatToolConfiguration();
      final screenShare = ScreenShareToolConfiguration();
      final sut = Tools(
          chat: chat,
          feedback: false,
          fileShare: true,
          screenShare: screenShare,
          whiteboard: false);

      var json = sut.toMapJson();

      expect(json, {
        "chat": chat.toMapJson(),
        "feedback": false,
        "fileShare": true,
        "screenShare": screenShare.toMapJson(),
        "whiteboard": false,
      });
    });

    test('Tools toMapJson() when optional properties are missing', () {
      final sut = Tools();

      var json = sut.toMapJson();

      expect(json, {
        "chat": null,
        "feedback": false,
        "fileShare": false,
        "screenShare": null,
        "whiteboard": false,
      });
    });

    test(
        'ScreenShareToolConfiguration toJson() function should return a valid JSON string',
        () {
      final sut = Tools();

      var jsonString = sut.toJson();

      expect(jsonString,
          "{\"chat\":null,\"feedback\":false,\"fileShare\":false,\"screenShare\":null,\"whiteboard\":false}");
    });
  });
}
