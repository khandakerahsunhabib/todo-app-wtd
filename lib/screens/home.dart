import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wtd/controllers/todo_controller.dart';
import 'package:wtd/controllers/expense_controller.dart';
import 'package:wtd/widgets/app_widgets.dart';
import 'package:wtd/widgets/todo_tab_view.dart';
import 'package:wtd/widgets/expense_tab_view.dart';
import 'package:wtd/widgets/settings_report_dialogs.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final ToDoController todoController = Get.put(ToDoController());
    final ExpenseController expenseController = Get.put(ExpenseController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final shouldExit = await _showExitConfirmationDialog(context);
        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            elevation: 0,
            title: const Text('Task Tracker'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => SettingsReportDialogs.showSettingsBottomSheet(context),
              ),
            ],
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  text: 'Daily Task',
                ),
                Tab(
                  text: 'Expense Tracker',
                ),
              ],
            ),
          ),
          drawer: myDrawer('What To Do', 'App version: 1.0.0', context),
          body: TabBarView(
            children: [
              TodoTabView(todoController: todoController),
              ExpenseTabView(expenseController: expenseController),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor:
                      isDark ? Colors.red.withAlpha(50) : Colors.red.shade50,
                  child: Icon(
                    Icons.exit_to_app_rounded,
                    color: isDark ? Colors.red.shade300 : Colors.red,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Exit App',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure want to exit app?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color:
                                isDark ? Colors.white24 : Colors.grey.shade300,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                            color:
                                isDark ? Colors.white70 : Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
