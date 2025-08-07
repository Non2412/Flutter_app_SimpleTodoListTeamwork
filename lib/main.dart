import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';
import 'theme.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService().init(); // ✅ ensure plugin is ready
  runApp(const MainApp());
}

class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _notification.initialize(settings);

    // ✅ ขอ permission สำหรับ Android 13+
    final androidPlugin = _notification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
  }

  Future<void> schedule(String title, DateTime time, int id) async {
    const androidDetails = AndroidNotificationDetails(
      'todo_channel',
      'ToDo Notification',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification'), // ตรวจว่ามี notification.mp3 ที่ res/raw
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
  uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
  androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
);
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'แจ้งเตือน',
      theme: myAppTheme,
      home: const LoginPage(), // ✅ เริ่มต้นที่หน้า Login
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoItem {
  String title;
  String? description;
  DateTime? dueDate;

  TodoItem({required this.title, this.description, this.dueDate});
}

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
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  void _addTodoItem() async {
    if (_titleController.text.trim().isEmpty) return;

    final newItem = TodoItem(
      title: _titleController.text.trim(),
      description: _descController.text.trim().isNotEmpty
          ? _descController.text.trim()
          : null,
      dueDate: _selectedDate,
    );

    setState(() => _todoItems.add(newItem));
    final index = _todoItems.length - 1;

    if (newItem.dueDate != null) {
      await NotificationService().schedule(newItem.title, newItem.dueDate!, index);
      if (mounted) {
        _scheduleSnackBar(newItem);
      }
    }

    if (mounted) {
      final navigator = Navigator.of(context); // ✅ เก็บ context ก่อน async
      navigator.pop();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ เพิ่มรายการสำเร็จ')),
          );
        }
      });
    }

    _titleController.clear();
    _descController.clear();
    _selectedDate = null;
  }

  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📝 เพิ่มรายการใหม่'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                  if (picked != null && mounted) {
                    setState(() => _selectedDate = picked);
                  }
                },
                icon: const Icon(Icons.alarm),
                label: const Text('ตั้งเวลาแจ้งเตือน'),
              ),
              if (_selectedDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '⏰ แจ้งเตือน: ${_dateFormat.format(_selectedDate!)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _titleController.clear();
              _descController.clear();
              _selectedDate = null;
              Navigator.of(context).pop();
            },
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

  void _scheduleSnackBar(TodoItem item) {
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

  // ฟังก์ชันสำหรับเลือกรูปภาพตามเวลา
  Widget _getTimeIcon(TodoItem item) {
    if (item.dueDate == null) {
      // ถ้าไม่มีเวลา ให้แสดงไอคอน checkbox เหมือนเดิม
      return const Icon(Icons.check_box_outline_blank, size: 28);
    }

    final hour = item.dueDate!.hour;
    
    // เวลา 6:00-17:59 แสดงดวงอาทิตย์
    // เวลา 18:00-5:59 แสดงดวงจันทร์
    if (hour >= 6 && hour <= 17) {
      // ใช้ Image.asset สำหรับรูปดวงอาทิตย์
      return Image.asset(
        'assets/images/sun.png',
        width: 32,
        height: 32,
        errorBuilder: (context, error, stackTrace) {
          // ถ้าโหลดรูปไม่ได้ ให้แสดงไอคอนแทน
          return const Icon(Icons.wb_sunny, size: 28, color: Colors.orange);
        },
      );
    } else {
      // ใช้ Image.asset สำหรับรูปดวงจันทร์
      return Image.asset(
        'assets/images/moon.png',
        width: 32,
        height: 32,
        errorBuilder: (context, error, stackTrace) {
          // ถ้าโหลดรูปไม่ได้ ให้แสดงไอคอนแทน
          return const Icon(Icons.nightlight_round, size: 28, color: Colors.indigo);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('📋 To-Do List'),
            centerTitle: true,
            actions: [
              // ✅ เพิ่มปุ่ม Logout
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
                tooltip: 'ออกจากระบบ',
              ),
            ],
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
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final item = _todoItems[index];
                    return Card(
                      color: Colors.white.withAlpha((0.50 * 255).toInt()),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: ListTile(
                        leading: _getTimeIcon(item), // ✅ ใช้ฟังก์ชันใหม่แทน
                        title: Text(
                          item.title,
                          style: const TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.description != null &&
                                item.description!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.notes,
                                        size: 16, color: Colors.black),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        item.description!,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (item.dueDate != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.alarm,
                                        size: 16, color: Colors.redAccent),
                                    const SizedBox(width: 4),
                                    Text(
                                      _dateFormat.format(item.dueDate!),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeTodoItem(index),
                        ),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showAddTodoDialog,
            label: const Text('เพิ่ม'),
            icon: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

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