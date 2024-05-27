import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          'Tambah Jadwal Makan',
          style: GoogleFonts.jua(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF8B80FF),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              height: 120,
              margin: EdgeInsets.all(10),
              child: ListTile(
                // leading: Icon(Icons.pets, color: Colors.orange, size: 40),
                leading: Image.asset(
                  'assets/images/pet-food.png',
                  height: 60,
                  width: 60,
                ),
                titleAlignment: ListTileTitleAlignment.center,
                title: Text('Rekomendasi Makan Pets',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jua(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                textColor: Colors.white,
                subtitle: Text(
                  '20-25 gram makanan kering atau basah perkilogram berat badan per hari. Bagi menjadi 4 porsi seimbang',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jua(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Atur Jadwal Makan Pets Anda',
              style: GoogleFonts.jua(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: MealService().getMealSchedules(widget.petId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final meals = snapshot.data ?? [];

                  if (meals.isEmpty) {
                    return Text('No meal schedules found.');
                  }

                  return ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index].data() as Map<String, dynamic>;
                      final mealId = meals[index].id;
                      // return ListTile(
                      //   title: Text(meal['mealType']),
                      //   subtitle: Text(
                      //     'Weight: ${meal['weight']}g, Time: ${meal['time']}',
                      //   ),
                      // );
                      return Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFECEAFF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                                // Ganti leading dengan ikon
                                leading: Image.asset(
                                  'assets/images/pet-food.png',
                                  height: 40,
                                  width: 40,
                                ),
                                title: Text(meal['mealType'],
                                    style: GoogleFonts.jua(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                                subtitle: Text(
                                    'Pukul ${meal['time']} => ${meal['weight']} gram',
                                    style: GoogleFonts.jua(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    )),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit,
                                          color:
                                              Color.fromRGBO(252, 147, 64, 1)),
                                      onPressed: () {
                                        _showEditMealScheduleDialog(context, mealId, meal);
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _deleteMealSchedule(mealId);
                                      },
                                    ),
                                  ],
                                )),
                          ));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showAddMealScheduleDialog(context);
        },
        tooltip: 'Add Meal Schedule',
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromRGBO(252, 147, 64, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)),
      ),
    );
  }

  void _deleteMealSchedule(String mealId) {
    // Confirm delete
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Meal Schedule'),
          content: Text('Are you sure you want to delete this meal schedule?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                MealService().deleteMealSchedule(widget.petId, mealId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showEditMealScheduleDialog(BuildContext context, String mealId, Map<String, dynamic> meal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Meal Schedule'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Meal Type', hintText: meal['mealType']),
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
                  decoration: InputDecoration(labelText: 'Berat (gram)', hintText: meal['weight'].toString()),                                  
                  keyboardType: TextInputType.number,
                ),
                InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Waktu Makan',
                      hintText: meal['time'],
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
                _editMealSchedule(mealId);
                Navigator.of(context).pop();
              },
              child: Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  void _editMealSchedule(String mealId) {
    String mealType = _selectedMealType!;
    int weight = int.parse(_weightController.text);
    String time = _selectedTime.format(context);

    Meal mealData = Meal(
      id: mealId,
      mealType: mealType,
      weight: weight,
      time: time,
    );

    MealService().updateMealSchedule(widget.petId, mealId, mealData);
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

    MealService().addMealSchedule(petId: widget.petId, meal: mealData);
  }
}
