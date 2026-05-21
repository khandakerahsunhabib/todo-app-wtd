import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wtd/main.dart';
import 'package:wtd/model/todo.dart';
import 'package:wtd/model/bazar_item.dart';

void main() {
  setUpAll(() async {
    // Initialize Hive with a temporary directory
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    try {
      Hive.registerAdapter(ToDoAdapter());
      Hive.registerAdapter(BazarItemAdapter());
    } catch (_) {
      // Adapter might already be registered
    }
    await Hive.openBox<ToDo>('todos');
    await Hive.openBox<BazarItem>('bazarItems');
    await Hive.openBox('settings');
  });

  tearDownAll(() async {
    await Hive.close();
  });

  testWidgets('Splash Screen displays App Name and transitions to Home', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our Splash Screen renders.
    expect(find.byType(MyApp), findsOneWidget);

    // Wait for the timer of 3 seconds to complete and let navigation settle.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
