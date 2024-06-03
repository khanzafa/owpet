import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/services/health_service.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:owpet/src/widgets/monitoring_item.dart';

class HealthMonitoringScreen extends StatefulWidget {
  final String petId;

  HealthMonitoringScreen({required this.petId});

  @override
  _HealthMonitoringScreenState createState() => _HealthMonitoringScreenState();
}

class _HealthMonitoringScreenState extends State<HealthMonitoringScreen> {
  List<bool> _taskStatus = [];
  List<String> _tasks = [];
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, int> _completedTasksPerDate = {};
  StreamController<Map<DateTime, int>> _progressStreamController =
      StreamController<Map<DateTime, int>>.broadcast();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _progressStreamController.close();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _fetchCompletedTasks();
    await _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      print('Loading tasks...');
      List<String> tasks = await HealthProgressService().getTasks(widget.petId);
      List<bool> taskStatus = await HealthProgressService()
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
    }
  }

  Future<void> _fetchCompletedTasks() async {
    try {
      Map<DateTime, int> completedTasks =
          await HealthProgressService().getCompletedTasks(widget.petId);
      print('Completed tasks received from service: $completedTasks');

      DateTime startDate = DateTime.now().subtract(Duration(days: 30));
      DateTime endDate = DateTime.now();

      for (DateTime date = startDate;
          date.isBefore(endDate.add(Duration(days: 1)));
          date = date.add(Duration(days: 1))) {
        _completedTasksPerDate[date] = completedTasks[date] ?? 0;
      }

      if (_completedTasksPerDate.isNotEmpty) {
        _progressStreamController.add(_completedTasksPerDate);
      }
    } catch (e) {
      print('Error fetching completed tasks: $e');
    }
  }

  void _saveHealthProgress(int index, bool value) async {
    try {
      setState(() {
        _taskStatus[index] = value;
      });
      await HealthProgressService()
          .updateTaskProgress(widget.petId, _selectedDate, index, value);

      // Hitung jumlah tugas yang diselesaikan untuk tanggal saat ini
      int completedTasks = _getCompletedTasksForDate(_selectedDate);

      // Perbarui _completedTasksPerDate dengan jumlah tugas yang diselesaikan
      setState(() {
        _completedTasksPerDate[_selectedDate] = completedTasks;
      });

      _progressStreamController.add(_completedTasksPerDate); // Update stream
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  int _getCompletedTasksForDate(DateTime date) {
    int completedTasks = 0;
    for (int i = 0; i < _taskStatus.length; i++) {
      if (_taskStatus[i]) {
        completedTasks++;
      }
    }
    return completedTasks;
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
          'Kesehatan',
          style: GoogleFonts.jua(
            fontSize: 32,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: StreamBuilder<Map<DateTime, int>>(
        stream: _progressStreamController.stream, // Listen to the stream
        initialData: _completedTasksPerDate,
        builder: (context, snapshot) {
          return _buildContent(snapshot.data ?? {});
        },
      ),
    );
  }

  Widget _buildContent(Map<DateTime, int> completedTasksPerDate) {
    return _tasks.isNotEmpty && _taskStatus.isNotEmpty
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Container(
                  height: 360,
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
                    color: const Color.fromRGBO(236, 234, 255, 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            MonitoringItem(
                              title: _tasks[index],
                              isChecked: _taskStatus[index],
                              onChanged: (status) {
                                _saveHealthProgress(index, status);
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
                        );
                      },
                    ),
                  ),
                ),
              ),
              Text(
                "Monthly health",
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
                    int completedTasks = completedTasksPerDate[day] ?? 0;
                    print('Completed tasks for ${day.day}: $completedTasks');
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
          );
  }
}
