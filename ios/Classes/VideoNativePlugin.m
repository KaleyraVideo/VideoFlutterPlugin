// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

#import "VideoNativePlugin.h"
#if __has_include(<kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin-Swift.h>)
#import <kaleyra_video_flutter_plugin/kaleyra_video_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "kaleyra_video_flutter_plugin-Swift.h"
#endif

@implementation VideoNativePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVideoNativePlugin registerWithRegistrar:registrar];
}
@end
