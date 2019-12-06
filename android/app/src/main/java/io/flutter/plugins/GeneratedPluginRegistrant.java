package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.notrait.deviceid.DeviceIdPlugin;
import io.flutter.plugins.deviceinfo.DeviceInfoPlugin;
import com.flutter.keyboardvisibility.KeyboardVisibilityPlugin;
import com.flutter_webview_plugin.FlutterWebviewPlugin;
import com.aloisdeniel.geocoder.GeocoderPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import altercode.xyz.uniqueidentifier.UniqueIdentifierPlugin;
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    DeviceIdPlugin.registerWith(registry.registrarFor("com.notrait.deviceid.DeviceIdPlugin"));
    DeviceInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.deviceinfo.DeviceInfoPlugin"));
    KeyboardVisibilityPlugin.registerWith(registry.registrarFor("com.flutter.keyboardvisibility.KeyboardVisibilityPlugin"));
    FlutterWebviewPlugin.registerWith(registry.registrarFor("com.flutter_webview_plugin.FlutterWebviewPlugin"));
    GeocoderPlugin.registerWith(registry.registrarFor("com.aloisdeniel.geocoder.GeocoderPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    UniqueIdentifierPlugin.registerWith(registry.registrarFor("altercode.xyz.uniqueidentifier.UniqueIdentifierPlugin"));
    WebViewFlutterPlugin.registerWith(registry.registrarFor("io.flutter.plugins.webviewflutter.WebViewFlutterPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
