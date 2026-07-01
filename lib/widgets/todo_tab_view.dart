import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wtd/controllers/todo_controller.dart';

class TodoTabView extends StatelessWidget {
  final ToDoController todoController;

  const TodoTabView({super.key, required this.todoController});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final query = todoController.searchQuery.value.trim().toLowerCase();
      final filteredList = todoController.todoList
          .where((todo) =>
              query.isEmpty ||
              (todo.todoText ?? '').toLowerCase().contains(query) ||
              (todo.description ?? '').toLowerCase().contains(query))
          .toList();

      return Stack(
        children: [
          Column(
            children: [
              // Search Field for Daily Tasks
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: todoController.searchController,
                  onChanged: (value) => todoController.searchQuery.value = value,
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white38 : Colors.black38,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: isDark ? Colors.white54 : Colors.grey.shade500,
                      size: 20,
                    ),
                    suffixIcon: Obx(() {
                      if (todoController.searchQuery.value.isNotEmpty) {
                        return IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: isDark ? Colors.white54 : Colors.grey.shade600,
                            size: 18,
                          ),
                          onPressed: () {
                            todoController.searchController.clear();
                            todoController.searchQuery.value = '';
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    filled: true,
                    fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.white30 : Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.white30 : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Expanded(
                child: filteredList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              todoController.searchQuery.value.isNotEmpty
                                  ? Icons.search_off_rounded
                                  : Icons.assignment_turned_in_outlined,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              todoController.searchQuery.value.isNotEmpty
                                  ? 'No matching tasks found!'
                                  : 'No tasks yet! Click the button below to add one.',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 4.0, bottom: 90.0),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final todo = filteredList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0.5,
                            color: Theme.of(context).cardColor,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => todoController.handleToDoChange(todo),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          todoController.handleToDoChange(todo),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: todo.isDone
                                              ? Theme.of(context).colorScheme.primary
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: todo.isDone
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : (isDark
                                                    ? Colors.white24
                                                    : Colors.grey.shade400),
                                            width: 2,
                                          ),
                                        ),
                                        child: todo.isDone
                                            ? const Icon(
                                                Icons.check,
                                                size: 16,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            todo.todoText ?? 'No Title',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              decoration: todo.isDone
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                              color: todo.isDone
                                                  ? Colors.grey
                                                  : (isDark
                                                      ? Colors.white
                                                      : Colors.black87),
                                            ),
                                          ),
                                          if (todo.description != null &&
                                              todo.description!.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              todo.description!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: todo.isDone
                                                    ? Colors.grey
                                                    : (isDark
                                                        ? Colors.white70
                                                        : Colors.black54),
                                                decoration: todo.isDone
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 6),
                                          Text(
                                            DateFormat('MMM dd, yyyy - hh:mm a')
                                                .format(todo.createdAt),
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: todo.isDone
                                                  ? Colors.grey.shade400
                                                  : (isDark
                                                      ? Colors.white38
                                                      : Colors.black38),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: Icon(
                                        Icons.more_vert_rounded,
                                        color: isDark
                                            ? Colors.white60
                                            : Colors.grey.shade600,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      onSelected: (String value) {
                                        if (value == 'edit') {
                                          Get.toNamed('/edit_todo', arguments: todo);
                                        } else if (value == 'delete') {
                                          _showDeleteConfirmationDialog(
                                              context, todoController, todo.id ?? '');
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit_outlined,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  size: 20),
                                              const SizedBox(width: 10),
                                              const Text('Edit',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete_outline_rounded,
                                                  color: Colors.red, size: 20),
                                              SizedBox(width: 10),
                                              Text('Delete',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.red)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: () => Get.toNamed('/add_todo'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add),
            ),
          ),
        ],
      );
    });
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, ToDoController todoController, String id) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      isDark ? Colors.red.withAlpha(50) : Colors.red.shade50,
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: isDark ? Colors.red.shade300 : Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Delete Task',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Are you sure you want to delete this task?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(
                            color:
                                isDark ? Colors.white24 : Colors.grey.shade300,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'No',
                          style: TextStyle(
                            color:
                                isDark ? Colors.white70 : Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          todoController.deleteTodo(id);
                          Navigator.pop(context);
                          Get.snackbar(
                            'Deleted',
                            'Task deleted successfully!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.shade400,
                            colorText: Colors.white,
                            margin: const EdgeInsets.all(16),
                            borderRadius: 12,
                            duration: const Duration(seconds: 2),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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
