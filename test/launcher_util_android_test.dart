import 'package:android_intent_plus/android_intent.dart';
import 'package:appcheck/appcheck.dart';
import 'package:deeplink_x_android/deeplink_x_android.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppCheck extends Mock implements AppCheck {}

class MockAndroidIntent extends Mock implements AndroidIntent {}

void main() {
  late MockAppCheck mockAppCheck;
  late LauncherUtilAndroid launcherUtil;

  setUp(() {
    mockAppCheck = MockAppCheck();
    launcherUtil = LauncherUtilAndroid(appCheck: mockAppCheck);
  });

  group('LauncherUtil', () {
    group('mockAppCheck integration', () {
      test('isAndroidAppInstalled delegates to AppCheck', () async {
        when(() => mockAppCheck.isAppInstalled('com.example.app')).thenAnswer((final _) async => true);
        final result = await launcherUtil.isAndroidAppInstalled('com.example.app');
        expect(result, isTrue);
        verify(() => mockAppCheck.isAppInstalled('com.example.app')).called(1);
      });

      test('launchAndroidApp delegates to AppCheck', () async {
        when(() => mockAppCheck.launchApp('com.example.app')).thenAnswer((final _) async {});
        await launcherUtil.launchAndroidApp('com.example.app');
        verify(() => mockAppCheck.launchApp('com.example.app')).called(1);
      });
    });
  });

  // Tests for unimplemented methods
  group('unimplemented methods', () {
    test('launchApp throws UnimplementedError', () {
      expect(
        () => launcherUtil.launchApp('myapp://'),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('isAppInstalled throws UnimplementedError', () {
      expect(
        () => launcherUtil.isAppInstalled('myapp://'),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  // TODO: UnitTests for url_launcher related methods
  // TODO: UnitTests for android_intent_plus related methods
}
