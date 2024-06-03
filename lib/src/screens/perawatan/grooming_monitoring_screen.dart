import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/models/user.dart';
import 'package:owpet/src/services/grooming_descriptions.dart';
import 'package:owpet/src/services/grooming_service.dart';
import 'package:owpet/src/widgets/monitoring_item.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

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
  Map<DateTime, int> _completedTasksPerDate = {};

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _fetchCompletedTasks();
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

  void _SaveGroomingProgress(int index, bool value) async {
    try {
      // Update nilai progres pada indeks yang sesuai dalam _taskStatus
      setState(() {
        _taskStatus[index] = value;
      });

      // Hitung jumlah task yang diselesaikan pada tanggal _selectedDate
      int completedTasks = _getCompletedTasksForDate(_selectedDate);

      // Update _completedTasksPerDate dengan jumlah task yang diselesaikan pada _selectedDate
      setState(() {
        _completedTasksPerDate[_selectedDate] = completedTasks;
      });

      // Simpan progres ke Firestore
      await GroomingProgressService()
          .updateTaskProgress(widget.petId, _selectedDate, index, value);
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  int _getCompletedTasksForDate(DateTime date) {
    int completedTasks = 0;

    // Iterasi melalui _taskStatus dan hitung jumlah nilai true pada tanggal yang sesuai
    for (int i = 0; i < _taskStatus.length; i++) {
      if (_taskStatus[i]) {
        completedTasks++;
      }
    }

    return completedTasks;
  }

  Future<void> _fetchCompletedTasks() async {
    try {
      // Ambil data task yang diselesaikan dari Firestore
      Map<DateTime, int> completedTasks =
          await GroomingProgressService().getCompletedTasks(widget.petId);

      // Inisialisasi _completedTasksPerDate dengan data yang diambil
      setState(() {
        _completedTasksPerDate = completedTasks;
      });
    } catch (e) {
      print('Error fetching completed tasks: $e');
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
        backgroundColor: const Color.fromRGBO(236, 234, 255, 1.0),
        centerTitle: true,
        title: Text(
          'Perawatan',
          style: GoogleFonts.jua(
            fontSize: 32,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: _tasks.isNotEmpty && _taskStatus.isNotEmpty
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Container(
                    height: 360, // Tinggi tetap
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(
                                        child: Column(
                                      children: [
                                        Text(
                                          _tasks[index],
                                          style: GoogleFonts.jua(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                          thickness: 1.0,
                                          indent: 10,
                                          endIndent: 10,
                                          height: 1.0,
                                        ),
                                      ],
                                    )),
                                    content: SizedBox(
                                      height: 500,
                                      child: SingleChildScrollView(
                                        child: Text(
                                          grooming_descriptions[index],
                                          style: GoogleFonts.jua(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Column(
                              children: [
                                MonitoringItem(
                                  title: _tasks[index],
                                  isChecked: _taskStatus[index],
                                  onChanged: (status) {
                                    _SaveGroomingProgress(index, status);
                                  },
                                  index: index,
                                ),
                                if (index < _tasks.length - 1)
                                  const SizedBox(
                                    height: 1.0,
                                    child: Divider(
                                      color: Colors.black,
                                      thickness: 1.0,
                                      indent: 10,
                                      endIndent: 10,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Text(
                  "Monthly care",
                  style: GoogleFonts.jua(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CalendarCarousel(
                    onDayPressed: (DateTime date, List events) {
                      DateTime now = DateTime.now();
                      bool isAfterToday = date.isAfter(now);

                      if (isAfterToday) {
                        return;
                      }

                      setState(() {
                        _selectedDate = date;
                        _loadTasks();
                      });
                    },
                    weekendTextStyle: const TextStyle(
                      color: Colors.red,
                    ),
                    headerTextStyle: GoogleFonts.jua(
                      color: Colors.blue.shade300,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    weekdayTextStyle: GoogleFonts.jua(
                      color: Colors.red.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    childAspectRatio: 1.5,
                    pageSnapping: true,
                    selectedDayBorderColor: Colors.transparent,
                    selectedDayButtonColor: Colors.blue.shade300,
                    selectedDayTextStyle: const TextStyle(color: Colors.white),
                    todayButtonColor: const Color.fromARGB(255, 251, 255, 0),
                    todayBorderColor: Colors.transparent,
                    todayTextStyle: const TextStyle(color: Colors.white),
                    customDayBuilder: (
                      bool isSelectable,
                      int index,
                      bool isSelectedDay,
                      bool isToday,
                      bool isPrevMonthDay,
                      TextStyle textStyle,
                      bool isNextMonthDay,
                      bool isThisMonthDay,
                      DateTime day,
                    ) {
                      int completedTasks = _completedTasksPerDate[day] ?? 0;
                      int totalTasks = 6;

                      DateTime now = DateTime.now();

                      bool isAfterToday = day.isAfter(now);

                      if (isPrevMonthDay || isNextMonthDay || isAfterToday) {
                        return SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(
                            child: Text(
                              day.day.toString(),
                              style: GoogleFonts.jua(
                                color: textStyle.color?.withOpacity(0.5),
                                decoration:
                                    isAfterToday ? TextDecoration.none : null,
                              ),
                            ),
                          ),
                        );
                      }

                      double progress =
                          totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;

                      if (isPrevMonthDay || isNextMonthDay) {
                        return SizedBox(
                          height: 50,
                          width: 50,
                          child: Center(
                            child: Text(
                              day.day.toString(),
                              style: textStyle.copyWith(
                                  color: textStyle.color?.withOpacity(0.5)),
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 50,
                        width: 50,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: 50.0,
                              width: 30.0,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey[300],
                                strokeWidth: 5.0,
                                value: progress,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color.fromRGBO(139, 128, 255, 1.0)),
                              ),
                            ),
                            Text(
                              day.day.toString(),
                              style: GoogleFonts.jua(),
                            ),
                          ],
                        ),
                      );
                    },
                    weekFormat: false,
                    height: 350.0,
                    selectedDateTime: _selectedDate,
                    daysHaveCircularBorder: true,
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                'No tasks found. Please add tasks.',
                style: GoogleFonts.jua(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
    );
  }
}
