import 'package:flutter/material.dart';
import 'package:owpet/src/screens/edit_grooming_screen.dart';
import 'package:owpet/src/services/grooming_service.dart';
import 'package:owpet/src/widgets/monitoring_item.dart';

class GroomingMonitoringScreen extends StatefulWidget {
  final String petId;

  GroomingMonitoringScreen({required this.petId});

  @override
  _GroomingMonitoringScreenState createState() =>
      _GroomingMonitoringScreenState();
}

class _GroomingMonitoringScreenState extends State<GroomingMonitoringScreen> {
  List<bool> _taskStatus = [];
  List<String> _tasks = [];
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      print('Loading tasks...');
      List<String> tasks =
          await GroomingProgressService().getTasks(widget.petId);
      List<bool> taskStatus = await GroomingProgressService()
          .getTaskProgress(widget.petId, _selectedDate);
      if (taskStatus.length != tasks.length) {
        taskStatus = List.filled(tasks.length, false);
      }
      setState(() {
        _tasks = tasks;
        _taskStatus = taskStatus;
      });
    } catch (e) {
      print('Error loading tasks: $e');
      // Or handle the error appropriately
    }
  }

  void _saveGroomingProgress(int index, bool value) async {
    try {
      // Update nilai progres pada indeks yang sesuai dalam _taskStatus
      setState(() {
        _taskStatus[index] = value;
      });

      // Simpan progres ke Firestore
      await GroomingProgressService()
          .updateTaskProgress(widget.petId, _selectedDate, index, value);
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _loadTasks();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(139, 128, 255, 1.0),
        centerTitle: true,
        title: const Text(
          'Grooming',
          style: TextStyle(fontSize: 32),
        ),
      ),
      body: _tasks.isNotEmpty && _taskStatus.isNotEmpty
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                        'Select Date: ${_selectedDate.toString().split(' ')[0]}'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    height: 350, // Tinggi tetap
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x000000).withOpacity(1),
                          offset: Offset(0, 7),
                          blurRadius: 15,
                          spreadRadius: -10,
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color.fromRGBO(
                          236, 234, 255, 1.0), // Latar belakang
                    ),
                    child: ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            MonitoringItem(
                              title: _tasks[index],
                              isChecked: _taskStatus[index],
                              onChanged: (status) {
                                _saveGroomingProgress(index, status);
                              },
                            ),
                            if (index < _tasks.length - 1)
                              const Divider(
                                color: Colors.black,
                                thickness: 1.0,
                                indent: 10,
                                endIndent: 10,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: Text('No tasks found. Please add tasks.'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditGroomingScreen(petId: widget.petId),
            ),
          ).then((_) {
            // Load tasks again after returning from EditGroomingScreen
            _loadTasks();
          });
        },
        tooltip: 'Edit Task',
        child: Icon(Icons.edit),
      ),
    );
  }
}
