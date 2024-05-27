import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:owpet/src/models/meal.dart';
import 'package:owpet/src/services/meal_service.dart';

class AddEditMealSchedulePage extends StatefulWidget {
  final String petId;

  AddEditMealSchedulePage({required this.petId});

  @override
  _AddEditMealSchedulePageState createState() =>
      _AddEditMealSchedulePageState();
}

class _AddEditMealSchedulePageState extends State<AddEditMealSchedulePage> {
  TextEditingController _mealTypeController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _timeController = TextEditingController();
  String? _selectedMealType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Meal Schedule')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Add Meal Schedule Form'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showAddMealScheduleDialog(context);
              },
              child: Text('Add Meal Schedule'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: MealService().getMealSchedules(widget.petId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final meals = snapshot.data ?? [];

                  if (meals.isEmpty) {
                    return Text('No meal schedules found.');
                  }

                  return ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(meal['mealType']),
                        subtitle: Text(
                          'Weight: ${meal['weight']}g, Time: ${meal['time']}',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMealScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Meal Schedule'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Meal Type'),
                  value: _selectedMealType,
                  items: [
                    DropdownMenuItem(
                      value: 'Dry Food',
                      child: Text('Dry Food'),
                    ),
                    DropdownMenuItem(
                      value: 'Wet Food',
                      child: Text('Wet Food'),
                    ),
                    DropdownMenuItem(
                      value: 'Snack',
                      child: Text('Snack'),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedMealType = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a meal type';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _selectedMealType = value;
                  },
                ),
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(labelText: 'Weight'),
                  keyboardType: TextInputType.number,
                ),
                InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Time',
                    ),
                    child: Text(
                      _selectedTime.format(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addMealSchedule();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _addMealSchedule() {
    String mealType = _selectedMealType!;
    int weight = int.parse(_weightController.text);
    String time = _selectedTime.format(context);

    Meal mealData = Meal(
      id: '',
      mealType: mealType,
      weight: weight,
      time: time,
    );

    MealService().addMealSchedule(
      petId: widget.petId,
      meal: mealData
    );
  }
}
