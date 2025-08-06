import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple To-Do List',
      theme: myAppTheme,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

final ThemeData myAppTheme = ThemeData(
  primarySwatch: Colors.indigo,
  scaffoldBackgroundColor: Colors.grey[100],
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontSize: 16),
  ),
);

class TodoItem {
  String title;
  String? description;
  DateTime? dueDate;

  TodoItem({required this.title, this.description, this.dueDate});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TodoItem> _todoItems = [];
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  void _addTodoItem() {
    String newTitle = '';
    String newDescription = '';
    DateTime? newDueDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return AlertDialog(
              title: const Text('เพิ่มรายการใหม่'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'ชื่อรายการ'),
                      onChanged: (value) => newTitle = value,
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'รายละเอียด (ไม่บังคับ)'),
                      onChanged: (value) => newDescription = value,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            newDueDate == null
                                ? 'ยังไม่เลือกเวลา'
                                : _dateFormat.format(newDueDate!),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null && mounted) {
                                setInnerState(() {
                                  newDueDate = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  );
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('ยกเลิก'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: const Text('เพิ่ม'),
                  onPressed: () {
                    if (newTitle.isNotEmpty) {
                      setState(() {
                        _todoItems.add(
                          TodoItem(
                            title: newTitle,
                            description: newDescription.isNotEmpty
                                ? newDescription
                                : null,
                            dueDate: newDueDate,
                          ),
                        );
                      });
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 To-Do List'),
      ),
      body: _todoItems.isEmpty
          ? const Center(
              child: Text(
                'ยังไม่มีรายการ',
                style: TextStyle(color: Colors.black87),
              ),
            )
          : ListView.builder(
              itemCount: _todoItems.length,
              itemBuilder: (context, index) {
                final item = _todoItems[index];

                // ✅ เงื่อนไขแสดงไอคอน ดวงอาทิตย์ หรือ ดวงจันทร์
                String imageAsset = 'assets/images/sun.png';
                if (item.dueDate != null) {
                  final hour = item.dueDate!.hour;
                  if (hour >= 18 || hour < 6) {
                    imageAsset = 'assets/images/moon.png';
                  }
                }

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Image.asset(
                      imageAsset,
                      width: 40,
                      height: 40,
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                                    size: 16, color: Colors.black54),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item.description!,
                                    style: const TextStyle(fontSize: 14),
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
                                    size: 16, color: Colors.black54),
                                const SizedBox(width: 4),
                                Text(
                                  _dateFormat.format(item.dueDate!),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _removeTodoItem(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTodoItem,
        icon: const Icon(Icons.add),
        label: const Text('เพิ่ม'),
      ),
    );
  }
}
