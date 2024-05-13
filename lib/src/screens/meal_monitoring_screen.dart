// import 'package:flutter/material.dart';
// import 'package:owpet/src/screens/edit_meal_screen.dart';
// import 'package:owpet/src/services/meal_service.dart';
// import 'package:owpet/src/widgets/monitoring_item.dart';

// class MealMonitoringScreen extends StatefulWidget {
//   final String petId;

//   MealMonitoringScreen({required this.petId});

//   @override
//   _MealMonitoringScreenState createState() => _MealMonitoringScreenState();
// }

// class _MealMonitoringScreenState extends State<MealMonitoringScreen> {
//   List<bool> _taskStatus = [];
//   List<String> _tasks = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Meal Monitoring'),
//       ),
//       body: _tasks.isNotEmpty && _taskStatus.isNotEmpty
//           ? Column(
//               children: [
//                 // ElevatedButton(
//                 //   onPressed: () => _selectDate(context),
//                 //   child: Text(
//                 //       'Select Date: ${_selectedDate.toString().split(' ')[0]}'),
//                 // ),
//                 // Expanded(
//                 //   child: ListView.builder(
//                 //     itemCount: _tasks.length,
//                 //     itemBuilder: (context, index) {
//                 //       return MonitoringItem(
//                 //         title: _tasks[index],
//                 //         isChecked: _taskStatus[index],
//                 //         onChanged: (status) {
//                 //           _saveMealProgress(index, status);
//                 //         },
//                 //       );
//                 //     },
//                 //   ),
//                 // ),
//               ],
//             )
//           : Center(
//               child: Text('No tasks found. Please add tasks.'),
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => EditMealScreen(petId: widget.petId),
//             ),
//           ).then((_) {
//             // Load tasks again after returning from EditMealScreen
//           });
//         },
//         tooltip: 'Edit Task',
//         child: Icon(Icons.edit),
//       ),
//     );
//   }
// }

// // class _MealMonitoringScreenState extends State<MealMonitoringScreen> {
// //   List<bool> _taskStatus = [];
// //   List<String> _tasks = [];
// //   DateTime _selectedDate = DateTime.now();

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadTasks();
// //   }

// //   Future<void> _loadTasks() async {
// //   try {
// //     print('Loading tasks...');
// //     List<String> tasks = await MealProgressService().getTasks(widget.petId);
// //     List<bool> taskStatus = await MealProgressService()
// //         .getTaskProgress(widget.petId, _selectedDate);
// //     if (taskStatus.length != tasks.length) {
// //       taskStatus = List.filled(tasks.length, false);
// //     }
// //     setState(() {
// //       _tasks = tasks;
// //       _taskStatus = taskStatus;
// //     });
// //   } catch (e) {
// //     print('Error loading tasks: $e');
// //     // Or handle the error appropriately
// //   }
// // }

// //   void _saveMealProgress(int index, bool value) async {
// //     try {
// //       // Update nilai progres pada indeks yang sesuai dalam _taskStatus
// //       setState(() {
// //         _taskStatus[index] = value;
// //       });

// //       // Simpan progres ke Firestore
// //       await MealProgressService()
// //           .updateTaskProgress(widget.petId, _selectedDate, index, value);
// //     } catch (e) {
// //       print('Error saving progress: $e');
// //     }
// //   }

// //   void _selectDate(BuildContext context) async {
// //     final DateTime? pickedDate = await showDatePicker(
// //       context: context,
// //       initialDate: _selectedDate,
// //       firstDate: DateTime.now().subtract(Duration(days: 7)),
// //       lastDate: DateTime.now(),
// //     );
// //     if (pickedDate != null && pickedDate != _selectedDate) {
// //       setState(() {
// //         _selectedDate = pickedDate;
// //         _loadTasks();
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Meal Monitoring'),
// //       ),
// //       body: _tasks.isNotEmpty && _taskStatus.isNotEmpty
// //           ? Column(
// //               children: [
// //                 ElevatedButton(
// //                   onPressed: () => _selectDate(context),
// //                   child: Text(
// //                       'Select Date: ${_selectedDate.toString().split(' ')[0]}'),
// //                 ),
// //                 Expanded(
// //                   child: ListView.builder(
// //                     itemCount: _tasks.length,
// //                     itemBuilder: (context, index) {
// //                       return MonitoringItem(
// //                         title: _tasks[index],
// //                         isChecked: _taskStatus[index],
// //                         onChanged: (status) {
// //                           _saveMealProgress(index, status);
// //                         },
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             )
// //           : Center(
// //               child: Text('No tasks found. Please add tasks.'),
// //             ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //               builder: (context) => EditMealScreen(petId: widget.petId),
// //             ),
// //           ).then((_) {
// //             // Load tasks again after returning from EditMealScreen
// //             _loadTasks();
// //           });
// //         },
// //         tooltip: 'Edit Task',
// //         child: Icon(Icons.edit),
// //       ),
// //     );
// //   }
// // }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:owpet/src/screens/edit_meal_screen.dart';
import 'package:owpet/src/services/meal_service.dart';

class MealMonitoringScreen extends StatefulWidget {
  final String petId;

  MealMonitoringScreen({required this.petId});

  @override
  _MealMonitoringScreenState createState() => _MealMonitoringScreenState();
}

class _MealMonitoringScreenState extends State<MealMonitoringScreen> {
  final MealScheduleService _mealScheduleService = MealScheduleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meal Schedule')),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: _mealScheduleService.getMealSchedules('petId'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (!snapshot.hasData) {
            return Text('No meal schedule found.');
          }
          final mealSchedules = snapshot.data!;
          return ListView.builder(
            itemCount: mealSchedules.length,
            itemBuilder: (context, index) {
              final mealSchedule = mealSchedules[index];
              return CheckboxListTile(
                title: Text(mealSchedule['mealType']),
                subtitle: Text(
                    'Weight: ${mealSchedule['weight']}, Time: ${mealSchedule['time']}, Interval: ${mealSchedule['intervalDays']}'),
                value: mealSchedule['status'] ??
                    false, // Update the value with meal status
                onChanged: (bool? value) async {
                  // Save meal status to Firestore
                  await _mealScheduleService.updateMealStatus(
                      widget.petId, mealSchedule.id, value);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditMealSchedulePage()),
          );
        },
        tooltip: 'Add Meal Schedule',
        child: Icon(Icons.add),
      ),
    );
  }
}
