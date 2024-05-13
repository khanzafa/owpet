import 'package:flutter/material.dart';
import 'package:owpet/src/services/meal_service.dart';

class AddEditMealSchedulePage extends StatefulWidget {
  @override
  _AddEditMealSchedulePageState createState() =>
      _AddEditMealSchedulePageState();
}

class _AddEditMealSchedulePageState extends State<AddEditMealSchedulePage> {
  TextEditingController _mealTypeController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _intervalDaysController = TextEditingController();
  TextEditingController _timeController = TextEditingController(); 

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
                TextFormField(
                  controller: _mealTypeController,
                  decoration: InputDecoration(labelText: 'Meal Type'),
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
                TextFormField(
                  controller: _intervalDaysController,
                  decoration: InputDecoration(labelText: 'Interval Days'),
                  keyboardType: TextInputType.number,
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
                // Process the form data here
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
    // Implement the logic to add the meal schedule to Firestore here
    String mealType = _mealTypeController.text;
    double weight = double.parse(_weightController.text);
    String time = _selectedTime.format(context); // Convert TimeOfDay to string
    int intervalDays = int.parse(_intervalDaysController.text);

    // Print the values for demonstration (replace with Firestore logic)
    print('Meal Type: $mealType');
    print('Weight: $weight');
    print('Time: $time');
    print('Interval Days: $intervalDays');

    MealScheduleService().addMealSchedule(
      petId: 'petId',
      mealType: mealType,
      weight: weight,
      time: _selectedTime,
      intervalDays: intervalDays,
    );
  }
}
