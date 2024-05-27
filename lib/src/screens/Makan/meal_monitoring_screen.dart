import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/screens/Makan/edit_meal_screen.dart';
import 'package:owpet/src/services/meal_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MealMonitoringScreen extends StatefulWidget {
  final String petId;

  MealMonitoringScreen({required this.petId});

  @override
  _MealMonitoringScreenState createState() => _MealMonitoringScreenState();
}

class _MealMonitoringScreenState extends State<MealMonitoringScreen> {
  final MealService _mealService = MealService();
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _selectedWeek = [];
  String _selectedMonth = '';

  @override
  void initState() {
    super.initState();
    _autoAddMealProgress();
    _setSelectedWeek(_selectedDate);
  }

  Future<void> _autoAddMealProgress() async {
    await _mealService.autoAddMealProgress(
        widget.petId, _selectedDate.toString().split(' ')[0]);
  }

  void _selectWeek(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      // Hari terakhir adalah hari ini
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _setSelectedWeek(_selectedDate);
        _selectedMonth = _selectedDate.toString().split(' ')[0].split('-')[1];
        _autoAddMealProgress();
      });
    }
  }

  void _setSelectedWeek(DateTime selectedDate) {
    _selectedWeek = [];
    DateTime startOfWeek =
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    for (int i = 0; i < 7; i++) {
      _selectedWeek.add(startOfWeek.add(Duration(days: i)));
    }
  }

  Future<void> _updateMealStatus(String scheduleId, bool status) async {
    await _mealService.updateMealProgress(
      widget.petId,
      _selectedDate.toString().split(' ')[0],
      scheduleId,
      status,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/images/icon-park-solid_back.png',
            height: 24,
            width: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Monitoring Makan',
          style: GoogleFonts.jua(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectWeek(context),
          ),
        ],
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
          stream: _mealService.getMealProgress(
              widget.petId, _selectedDate.toString().split(' ')[0]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No meal schedules found.'));
            }
            final mealProgress = snapshot.data!;
            return Column(
              children: [
                Text(
                  'Monitoring Bulan ke-$_selectedMonth',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildDayCheckboxes(_selectedWeek),
                buildReminderCard(),
                Expanded(
                  child: ListView.builder(
                    itemCount: mealProgress.length,
                    itemBuilder: (context, index) {
                      final meal = mealProgress[index];
                      return StreamBuilder<DocumentSnapshot>(
                        stream:
                            _mealService.getMealSchedule(widget.petId, meal.id),
                        builder: (context, mealSnapshot) {
                          if (mealSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ListTile(
                              title: Text('Loading...'),
                              trailing: CircularProgressIndicator(),
                            );
                          }
                          if (!mealSnapshot.hasData) {
                            return ListTile(
                              title: Text('Error loading schedule'),
                            );
                          }
                          final mealSchedule =
                              mealSnapshot.data!.data() as Map<String, dynamic>;
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: ListTile(
                                leading: Text('${index + 1}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                title: Text(mealSchedule['mealType'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    'Weight: ${mealSchedule['weight']}g\nTime: ${mealSchedule['time']}',
                                    style: TextStyle(fontSize: 16)),
                                trailing: Checkbox(
                                  value: meal['status'],
                                  onChanged: (value) {
                                    setState(() {
                                      _updateMealStatus(meal.id, value!);
                                    });
                                  },
                                )),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddEditMealSchedulePage(petId: widget.petId)),
          );
        },
        tooltip: 'Add Meal Schedule',
        child: Icon(Icons.add),
      ),
    );
  }

  // Widget buildDayCheckboxes() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: List.generate(_selectedWeek.length, (index) {
  //       final day = _selectedWeek[index];
  //       return Row(
  //         children: [
  //           // Text('${day.day}/${day.month}'),
  //           Checkbox(
  //             value: false, // Replace with actual logic if needed
  //             onChanged: (bool? value) {
  //               setState(() {
  //                 // Handle checkbox state change if necessary
  //               });
  //             },
  //           ),
  //         ],
  //       );
  //     }),
  //   );
  // }

  Widget buildDayCheckboxes(List<DateTime> selectedWeek) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(selectedWeek.length, (index) {
        final day = selectedWeek[index];
        return StreamBuilder<List<DocumentSnapshot>>(
          stream: _mealService.getMealProgress(
            widget.petId,
            '${day.year}-${day.month}-${day.day}',
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // If no meal progress data found for the day, return an empty checkbox
              return Checkbox(
                value: false,
                onChanged: null,
              );
            }
            final mealProgress = snapshot.data!;
            bool allCompleted = mealProgress.every(
              (meal) => meal['status'] == true,
            );
            return Checkbox(
              value: allCompleted,
              onChanged: null,
            );
          },
        );
      }),
    );
  }

  Widget buildReminderCard() {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(Icons.pets, color: Colors.orange, size: 40),
        title: Text('Don\'t forget to feed your pet!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
