import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';
import 'core/localization/locale_service.dart';
import 'features/splash/screens/splash_screen.dart';

import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'features/notifications/controllers/notification_controller.dart';

void main() {
  runApp(const TmsApp());
}

class TmsApp extends StatefulWidget {
  const TmsApp({super.key});

  @override
  State<TmsApp> createState() => _TmsAppState();
}

class _TmsAppState extends State<TmsApp> {
  final ThemeService _themeService = ThemeService.instance;
  final LocaleService _localeService = LocaleService.instance;

  @override
  void initState() {
    super.initState();

    _themeService.addListener(_themeChanged);
    _localeService.addListener(_themeChanged);
  }

  @override
  void dispose() {
    _themeService.removeListener(_themeChanged);
    _localeService.removeListener(_themeChanged);
    super.dispose();
  }

  void _themeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotificationController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        locale: _localeService.locale,

        supportedLocales: AppLocalizations.supportedLocales,

        localizationsDelegates: AppLocalizations.localizationsDelegates,

        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _themeService.themeMode,

        home: const SplashScreen(),
      ),
    );
  }
}