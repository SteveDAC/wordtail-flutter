import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'models/board.dart';

import 'screens/game_screen.dart';
import 'screens/about_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Board()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: FlexThemeData.light(scheme: FlexScheme.amber),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.amber),
      themeMode: ThemeMode.dark,
      routes: {
        '/': (context) => const GameScreen(),
        AboutScreen.routeName: (context) => const AboutScreen(),
      },
    );
  }
}
