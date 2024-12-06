![Kaleyra Logo](https://static.bandyer.com/corporate/iOS/logo/kaleyra-logo.png)

# Kaleyra Video Flutter Plugin

[![pub version](https://img.shields.io/pub/v/kaleyra_video_flutter_plugin)][PubLink]

## How to run the example

Execute the following commands from the repository root folder

```shell
cd example
# nano .env use your own keys
flutter pub get
cd ios
pod install
```

## How to install the plugin

Open the **terminal** in your Flutter-App folder and run the following commands

```shell
flutter pub add kaleyra_video_flutter_plugin
```

## Minimum requirements
- Android 21+, gradle 8+, kotlin 1.9+
- iOS 15+, swift 5.x

## How to remove the plugin

```shell
flutter pub remove kaleyra_video_flutter_plugin
```

## How to use the Kaleyra Video plugin in your Flutter app

You can refer to the Kaleyra Video plugin in your Flutter app via

```dart
KaleyraVideo
```

## Plugin setup

The first thing you need to do is to configure the plugin specifying your keys and your options.

##### Configure params

```dart
var configuration = Configuration(
      appID: "mAppId_xxx", // your mobile appId
      environment: Environment.sandbox(), // production()
      region: Region.europe(), // india(), us()
      logEnabled: true, // enable the logger
      tools: Tools(
          // by default no tools will be set
          chat: ChatToolConfiguration(
              audioCallOption: AudioCallOptions(
                  type: AudioCallType.audio, // audio or audioUpgradable
                  recordingType:
                      RecordingType.none), // none, manual or automatic
              videoCallOption: CallOptions(
                  recordingType:
                      RecordingType.none)), // none, manual or automatic
          feedback: true,
          fileShare: true,
          whiteboard: true,
          screenShare: ScreenShareToolConfiguration(
              inApp: true, // screenshare only the app
              wholeDevice: true)), // screenshare the whole device
      // optional you can set one or more of the following capabilities, by default callkit is enabled
      iosConfig: IosConfiguration(
          voipHandlingStrategy: VoipHandlingStrategy.automatic, // implement to be able to receive VoIPs
          callkit: CallKitConfiguration(
              enabled: true, // enable CallKit on iOS 10+
              appIconName: "logo_transparent", // optional but recommended
              ringtoneSoundName: "custom_ringtone.mp3"))); // optional

var kaleyraVideo = await KaleyraVideo.configure(configuration);
```

If screenShare.wholeDevice is set to true look [here][BroadcastAchor] for the required additional setup.

## Plugin listen for errors/events

To listen for events and/or errors register
Check the documentation [here][EventsDoc] for a complete list.

Example:

```dart
kaleyraVideo.events.onCallModuleStatusChanged = (status) => {};
```

## iOS - VoIP Notifications

### Setup required for VoIP notifications

If you desire to use VoIP notifications on iOS platform as first thing you should configure kaleyraVideo passing a config object as follow:

```dart
var configuration = Configuration(
      [...]
      iosConfig: IosConfiguration(
          voipHandlingStrategy: VoipHandlingStrategy.automatic, 
          [...]

var kaleyraVideo = await KaleyraVideo.configure(configuration);
```

The iOS project requires a little setup for use VoIP notifications. [Here][iOSProjectSetup] you can find a description of how the project should be configured.

### Listening for VoIP push token

In order to get your device push token, you must listen for the **KaleyraVideo.events.iOSVoipPushTokenUpdated** event registering a callback as follows:

```dart
// The token is received in this listener only after calling kaleyraVideo.connect(_)
kaleyraVideo.events.oniOSVoipPushTokenUpdated = (token) => {
    // register the VoIP push token on your server
};
```

**Warning:** Make sure this listener is attached before calling kaleyraVideo.connect(_), otherwise the event reporting the device token could be missed.

The token provided in the callback is the **string** representation of your device token.
Here's an example of a device token: **dec105f879924349fd2fa9aa8bb8b70431d5f41d57bfa8e31a5d80a629774fd9**

### VoIP notification payload

[Here][iOSVoIPPayload] you can find an example of how your VoIP notifications payload should be structured.

## Plugin connect

To connect the plugin to the Kaleyra Video system you will need to provide a Session object.
The session needs a userID and a function returning a Future<String> with the access token for that user

> [!IMPORTANT]
> - The *userID* should aready exists in our service. Your backend needs to create it by invoking this api [create_user](https://developers.kaleyra.io/reference/video-v2-user-post)
> - The *accessToken* should be generated from your backend by invoking this api [get_credentials](https://developers.kaleyra.io/reference/video-v2-sdk-post). Be aware that it expires. The callback will be called multiple times every time a new token is needed to refresh the user session.

```dart
kaleyraVideo.connect(Session("usr_xxx", (userId) async {
    // get token for user_xxx
    return "jwt_xxx";
}));
```

## Start a call

To make a call you need to specify some params.

##### Start call params

```dart
kaleyraVideo.startCall(CreateCallOptions(
    callees: ["usr_yyy", "usr_zzz"], //  an array of user ids of the users you want to call
    callType: CallType.audioVideo, // audio, audioUpgradable or audioVideo - the type of the call you want to start
    recordingType: RecordingType.none)); // none, manual or automatic
```

## Start a chat

To make a chat you need to specify some params.

##### Start chat params

```dart
kaleyraVideo.startChat("usr_yyy");// the user_id of the user you want to create a chat with
```

## Set user details

This method will allow you to set your user details DB from which the sdk will read when needed to show the information.
> Be sure to have this always up to date, otherwise if an incoming call is received and the user is missing in this set the user ids will be printed on the UI.

```dart
kaleyraVideo.addUsersDetails([
    UserDetails(userID: "usr_yyy", name: "User1Name", imageUrl: "https://www.example.com/user1image.png"),
    UserDetails(userID: "usr_zzz", name: "User2Name", imageUrl: "https://www.example.com/user2image.png"),
]);
```

## Remove all user details

This method will allow you to remove all the user info from the local app DB.

```dart
kaleyraVideo.removeUsersDetails();
```

## Remove all the cached info in preferences and DBs

```dart
kaleyraVideo.clearUserCache();
```

## Android change display mode

This method is useful for use-cases where you need to show a prompt and don't want it to be invalidated by the call going into pip.
For example: if you wish to show fingerprint dialog you should first put the current call in background, execute the fingerprint validation and then put back the call in foreground.

```dart
kaleyraVideo.setDisplayModeForCurrentCall(CallDisplayMode.background); // .foreground, .foregroundPictureInPicture or .background
```

## iOS Broadcast Screen sharing

To enable whole device screen share is required and additional setup.
Open the iOS Xcode project of your Flutter application and follow [this guide][BroadcastSceenSharing].
After completing the procedure described in the guide above you need to add to your Podfile this lines:

```ruby
target 'BroadcastExtension' do
  use_frameworks!

  pod 'BandyerBroadcastExtension'
end
```

Furthermore, to allow a correct configuration of the SDK it is necessary to create a file called "KaleyraVideoConfig.plist" and add it to the same target of the application. This file must have the following content:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
 <key>broadcast</key>
 <dict>
  <key>appGroupIdentifier</key>
  <string><!-- PUT HERE THE BUNDLE ID OF YOUR APP GROUP --></string>
  <key>extensionBundleIdentifier</key>
  <string><!-- PUT HERE THE BUNDLE ID OF YOUR BROADCAST EXTENSION --></string>
 </dict>
</dict>
</plist>
```

## iOS Notifications

The module supports **on_call_incoming** notification.
You will need to set the **voipHandlingStrategy** and subscribe to **iOSVoipPushTokenUpdated** event to receive the voip token to use on your backend to notify the plugin.

## Android Notifications
When recevied a **on_call_incoming** or **on_message_sent** notification you just need to configure and connect the plugin and it will automatically show the notification.

## Proguard 
```groovy
# Bandyer now Kaleyra proprietary SDK
-keep class com.bandyer.** { *; }
-keep interface com.bandyer.** { *; }
-keep enum com.bandyer.** { *; }

-keep class com.kaleyra.** { *; }
-keep interface com.kaleyra.** { *; }
-keep enum com.kaleyra.** { *; }
```

## Documentation

The API documentation is available on the link:
[https://pub.dev/documentation/kaleyra_video_flutter_plugin/latest/][Doc]

[PubLink]: https://pub.dev/packages/kaleyra_video_flutter_plugin
[BroadcastAchor]: #ios-broadcast-screen-sharing
[BroadcastSceenSharing]: https://github.com/Bandyer/Bandyer-iOS-SDK/wiki/Screen-sharing#broadcast-screen-sharing
[iOSProjectSetup]: https://github.com/Bandyer/Bandyer-iOS-SDK/wiki/VOIP-notifications#project-setup
[iOSVoIPPayload]: https://github.com/Bandyer/Bandyer-iOS-SDK/wiki/VOIP-notifications#notification-payload-key-path
[EventsDoc]: https://pub.dev/documentation/kaleyra_video_flutter_plugin/latest/kaleyra_video_flutter_plugin/Events-class.html
[Doc]: https://pub.dev/documentation/kaleyra_video_flutter_plugin/latest/
