//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <device_id/DeviceIdPlugin.h>
#import <device_info/DeviceInfoPlugin.h>
#import <flutter_keyboard_visibility/KeyboardVisibilityPlugin.h>
#import <flutter_webview_plugin/FlutterWebviewPlugin.h>
#import <geocoder/GeocoderPlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>
#import <unique_identifier/UniqueIdentifierPlugin.h>
#import <webview_flutter/WebViewFlutterPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [DeviceIdPlugin registerWithRegistrar:[registry registrarForPlugin:@"DeviceIdPlugin"]];
  [FLTDeviceInfoPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTDeviceInfoPlugin"]];
  [FLTKeyboardVisibilityPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTKeyboardVisibilityPlugin"]];
  [FlutterWebviewPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterWebviewPlugin"]];
  [GeocoderPlugin registerWithRegistrar:[registry registrarForPlugin:@"GeocoderPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [UniqueIdentifierPlugin registerWithRegistrar:[registry registrarForPlugin:@"UniqueIdentifierPlugin"]];
  [FLTWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTWebViewFlutterPlugin"]];
}

@end
