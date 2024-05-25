import 'package:flutter/material.dart';
import 'package:owpet/src/screens/edit_meal_screen.dart';
import 'package:owpet/src/services/meal_service.dart';

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
  final MealService _mealService = MealService();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _autoAddMealProgress();
  }

  Future<void> _autoAddMealProgress() async {
    await _mealService.autoAddMealProgress(
        widget.petId, _selectedDate.toString().split(' ')[0]);
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      // Awal bulan
      firstDate: DateTime.now().subtract(Duration(days: DateTime.now().day - 1)),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _autoAddMealProgress();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MAKAN'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
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
          return ListView.builder(
            itemCount: mealProgress.length,
            itemBuilder: (context, index) {
              final meal = mealProgress[index];
              return StreamBuilder<DocumentSnapshot>(
                stream: _mealService.getMealSchedule(widget.petId, meal.id),
                builder: (context, mealSnapshot) {
                  if (mealSnapshot.connectionState == ConnectionState.waiting) {
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
                  final mealSchedule = mealSnapshot.data!.data() as Map<String, dynamic>;
                  return ListTile(
                    leading: Text('${index + 1}'),
                    title: Text(mealSchedule['mealType']),
                    subtitle: Text('Weight: ${mealSchedule['weight']}g, Time: ${mealSchedule['time']}'),
                    trailing: Checkbox(
                      value: meal['status'],
                      onChanged: (value) {
                        _mealService.updateMealProgress(
                          widget.petId,
                          _selectedDate.toString().split(' ')[0],
                          meal.id,
                          value!,
                        );
                      },
                    ),
                  );
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
            MaterialPageRoute(
                builder: (context) => AddEditMealSchedulePage(petId: widget.petId)),
          );
        },
        tooltip: 'Add Meal Schedule',
        child: Icon(Icons.add),
      ),
    );
  }
}