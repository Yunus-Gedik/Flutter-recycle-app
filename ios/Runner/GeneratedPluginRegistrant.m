//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<export_video_frame/ExportVideoFramePlugin.h>)
#import <export_video_frame/ExportVideoFramePlugin.h>
#else
@import export_video_frame;
#endif

#if __has_include(<flutter_video_info/FlutterVideoInfoPlugin.h>)
#import <flutter_video_info/FlutterVideoInfoPlugin.h>
#else
@import flutter_video_info;
#endif

#if __has_include(<image_picker/FLTImagePickerPlugin.h>)
#import <image_picker/FLTImagePickerPlugin.h>
#else
@import image_picker;
#endif

#if __has_include(<path_provider/FLTPathProviderPlugin.h>)
#import <path_provider/FLTPathProviderPlugin.h>
#else
@import path_provider;
#endif

#if __has_include(<video_player/FLTVideoPlayerPlugin.h>)
#import <video_player/FLTVideoPlayerPlugin.h>
#else
@import video_player;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [ExportVideoFramePlugin registerWithRegistrar:[registry registrarForPlugin:@"ExportVideoFramePlugin"]];
  [FlutterVideoInfoPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterVideoInfoPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [FLTVideoPlayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTVideoPlayerPlugin"]];
}

@end
