import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

class AppTemplate extends StatelessWidget {
  const AppTemplate({
    super.key,
    required this.widget,
    this.initialRoute,
    this.isTestMode = false,
  });

  final String? initialRoute;
  final bool isTestMode;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    // return ModelBinding(
    //   initialModel: GalleryOptions(
    //     themeMode: ThemeMode.system,
    //     textScaleFactor: systemTextScaleFactorOption,
    //     customTextDirection: CustomTextDirection.localeBased,
    //     locale: null,
    //     timeDilation: timeDilation,
    //     platform: defaultTargetPlatform,
    //     isTestMode: isTestMode,
    //   ),
    //   child: Builder(
    //     builder: (context) {
    //       final options = GalleryOptions.of(context);
    //       final hasHinge = MediaQuery.of(context).hinge?.bounds != null;
    //       debugPrint('-->initialRoute: $initialRoute');
    return MaterialApp(
      restorationScopeId: 'rootGallery',
      title: 'Flutter Gallery',
      debugShowCheckedModeBanner: true,
      // themeMode: options.themeMode,
      // theme: GalleryThemeData.lightThemeData.copyWith(
      //   platform: options.platform,
      // ),
      // darkTheme: GalleryThemeData.darkThemeData.copyWith(
      //   platform: options.platform,
      // ),
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        LocaleNamesLocalizationsDelegate(),
      ],
      initialRoute: initialRoute,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale.fromSubtags(languageCode: 'zh'),
      localeListResolutionCallback: (locales, supportedLocales) {
        // deviceLocale = locales?.first;
        return basicLocaleListResolution(locales, supportedLocales);
      },
      // onGenerateRoute: (settings) => RouteConfiguration.onGenerateRoute(settings, hasHinge),
      onUnknownRoute: (settings) {
        debugPrint('-->onUnknownRoute: ${settings.name}\t${settings.arguments}\n${settings.toString()}');
        return null;
      },
      home: widget,
    );
    //       },
    //     ),
    //   );
  }
}
