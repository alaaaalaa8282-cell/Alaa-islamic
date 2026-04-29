import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'routes/routes.dart';
import 'src/core/notification/notification_service.dart';
import 'src/core/util/bloc/allah_names/allah_name_bloc.dart';
import 'src/core/util/bloc/database/database_bloc.dart';
import 'src/core/util/bloc/dua/dua_bloc.dart';
import 'src/core/util/bloc/juz/juz_bloc.dart';
import 'src/core/util/bloc/location/location_bloc.dart';
import 'src/core/util/bloc/notification/notification_bloc.dart';
import 'src/core/util/bloc/prayer_timing_bloc/timing_bloc.dart';
import 'src/core/util/bloc/prayer_time_config/prayer_time_config_bloc.dart';
import 'src/core/util/bloc/quran/quran_bloc.dart';
import 'src/core/util/bloc/quran_audio/quran_audio_bloc.dart';
import 'src/core/util/bloc/surah/surah_bloc.dart';
import 'src/core/util/bloc/tasbih/tasbih_bloc.dart';
import 'src/core/util/bloc/theme/theme_bloc.dart';
import 'src/core/util/bloc/time_format/time_format_bloc.dart';
import 'src/features/bottom_tab/bloc/tab/tab_bloc.dart';
import 'src/features/quran/bloc/quran_theme/quran_theme_bloc.dart';
import 'src/features/splash/screen/splash_screen.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // اتجاه عمودي فقط
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // اتجاه RTL للعربية
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // إشعارات
  await NotificationService().init();

  // تخزين Hydrated Bloc
HydratedBloc.storage = await HydratedStorage.build(
  storageDirectory: await getApplicationDocumentsDirectory(),
);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => TimeFormatBloc()),
        BlocProvider(create: (_) => NotificationBloc()),
        BlocProvider(create: (_) => QuranThemeBloc()),
        BlocProvider(create: (_) => TimingBloc()),
        BlocProvider(create: (_) => PrayerTimeConfigBloc()),
        BlocProvider(create: (_) => AllahNameBloc()),
        BlocProvider(create: (_) => DuaBloc()),
        BlocProvider(create: (_) => QuranBloc()),
        BlocProvider(create: (_) => QuranAudioBloc()),
        BlocProvider(create: (_) => SurahBloc()),
        BlocProvider(create: (_) => TasbihBloc()),
        BlocProvider(create: (_) => JuzBloc()),
        BlocProvider(create: (_) => DatabaseBloc()),
        BlocProvider(create: (_) => TabBloc()),
        BlocProvider(create: (_) => LocationBloc()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(414, 896),
        builder: (context, child) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'محمد عبد العظيم الطويل الإسلامي',
                debugShowCheckedModeBanner: false,
                theme: state.currentTheme,
                navigatorKey: appNavigatorKey,
                home: const SplashScreen(),
                onGenerateRoute: RouteGenerator.generateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
