import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv_app/pages/opening_animation.dart';
import 'package:tv_app/providers.dart/loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => Loader(),
      lazy: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            textTheme: TextTheme(
              titleLarge: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9)),
              bodyMedium: const TextStyle(fontSize: 18, color: Colors.white70),
              bodySmall: const TextStyle(fontSize: 13, color: Colors.white70),
              titleMedium: const TextStyle(fontSize: 19),
              titleSmall: const TextStyle(fontSize: 15),
            ),
            chipTheme: ChipThemeData(
              backgroundColor: Colors.white.withOpacity(0.9),
              selectedColor: Colors.amber,
              disabledColor: Colors.white70,
            ),
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.white70,
              // primary: Colors.white70,
            ),
            scaffoldBackgroundColor: const Color.fromRGBO(24, 25, 32, 1),
            drawerTheme: const DrawerThemeData(
              backgroundColor: Color.fromRGBO(24, 25, 32, 1),
            )),
        home: const OpeningAnimationsPage(),
      ),
    );
  }
}

