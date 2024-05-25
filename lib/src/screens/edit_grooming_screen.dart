import 'package:flutter/material.dart';
import 'package:owpet/src/services/grooming_service.dart';

class EditGroomingScreen extends StatefulWidget {
  final String petId;

  const EditGroomingScreen({Key? key, required this.petId}) : super(key: key);

  @override
  _EditGroomingScreenState createState() => _EditGroomingScreenState();
}

class _EditGroomingScreenState extends State<EditGroomingScreen> {
  List<String> _tasks = [];
  // Controller untuk field input task baru
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _deleteTask(String task) async {
    try {
      await GroomingProgressService().deleteTask(widget.petId, task);
      _loadTasks();
    } catch (e) {
      print('Error deleting task: $e');
      // Atau lakukan penanganan kesalahan yang sesuai
    }
  }

  // Fungsi untuk menambahkan tugas
  Future<void> _addTask(String task) async {
    try {
      if (task.trim().isEmpty) {
        throw Exception("Task name cannot be empty");
      }

      // Tambahkan tugas baru ke Firestore
      await GroomingProgressService().addTask(widget.petId, task);
      // Bersihkan field input setelah tugas berhasil ditambahkan
      _taskController.clear();
      _loadTasks();
    } catch (e) {
      print('Error adding task: $e');
      // Tampilkan pesan kesalahan jika ada
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to add task. Please try again.'),
      ));
    }
  }

  Future<void> _loadTasks() async {
    try {
      print('Loading tasks...');
      List<String> tasks =
          await GroomingProgressService().getTasks(widget.petId);
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
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _taskController,
              decoration: const InputDecoration(
                hintText: 'Enter task name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Task name cannot be empty';
                }
                return null;
              },
            ),

            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Panggil fungsi untuk menambahkan tugas ketika tombol ditekan
                _addTask(_taskController.text.trim());
              },
              child: const Text('Add Task'),
            ),
            const SizedBox(height: 16.0),
            // Tampilkan daftar tugas yang sudah ada
            Expanded(
              child: _tasks.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_tasks[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteTask(_tasks[index]);
                            },
                          ),
                        );
                      },
                    )
                  : Container(), // Tambahkan Container jika tidak ada tugas
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
