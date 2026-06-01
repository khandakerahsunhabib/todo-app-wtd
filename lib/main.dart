import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.grey.shade100,
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
          elevation: 0,
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
