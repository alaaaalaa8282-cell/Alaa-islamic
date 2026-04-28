import 'package:flutter/material.dart';

import '../src/core/error/exceptions.dart';
import '../src/features/allah_name/screen/allah_name_screen.dart';
import '../src/features/bottom_tab/screen/tab_screen.dart';
import '../src/features/dua/screen/dua_screen.dart';
import '../src/features/error/screen/database_error_screen.dart';
import '../src/features/live_tv/screen/live_tv_screen.dart';
import '../src/features/azkar/screen/azkar_screen.dart';
import '../src/features/permission/screen/location_permission_screen.dart';
import '../src/features/permission/screen/notification_permission_screen.dart';
import '../src/features/prayer_timing/screen/prayer_timing_screen.dart';
import '../src/features/prayer_timing/screen/prayer_time_settings_screen.dart';
import '../src/features/qibla/screen/qibla_screen.dart';
import '../src/features/quran/screen/option_screen.dart';
import '../src/features/quran/screen/quran_screen.dart';
import '../src/features/setting/screen/thankyou_screen.dart';
import '../src/features/splash/screen/splash_screen.dart';
import '../src/features/tasbih/screen/tasbih_screen.dart';
import '../src/features/adhan_popup/adhan_popup_screen.dart';
import '../src/features/sound_settings/sound_settings_screen.dart';

class RouteGenerator {
  static const String splash = '/';
  static const String tabScreen = '/tab';
  static const String prayerTimingPage = '/prayer_timing';
  static const String prayerTimeSettings = '/prayer_time_settings';
  static const String qibla = '/qibla';
  static const String thankyou = '/thank_you';
  static const String databaseError = '/database_error';
  static const String allahName = '/allah_name';
  static const String tasbih = '/tasbih';
  static const String dua = '/dua';
  static const String quran = '/quran';
  static const String quranSettings = '/quran_settings';
  static const String liveTv = '/live_tv';
  static const String azkar = '/azkar';
  static const String locationPermission = '/location_permission';
  static const String notificationPermission = '/notification_permission';
  static const String adhanPopup = '/adhan_popup';
  static const String soundSettings = '/sound_settings';

  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case tabScreen:
        return MaterialPageRoute(builder: (_) => const TabScreen());
      case prayerTimingPage:
        return MaterialPageRoute(builder: (_) => const PrayerTimingScreen());
      case prayerTimeSettings:
        return MaterialPageRoute(builder: (_) => const PrayerTimeSettingsScreen());
      case qibla:
        return MaterialPageRoute(builder: (_) => const QiblaScreen());
      case thankyou:
        return MaterialPageRoute(builder: (_) => const ThankyouScreen());
      case databaseError:
        return MaterialPageRoute(builder: (_) => const DatabaseErrorScreen());
      case allahName:
        return MaterialPageRoute(builder: (_) => const AllahNameScreen());
      case tasbih:
        return MaterialPageRoute(builder: (_) => const TasbihScreen());
      case dua:
        return MaterialPageRoute(builder: (_) => const DuaScreen());
      case quran:
        return MaterialPageRoute(builder: (_) => const QuranScreen());
      case quranSettings:
        return MaterialPageRoute(builder: (_) => const OptionScreen());
      case liveTv:
        return MaterialPageRoute(builder: (_) => const LiveTvScreen());
      case azkar:
        return MaterialPageRoute(builder: (_) => const AzkarScreen());
      case locationPermission:
        return MaterialPageRoute(builder: (_) => const LocationPermissionScreen());
      case notificationPermission:
        return MaterialPageRoute(builder: (_) => const NotificationPermissionScreen());
      case adhanPopup:
        final args = settings.arguments as Map<String, String>?;
        return MaterialPageRoute(
          builder: (_) => AdhanPopupScreen(
            prayer: args?['prayer'] ?? 'fajr',
            prayerTime: args?['prayerTime'] ?? '',
          ),
          fullscreenDialog: true,
        );
      case soundSettings:
        return MaterialPageRoute(builder: (_) => const SoundSettingsScreen());
      default:
        throw RouteException('Route not found');
    }
  }
}
