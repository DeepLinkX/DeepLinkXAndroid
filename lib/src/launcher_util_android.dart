import 'package:android_intent_plus/android_intent.dart';
import 'package:appcheck/appcheck.dart';
import 'package:deeplink_x_platform_interface/deeplink_x_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

/// A utility class for launching and checking Android applications.
///
/// This class extends [LauncherUtilPlatform] to provide Android-specific
/// functionality for:
/// - Checking if Android apps are installed using package names
/// - Launching Android apps using package names
/// - Launching Android intents with custom configurations
///
/// Example:
/// ```dart
/// final launcher = LauncherUtilAndroid();
/// await launcher.isAndroidAppInstalled('com.example.app');
/// await launcher.launchAndroidApp('com.example.app');
/// ```
class LauncherUtilAndroid extends LauncherUtilPlatform {
  /// Creates a new [LauncherUtilAndroid] instance.
  ///
  /// Parameters:
  /// - [appCheck]: Optional custom AppCheck instance for testing
  LauncherUtilAndroid({
    @visibleForTesting final AppCheck? appCheck,
  }) : _appCheck = appCheck ?? AppCheck();

  /// Registers this class as the default instance of [LauncherUtilAndroid].
  static void registerWith() {
    LauncherUtilPlatform.instance = LauncherUtilAndroid();
  }

  /// AppCheck instance used for checking and launching apps
  final AppCheck _appCheck;

  @override
  Future<bool> isAppInstalledByPackageName(final String packageName) async => _appCheck.isAppInstalled(packageName);

  @override
  Future<bool> launchAppByPackageName(final String packageName) async {
    await _appCheck.launchApp(packageName);
    return true;
  }

  @override
  Future<void> launchIntent(final AndroidIntentOption options) async => AndroidIntent(
        action: options.action,
        flags: options.flags,
        category: options.category,
        data: options.data,
        arguments: options.arguments,
        arrayArguments: options.arrayArguments,
        package: options.package,
        componentName: options.componentName,
        type: options.type,
      ).launch();

  @override
  Future<bool> launchUrl(final Uri uri) async =>
      url_launcher.launchUrl(uri, mode: url_launcher.LaunchMode.externalApplication);

  @override
  Future<bool> launchAppByScheme(final String scheme) async {
    throw UnimplementedError('launchApp() not implemented on this platform.');
  }

  @override
  Future<bool> isAppInstalledByScheme(final String scheme) async {
    throw UnimplementedError('isAppInstalled() not implemented on this platform.');
  }
}
