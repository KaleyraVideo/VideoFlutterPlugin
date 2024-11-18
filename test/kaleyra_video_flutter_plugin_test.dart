import 'package:kaleyra_video_flutter_plugin/flutter_native_platform_interface.dart';
import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:test/test.dart';

void main() {
  group('KaleyraVideo plugin class implementation', () {
    test(
        'KaleyraVideo configure should forward invocation toFlutterNativePlatformInterface.instance',
        () {
      final instance = _makeFlutterNativePlatformInterfaceMock();
      final conf = Configuration(
          appID: "app_id",
          environment: Environment.sandbox(),
          region: Region.europe());

      _mockFlutterNativePlatformInterface(instance);
      KaleyraVideo.configure(conf);

      expect(instance.configureInvocations, [conf]);
    });

    test(
        'KaleyraVideo reset should forward invocation to FlutterNativePlatformInterface.instance',
        () {
      final instance = _makeFlutterNativePlatformInterfaceMock();

      _mockFlutterNativePlatformInterface(instance);
      KaleyraVideo.reset();

      expect(instance.resetInvocationsCount, 1);
    });

    test(
        'KaleyraVideo events getter should return events from FlutterNativePlatformInterface.instance',
        () {
      final instance = _makeFlutterNativePlatformInterfaceMock();
      final sut = _makeSUT();

      _mockFlutterNativePlatformInterface(instance);
      final events = sut.events;

      expect(instance.eventsGetterInvocationsCount, 1);
      expect(events, isA<_DummyEvents>());
    });

    test(
        'KaleyraVideo connect should forward invocation to FlutterNativePlatformInterface.instance',
        () {
      final session = Session("user_id", (userID) => Future(() => "token"));
      final instance = _makeFlutterNativePlatformInterfaceMock();
      final sut = _makeSUT();

      _mockFlutterNativePlatformInterface(instance);
      sut.connect(session);

      expect(instance.connectInvocations, [session]);
    });

    test(
        'KaleyraVideo getCurrentVoIPPushToken() should return getCurrentVoIPPushToken() from FlutterNativePlatformInterface.instance',
        () {
      final instance = _makeFlutterNativePlatformInterfaceMock();
      final sut = _makeSUT();

      _mockFlutterNativePlatformInterface(instance);
      sut.getCurrentVoIPPushToken();

      expect(instance.getCurrentVoIPPushTokenInvocationsCount, 1);
    });

    test(
        'KaleyraVideo startCall should forward invocation to FlutterNativePlatformInterface.instance',
        () {
      final instance = _makeFlutterNativePlatformInterfaceMock();
      final sut = _makeSUT();
      final options =
          CreateCallOptions(callees: ["user_1"], callType: CallType.audioVideo);

      _mockFlutterNativePlatformInterface(instance);
      sut.startCall(options);

      expect(instance.startCallInvocations, [options]);
    });

    test(
        'KaleyraVideo disconnect should forward invocation to FlutterNativePlatformInterface.instance',
        () {
      final instance = _makeFlutterNativePlatformInterfaceMock();
      final sut = _makeSUT();

      _mockFlutterNativePlatformInterface(instance);
      sut.disconnect();

      expect(instance.disconnectInvocationsCount, 1);
    });

    test(
        'KaleyraVideo clearUserCache should forward invocation to FlutterNativePlatformInterface.instance',
        () {
      final instance = _makeFlutterNativePlatformInterfaceMock();
      final sut = _makeSUT();

      _mockFlutterNativePlatformInterface(instance);
      sut.clearUserCache();

      expect(instance.clearUserCacheInvocationsCount, 1);
    });

    test(
        'KaleyraVideo removeUsersDetails should forward invocation to FlutterNativePlatformInterface.instance',
        () {
      final instance = _makeFlutterNativePlatformInterfaceMock();
      final sut = _makeSUT();

      _mockFlutterNativePlatformInterface(instance);
      sut.removeUsersDetails();

      expect(instance.removeUsersDetailsInvocationsCount, 1);
    });

    test(
        'KaleyraVideo addUsersDetails should forward invocation to FlutterNativePlatformInterface.instance',
        () {
      final details = [UserDetails(userID: "user_id")];
      final instance = _makeFlutterNativePlatformInterfaceMock();
      final sut = _makeSUT();

      _mockFlutterNativePlatformInterface(instance);
      sut.addUsersDetails(details);

      expect(instance.addUsersDetailsInvocations, [details]);
    });

    test(
        'KaleyraVideo setDisplayModeForCurrentCall should forward invocation to FlutterNativePlatformInterface.instance',
        () {
      final instance = _makeFlutterNativePlatformInterfaceMock();
      final sut = _makeSUT();

      _mockFlutterNativePlatformInterface(instance);
      sut.setDisplayModeForCurrentCall(CallDisplayMode.background);

      expect(instance.setDisplayModeForCurrentCallInvocations,
          [CallDisplayMode.background]);
    });

    test(
        'KaleyraVideo verifyCurrentCall should forward invocation to FlutterNativePlatformInterface.instance',
        () {
      final instance = _makeFlutterNativePlatformInterfaceMock();
      final sut = _makeSUT();

      _mockFlutterNativePlatformInterface(instance);
      sut.verifyCurrentCall(false);

      expect(instance.verifyCurrentCallInvocations, [false]);
    });

    test(
        'KaleyraVideo startChat should forward invocation to FlutterNativePlatformInterface.instance',
        () {
      final instance = _makeFlutterNativePlatformInterfaceMock();
      final sut = _makeSUT();

      _mockFlutterNativePlatformInterface(instance);
      sut.verifyCurrentCall(false);

      expect(instance.verifyCurrentCallInvocations, [false]);
    });

    test(
        'KaleyraVideo startCallFrom should forward invocation to FlutterNativePlatformInterface.instance',
        () {
      final instance = _makeFlutterNativePlatformInterfaceMock();
      final sut = _makeSUT();

      _mockFlutterNativePlatformInterface(instance);
      sut.startCallFrom("url");

      expect(instance.startCallFromInvocations, ["url"]);
    });
  });
}

// MARK: - Helpers

_KaleyraVideoDefaultImplementation _makeSUT() {
  return _KaleyraVideoDefaultImplementation();
}

void _mockFlutterNativePlatformInterface(
    _FlutterNativePlatformInterfaceMock instance) {
  FlutterNativePlatformInterface.instance = instance;
}

_FlutterNativePlatformInterfaceMock _makeFlutterNativePlatformInterfaceMock() {
  return _FlutterNativePlatformInterfaceMock();
}

// MARK: - Test Doubles

class _KaleyraVideoDefaultImplementation extends KaleyraVideo {}

class _FlutterNativePlatformInterfaceMock extends Mock
    with MockPlatformInterfaceMixin
    implements FlutterNativePlatformInterface {
  List<Configuration> configureInvocations = [];
  int resetInvocationsCount = 0;
  int eventsGetterInvocationsCount = 0;
  List<Session> connectInvocations = [];
  int getCurrentVoIPPushTokenInvocationsCount = 0;
  List<CreateCallOptions> startCallInvocations = [];
  int disconnectInvocationsCount = 0;
  int clearUserCacheInvocationsCount = 0;
  int removeUsersDetailsInvocationsCount = 0;
  List<List<UserDetails>> addUsersDetailsInvocations = [];
  List<CallDisplayMode> setDisplayModeForCurrentCallInvocations = [];
  List<bool> verifyCurrentCallInvocations = [];
  List<String> startCallFromInvocations = [];

  @override
  Future<KaleyraVideo> configure(Configuration configuration) {
    configureInvocations.add(configuration);
    return Future(() => _KaleyraVideoDefaultImplementation());
  }

  @override
  void reset() {
    resetInvocationsCount++;
  }

  @override
  Events get events {
    eventsGetterInvocationsCount++;
    return _DummyEvents();
  }

  @override
  connect(Session session) {
    connectInvocations.add(session);
  }

  @override
  Future<String?> getCurrentVoIPPushToken() {
    getCurrentVoIPPushTokenInvocationsCount++;
    return Future(() => "token");
  }

  @override
  startCall(CreateCallOptions callOptions) {
    startCallInvocations.add(callOptions);
  }

  @override
  disconnect() {
    disconnectInvocationsCount++;
  }

  @override
  clearUserCache() {
    clearUserCacheInvocationsCount++;
  }

  @override
  removeUsersDetails() {
    removeUsersDetailsInvocationsCount++;
  }

  @override
  addUsersDetails(List<UserDetails> userDetails) {
    addUsersDetailsInvocations.add(userDetails);
  }

  @override
  setDisplayModeForCurrentCall(CallDisplayMode mode) {
    setDisplayModeForCurrentCallInvocations.add(mode);
  }

  @override
  verifyCurrentCall(bool verify) {
    verifyCurrentCallInvocations.add(verify);
  }

  @override
  startCallFrom(String url) {
    startCallFromInvocations.add(url);
  }
}

class _DummyEvents extends Events {}
