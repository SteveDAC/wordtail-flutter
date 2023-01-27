import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

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
      // theme: FlexThemeData.light(scheme: FlexScheme.amber),
      // darkTheme: FlexThemeData.dark(scheme: FlexScheme.amber),

      theme: ThemeData(
        // Still working on a proper light theme that'll look good.
        // Not there yet.
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.orange,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.orange,
          primary: Colors.orange,
          secondary: Colors.pink,
          background: const Color.fromRGBO(20, 20, 20, 1),
        ),
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: const Color.fromRGBO(20, 20, 20, 1),
        ),
        cardTheme: CardTheme.of(context).copyWith(
          surfaceTintColor: const Color.fromRGBO(10, 20, 50, 1),
        ),
      ),
      themeMode: ThemeMode.dark,
      routes: {
        '/': (context) => const GameScreen(),
        AboutScreen.routeName: (context) => const AboutScreen(),
      },
    );
  }
}
