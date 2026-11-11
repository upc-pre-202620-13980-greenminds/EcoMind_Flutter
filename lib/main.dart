import 'package:ecomind_parents/core/service_locator.dart';
import 'package:ecomind_parents/core/theme.dart';
import 'package:ecomind_parents/features/main/main_page.dart';
import 'package:ecomind_parents/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

void main() {
  setupDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: const MaterialTheme(ecoMindTextTheme).light(),
      darkTheme: const MaterialTheme(ecoMindTextTheme).dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}
