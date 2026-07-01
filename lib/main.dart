import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wtd/constants/colors.dart';
import 'package:wtd/screens/about_us.dart';
import 'package:wtd/screens/home.dart';
import 'package:wtd/screens/privacy_policy.dart';
import 'package:wtd/screens/splash_screen.dart';
import 'package:wtd/screens/add_todo_screen.dart';
import 'package:wtd/screens/edit_todo_screen.dart';
import 'package:wtd/screens/add_expense_screen.dart';
import 'package:wtd/screens/edit_expense_screen.dart';
import 'model/todo.dart';
import 'model/expense_item.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter());
  Hive.registerAdapter(ExpenseItemAdapter());
  await Hive.openBox('settings');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String appName = "What To Do";
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    
    final settingsBox = Hive.box('settings');
    final isDark = settingsBox.get('isDarkMode', defaultValue: false) as bool;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'MYRIADPRO',
        colorScheme: const ColorScheme.light(
          primary: oceanMedium,
          secondary: oceanAccent,
          surface: lightCardBg,
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: lightScaffoldBg,
        cardColor: lightCardBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: oceanMedium,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontFamily: 'MYRIADPRO',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'MYRIADPRO'),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, fontFamily: 'MYRIADPRO'),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: oceanMedium,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'MYRIADPRO'),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: lightPrimaryText,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'MYRIADPRO'),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: oceanMedium, width: 2),
          ),
          labelStyle: const TextStyle(color: lightSecondaryText),
          hintStyle: const TextStyle(color: Colors.black38),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'MYRIADPRO', fontWeight: FontWeight.bold, color: lightPrimaryText),
          headlineMedium: TextStyle(fontFamily: 'MYRIADPRO', fontWeight: FontWeight.bold, color: lightPrimaryText),
          titleLarge: TextStyle(fontFamily: 'MYRIADPRO', fontWeight: FontWeight.bold, color: lightPrimaryText),
          titleMedium: TextStyle(fontFamily: 'MYRIADPRO', fontWeight: FontWeight.w600, color: lightPrimaryText),
          bodyLarge: TextStyle(fontFamily: 'MYRIADPRO', color: lightPrimaryText),
          bodyMedium: TextStyle(fontFamily: 'MYRIADPRO', color: lightSecondaryText),
          labelLarge: TextStyle(fontFamily: 'MYRIADPRO', fontWeight: FontWeight.bold, color: lightSecondaryText),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'MYRIADPRO',
        colorScheme: const ColorScheme.dark(
          primary: oceanAccent,
          secondary: oceanLightAccent,
          surface: darkCardBg,
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: darkScaffoldBg,
        cardColor: darkCardBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: darkCardBg,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontFamily: 'MYRIADPRO',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        tabBarTheme: const TabBarThemeData(
          indicatorColor: oceanAccent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'MYRIADPRO'),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, fontFamily: 'MYRIADPRO'),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: oceanAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'MYRIADPRO'),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: darkPrimaryText,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            side: const BorderSide(color: Colors.white24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'MYRIADPRO'),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkCardBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.white10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: oceanAccent, width: 2),
          ),
          labelStyle: const TextStyle(color: darkSecondaryText),
          hintStyle: const TextStyle(color: Colors.white30),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'MYRIADPRO', fontWeight: FontWeight.bold, color: darkPrimaryText),
          headlineMedium: TextStyle(fontFamily: 'MYRIADPRO', fontWeight: FontWeight.bold, color: darkPrimaryText),
          titleLarge: TextStyle(fontFamily: 'MYRIADPRO', fontWeight: FontWeight.bold, color: darkPrimaryText),
          titleMedium: TextStyle(fontFamily: 'MYRIADPRO', fontWeight: FontWeight.w600, color: darkPrimaryText),
          bodyLarge: TextStyle(fontFamily: 'MYRIADPRO', color: darkPrimaryText),
          bodyMedium: TextStyle(fontFamily: 'MYRIADPRO', color: darkSecondaryText),
          labelLarge: TextStyle(fontFamily: 'MYRIADPRO', fontWeight: FontWeight.bold, color: darkSecondaryText),
        ),
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      getPages: [
        GetPage(
            name: '/',
            page: () =>
                const SplashScreen()), // Keep SplashScreen as initial route
        GetPage(name: '/home', page: () => const Home()),
        GetPage(name: '/about_us', page: () => const AboutUs()),
        GetPage(name: '/privacy_policy', page: () => const PrivacyPolicy()),
        GetPage(name: '/add_todo', page: () => const AddTodoScreen()),
        GetPage(name: '/edit_todo', page: () => const EditTodoScreen()),
        GetPage(name: '/add_expense_item', page: () => const AddExpenseScreen()),
        GetPage(name: '/edit_expense_item', page: () => const EditExpenseScreen()),
      ],
    );
  }
}
