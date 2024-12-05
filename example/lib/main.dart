// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import 'dart:async';
import 'dart:developer';

import 'package:kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin.dart';
import 'package:kaleyra_video_flutter_plugin_example/images/notification_proxy.dart';
import 'package:kaleyra_video_flutter_plugin_example/network_example_api.dart';
import 'package:kaleyra_video_flutter_plugin_example/scrollable_column.dart';
import 'package:kaleyra_video_flutter_plugin_example/signed_user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:huawei_push/huawei_push.dart' as huawei;

import 'action_button.dart';
import 'header.dart';
import 'input_field.dart';

KaleyraVideo? plugin;

Future<void> initKaleyraVideo() async {
  final SignedUser signedUser = SignedUser();
  await signedUser.init();
  await dotenv.load(fileName: ".env");
  final String appID = dotenv.env['APP_ID']!;
  final String region = dotenv.env['REGION']!;
  final String environment = dotenv.env['ENVIRONMENT']!;

  var configuration = Configuration(
    appID: appID,
    environment: Environment(name: environment),
    region: Region(name: region),
    logEnabled: true,
    tools: Tools(
        chat: ChatToolConfiguration(
            audioCallOption: AudioCallOptions(type: AudioCallType.audio),
            videoCallOption: CallOptions()),
        feedback: true,
        fileShare: true,
        screenShare: ScreenShareToolConfiguration(),
        whiteboard: true),
  );

  plugin = await KaleyraVideo.configure(configuration);

  plugin?.addUsersDetails([
    UserDetails(userID: "usr1", name: "User1"),
    UserDetails(userID: "usr2", name: "User2"),
    UserDetails(userID: "usr3", name: "User3"),
  ]);

  if (!signedUser.isSignedIn) return;
  connect(signedUser.userID!);
  plugin?.events.oniOSVoipPushTokenUpdated = (token) => {
        NotificationProxy.registerForVoipNotifications(
            userId: signedUser.userID!, voipToken: token)
      };
  plugin?.events.onCallModuleStatusChanged = (status) => {
        debugPrint(
            "ExampleKaleyraVideoFlutterPlugin >> callModuleStatus = $status")
      };
  NotificationProxy.registerForPushNotifications(userId: signedUser.userID!);
}

void connect(String userID) =>
    plugin?.connect(Session(userID, NetworkExampleApi.getAccessToken));

void disconnect() => plugin?.disconnect();

Future<void> backgroundMessageCallback(String payload) async {
  await initKaleyraVideo();
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) =>
    backgroundMessageCallback(message.data["message"]!);

@pragma('vm:entry-point')
Future<void> huaweiBackgroundMessageCallback(huawei.RemoteMessage message) =>
    backgroundMessageCallback(message.dataOfMap!["message"]!);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SignedUser().init();
  await NotificationProxy.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SignedUser signedUser = SignedUser();

  @override
  void initState() {
    super.initState();
    initKaleyraVideo();
    if (!signedUser.isSignedIn) return;
    _signedUserController.text = signedUser.userID!;
  }

  void _call() => plugin?.startCall(CreateCallOptions(
      callees: _usersToContactController.text.trim().split(","),
      callType: CallType.audioVideo));

  void _chat() =>
      plugin?.startChat(_usersToContactController.text.trim().split(",").first);

  final _signedUserController = TextEditingController();
  final _usersToContactController = TextEditingController();

  void _handlePressSignIn() {
    var userID = _signedUserController.text;
    signedUser.signIn(userID);
    connect(signedUser.userID!);
    NotificationProxy.registerForPushNotifications(userId: signedUser.userID!);
    setState(() => {});
  }

  void _handlePressSignOut() async {
    _usersToContactController.text = "";
    var userID = signedUser.userID;
    if (userID != null)
      NotificationProxy.unregisterNotifications(userId: userID);
    signedUser.signOut();
    disconnect();
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('KaleyraVideoFlutter')),
        body: ScrollableColumn(children: [
          const KaleyraLogoHeader(),
          InputField(
              labelText: "userID",
              controller: _signedUserController,
              enabled: !signedUser.isSignedIn),
          Row(children: [
            ActionButton(
                label: "Sign in",
                onPressed: _handlePressSignIn,
                enabled: !signedUser.isSignedIn),
            ActionButton(
                label: "Sign out",
                onPressed: _handlePressSignOut,
                enabled: signedUser.isSignedIn)
          ]),
          InputField(
              labelText: "Enter users to call/chat",
              controller: _usersToContactController,
              enabled: signedUser.isSignedIn),
          Row(children: [
            ActionButton(
                label: "Make a call",
                onPressed: _call,
                enabled: signedUser.isSignedIn),
            ActionButton(
                label: "Make a chat",
                onPressed: _chat,
                enabled: signedUser.isSignedIn),
          ]),
        ]),
      ),
    );
  }
}
