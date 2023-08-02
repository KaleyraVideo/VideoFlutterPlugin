import 'package:kaleyra_video_flutter_plugin/channel_events.dart';
import 'package:flutter/services.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'channel_events_test.mocks.dart';

@GenerateMocks([MethodChannel])
void main() {
  group('ChannelEvents Initialize', () {
    test('ChannelEvents constructor', () {
      final channel = MockMethodChannel();
      final sut = ChannelEvents(channel: channel);

      expect(sut.channel, channel);
    });

    test(
        'ChannelEvents init should call setMethodCallHandler(_) on injected channel',
        () {
      final channel = MockMethodChannel();
      ChannelEvents(channel: channel);

      verify(channel.setMethodCallHandler(any)).called(1);
    });
  });

  group('ChanelEvents method channel call handler invocation', () {
    test(
        'ChanelEvents accessTokenRequest method call on MethodChannel should invoke accessTokenRequest function',
        () {
      final channel = MockMethodChannel();
      final sutSpy = ChannelEventsSpy(channel: channel);

      channel.invokeMethod("accessTokenRequest", "user_id");

      expect(sutSpy.accessTokenRequestInvocations, ["user_id"]);
    });

    test(
        'ChanelEvents setupError method call on MethodChannel should invoke onSetupError function',
        () {
      final channel = MockMethodChannel();
      final sutSpy = ChannelEventsSpy(channel: channel);

      channel.invokeMethod("setupError", "reason");

      expect(sutSpy.onSetupErrorInvocations, ["reason"]);
    });

    test(
        'ChanelEvents callModuleStatusChanged method call on MethodChannel should invoke onCallModuleStatusChanged function',
        () {
      final channel = MockMethodChannel();
      final sutSpy = ChannelEventsSpy(channel: channel);

      channel.invokeMethod("callModuleStatusChanged", "state");

      expect(sutSpy.onCallModuleStatusChangedInvocations, ["state"]);
    });

    test(
        'ChanelEvents callError method call on MethodChannel should invoke onCallError function',
        () {
      final channel = MockMethodChannel();
      final sutSpy = ChannelEventsSpy(channel: channel);

      channel.invokeMethod("callError", "reason");

      expect(sutSpy.onCallErrorInvocations, ["reason"]);
    });

    test(
        'ChanelEvents chatError method call on MethodChannel should invoke onChatError function',
        () {
      final channel = MockMethodChannel();
      final sutSpy = ChannelEventsSpy(channel: channel);

      channel.invokeMethod("chatError", "reason");

      expect(sutSpy.onChatErrorInvocations, ["reason"]);
    });

    test(
        'ChanelEvents chatModuleStatusChanged method call on MethodChannel should invoke onChatModuleStatusChanged function',
        () {
      final channel = MockMethodChannel();
      final sutSpy = ChannelEventsSpy(channel: channel);

      channel.invokeMethod("chatModuleStatusChanged", "state");

      expect(sutSpy.onChatModuleStatusChangedInvocations, ["state"]);
    });

    test(
        'ChanelEvents iOSVoipPushTokenUpdated method call on MethodChannel should invoke oniOSVoipPushTokenUpdated function',
        () {
      final channel = MockMethodChannel();
      final sutSpy = ChannelEventsSpy(channel: channel);

      channel.invokeMethod("iOSVoipPushTokenUpdated", "token");

      expect(sutSpy.oniOSVoipPushTokenUpdatedInvocations, ["token"]);
    });

    test(
        'ChanelEvents iOSVoipPushTokenInvalidated method call on MethodChannel should invoke oniOSVoipPushTokenInvalidated function',
        () {
      final channel = MockMethodChannel();
      final sutSpy = ChannelEventsSpy(channel: channel);

      channel.invokeMethod("iOSVoipPushTokenInvalidated");

      expect(sutSpy.oniOSVoipPushTokenInvalidatedInvocations, 1);
    });
  });
}

class ChannelEventsSpy {
  final MockMethodChannel channel;
  final ChannelEvents sut;

  final List<String> accessTokenRequestInvocations;
  final List<String> onSetupErrorInvocations;
  final List<String> onCallModuleStatusChangedInvocations;
  final List<String> onCallErrorInvocations;
  final List<String> onChatErrorInvocations;
  final List<String> onChatModuleStatusChangedInvocations;
  final List<String> oniOSVoipPushTokenUpdatedInvocations;
  int oniOSVoipPushTokenInvalidatedInvocations;

  ChannelEventsSpy({required this.channel})
      : sut = ChannelEvents(channel: channel),
        accessTokenRequestInvocations = List.empty(growable: true),
        onSetupErrorInvocations = List.empty(growable: true),
        onCallModuleStatusChangedInvocations = List.empty(growable: true),
        onCallErrorInvocations = List.empty(growable: true),
        onChatErrorInvocations = List.empty(growable: true),
        onChatModuleStatusChangedInvocations = List.empty(growable: true),
        oniOSVoipPushTokenUpdatedInvocations = List.empty(growable: true),
        oniOSVoipPushTokenInvalidatedInvocations = 0 {
    final verification = verify(channel.setMethodCallHandler(captureAny));
    final handler =
        verification.captured.first as Future<dynamic> Function(MethodCall);

    when(channel.invokeMethod(any, any)).thenAnswer((realInvocation) {
      final methodName = realInvocation.positionalArguments.first as String;
      final args = realInvocation.positionalArguments.last as String?;
      if (args != null) {
        return handler(MethodCall(methodName, args));
      } else {
        return handler(MethodCall(methodName));
      }
    });

    sut.accessTokenRequest = (userId) {
      accessTokenRequestInvocations.add(userId);
      return Future(() => "token");
    };

    sut.onSetupError = (reason) {
      onSetupErrorInvocations.add(reason);
    };

    sut.onCallModuleStatusChanged = (state) {
      onCallModuleStatusChangedInvocations.add(state);
    };

    sut.onCallError = (reason) {
      onCallErrorInvocations.add(reason);
    };

    sut.onChatError = (reason) {
      onChatErrorInvocations.add(reason);
    };

    sut.onChatModuleStatusChanged = (state) {
      onChatModuleStatusChangedInvocations.add(state);
    };

    sut.oniOSVoipPushTokenUpdated = (token) {
      oniOSVoipPushTokenUpdatedInvocations.add(token);
    };

    sut.oniOSVoipPushTokenInvalidated = () {
      oniOSVoipPushTokenInvalidatedInvocations++;
    };
  }
}
