// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'notification_proxy.dart';

// Mock request to our private server
// DO NOT USE !!!
class NetworkExampleApi {
  static final String apiKey = dotenv.env['API_KEY']!;
  static final String appID = dotenv.env['APP_ID']!;
  static final String env = dotenv.env['ENVIRONMENT']!;
  static final String region = dotenv.env['REGION']!;

  // this request should be made to your server
  // API_KEY is a secret key to be used only for Server to Server requests
  static Future<String> getAccessToken(String userId) async {
    log(_endpoint());
    final uri = Uri.parse('https://${_endpoint()}/rest/sdk/credentials');
    final headers = {'Content-Type': 'application/json', 'apikey': apiKey};
    Map<String, dynamic> body = {'user_id': userId};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    return json.decode(response.body)["access_token"];
  }

  unregisterForNotifications(String userId, String token) async {
    final uri = Uri.parse(
        'https://${_endpoint()}/mobile_push_notifications/rest/device/$userId/$appID/$token');
    await http.delete(uri).then(
        (value) => {log("notification unregister success")},
        onError: (error) => {log("notification unregister error=$error")});
  }

  // this function is an utility function to register the device token for push notifications
  // Use your own server for push notification delivery and managing
  registerForNotifications(
      {required String userId,
      PushProvider? pushProvider,
      required String pushToken,
      required PushType pushType}) async {
    if (pushToken.isEmpty) return;
    final uri = Uri.parse(
        'https://${_endpoint()}/mobile_push_notifications/rest/device');
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'user_alias': userId,
      'app_id': appID,
      'push_token': pushToken,
      'platform': Platform.operatingSystem.toLowerCase(),
      'platform_type': "flutter",
      'push_type': pushType.name
    };
    if (pushProvider != null) body["push_provider"] = pushProvider.name;
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    await http
        .post(
          uri,
          headers: headers,
          body: jsonBody,
          encoding: encoding,
        )
        .then((value) => {log("subscribed for notifications")},
            onError: (error) =>
                {log("Failed to subscribe for notifications error=$error")});
  }

  static String _endpoint() =>
      "${env == "production" ? "api" : "api.$env"}.${region.substring(0, 2)}.bandyer.com";
}

enum PushType { voip, alert }
