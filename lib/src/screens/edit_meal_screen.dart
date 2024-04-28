import 'package:flutter/material.dart';
import 'package:owpet/src/services/meal_service.dart';

class EditMealScreen extends StatefulWidget {
  final String petId;

  const EditMealScreen({Key? key, required this.petId}) : super(key: key);

  @override
  _EditMealScreenState createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  List<String> _tasks = [];
  // Controller untuk field input task baru
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Fungsi untuk menambahkan tugas
  Future<void> _addTask(String task) async {
    try {
      // Tambahkan tugas baru ke Firestore
      await MealProgressService().addTask(widget.petId, task);
      // Bersihkan field input setelah tugas berhasil ditambahkan
      _taskController.clear();
      _loadTasks();
    } catch (e) {
      print('Error adding task: $e');
      // Tampilkan pesan kesalahan jika ada
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add task. Please try again.'),
      ));
    }
  }

  Future<void> _loadTasks() async {
    try {
      print('Loading tasks...');
      List<String> tasks = await MealProgressService().getTasks(widget.petId);
      setState(() {
        _tasks = tasks;
      });
      print(_tasks);
    } catch (e) {
      print('Error loading tasks: $e');
      // Atau lakukan penanganan kesalahan yang sesuai
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                hintText: 'Enter task name',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Panggil fungsi untuk menambahkan tugas ketika tombol ditekan
                _addTask(_taskController.text.trim());
              },
              child: Text('Add Task'),
            ),
            SizedBox(height: 16.0),
            // Tampilkan daftar tugas yang sudah ada
            if (_tasks.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tasks[index]),
                  );
                },
              ),
            
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Pastikan untuk membersihkan controller ketika widget dihapus
    _taskController.dispose();
    super.dispose();
  }
}
