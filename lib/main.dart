import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  await NotificationService().init();

  runApp(const MainApp());
}

//
// ---------------- NOTIFICATION SERVICE ----------------
//
class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notification.initialize(settings);
  }

  Future<void> schedule(String title, DateTime time, int id) async {
    const androidDetails = AndroidNotificationDetails(
      'todo_channel',
      'ToDo Notification',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification'),
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      sound: 'notification.wav',
    );

    await _notification.zonedSchedule(
      id,
      '⏰ ถึงเวลาแล้ว!',
      title,
      tz.TZDateTime.from(time, tz.local),
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

//
// ---------------- MAIN APP ----------------
//
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

//
// ---------------- MODEL ----------------
//
class TodoItem {
  String title;
  String? description;
  DateTime? dueDate;

  TodoItem({required this.title, this.description, this.dueDate});
}

//
// ---------------- MAIN SCREEN ----------------
//
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todoItems = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime? _selectedDate;

  void _addTodoItem() {
    final newItem = TodoItem(
      title: _titleController.text,
      description: _descController.text.isNotEmpty
          ? _descController.text
          : null,
      dueDate: _selectedDate,
    );

    setState(() {
      _todoItems.add(newItem);
    });

    final index = _todoItems.length - 1;

    if (newItem.dueDate != null) {
      NotificationService().schedule(newItem.title, newItem.dueDate!, index);
      _scheduleSnackBar(context, newItem);
    }

    Navigator.of(context).pop();

    Future.delayed(const Duration(milliseconds: 300), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ เพิ่มรายการสำเร็จ')),
      );
    });

    _titleController.clear();
    _descController.clear();
    _selectedDate = null;
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📝 เพิ่มรายการใหม่'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'หัวข้อ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'รายละเอียด (ถ้ามี)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  final picked = await showDateTimePicker(context);
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                icon: const Icon(Icons.alarm),
                label: const Text('ตั้งเวลาแจ้งเตือน'),
              ),
              if (_selectedDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '⏰ แจ้งเตือน: ${_selectedDate.toString()}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: _addTodoItem,
            child: const Text('เพิ่มรายการ'),
          ),
        ],
      ),
    );
  }

  void _scheduleSnackBar(BuildContext context, TodoItem item) {
    if (item.dueDate == null) return;

    final now = DateTime.now();
    final delay = item.dueDate!.difference(now);

    if (delay.isNegative) return;

    Timer(delay, () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('🔔 ถึงเวลา: "${item.title}"')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📋 To-Do List'),
        centerTitle: true,
      ),
      body: _todoItems.isEmpty
          ? const Center(
              child: Text(
                'ยังไม่มีรายการ',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.separated(
              itemCount: _todoItems.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final item = _todoItems[index];
                return ListTile(
                  leading: const Icon(Icons.check_box_outline_blank),
                  title: Text(item.title),
                  subtitle: item.dueDate != null
                      ? Text('⏰ ${item.dueDate}')
                      : item.description != null
                          ? Text(item.description!)
                          : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeTodoItem(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTodoDialog,
        label: const Text('เพิ่ม'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

//
// ---------------- DATETIME PICKER ----------------
//
Future<DateTime?> showDateTimePicker(BuildContext context) async {
  final date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );
  if (date == null) return null;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (time == null) return null;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
