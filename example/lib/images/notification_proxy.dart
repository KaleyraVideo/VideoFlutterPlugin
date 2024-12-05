import 'package:kaleyra_video_flutter_plugin_example/network_example_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:huawei_hmsavailability/huawei_hmsavailability.dart';
import 'package:huawei_push/huawei_push.dart' as huawei;

import '../firebase_options.dart';
import '../main.dart';

class NotificationProxy {
  static String? cachedPushToken;
  static String? cachedVoipToken;
  static final _networkExampleApi = NetworkExampleApi();

  static Future<bool> isFirebaseSupported() async =>
      await GoogleApiAvailability.instance
          .checkGooglePlayServicesAvailability() ==
      GooglePlayServicesAvailability.success;

  static Future<bool> isHmsSupported() async =>
      await HmsApiAvailability().isHMSAvailable() == 0;

  static init() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    if (await isFirebaseSupported()) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    } else if (await isHmsSupported()) {
      await huawei.Push.registerBackgroundMessageHandler(
          huaweiBackgroundMessageCallback);
    }
  }

  static unregisterNotifications({required String userId}) {
    if (cachedPushToken != null)
      _networkExampleApi.unregisterForNotifications(userId, cachedPushToken!);
    if (cachedVoipToken != null)
      _networkExampleApi.unregisterForNotifications(userId, cachedVoipToken!);
  }

  static registerForVoipNotifications(
      {required String userId, required String voipToken}) {
    cachedVoipToken = voipToken;
    _networkExampleApi.registerForNotifications(
        userId: userId, pushToken: voipToken, pushType: PushType.voip);
  }

  static registerForPushNotifications({required String userId}) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    register(pushToken, PushProvider provider) {
      cachedPushToken = pushToken;
      _networkExampleApi.registerForNotifications(
          userId: userId,
          pushProvider: provider,
          pushToken: pushToken,
          pushType: PushType.alert);
    }

    if (await isFirebaseSupported()) {
      FirebaseMessaging.instance
          .getToken()
          .then((token) => register(token, PushProvider.FCM));
      FirebaseMessaging.instance.requestPermission();
      FirebaseMessaging.onMessage.listen((RemoteMessage message) =>
          backgroundMessageCallback(message.data['message']!));
    } else if (await isHmsSupported()) {
      huawei.Push.getTokenStream
          .listen((token) => register(token, PushProvider.HMS));
      huawei.Push.getToken('');
      huawei.Push.onMessageReceivedStream.listen((message) =>
          backgroundMessageCallback(message.dataOfMap!['message']!));
    }
  }

  static Future<String?> getToken(String userId) async {
    if (await isFirebaseSupported()) {
      return FirebaseMessaging.instance.getToken();
    } else if (await isHmsSupported()) {
      return await huawei.Push.getTokenStream.last;
    }
    return "";
  }
}

enum PushProvider { HMS, FCM }
