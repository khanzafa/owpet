import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/models/chart.dart';
import 'package:owpet/src/models/user.dart';
import 'package:owpet/src/screens/Komunitas/forum_screen.dart';
import 'package:owpet/src/screens/Makan/meal_choice_pet.dart';
import 'package:owpet/src/screens/Pets/my_pets_screen.dart';
import 'package:owpet/src/screens/Artikel/list_article_screen.dart';
import 'package:owpet/src/screens/Dokter/list_doctor.dart';
import 'package:owpet/src/services/task_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatefulWidget {
  final User user;

  DashboardScreen({required this.user});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<ChartData> dummyChartData = [
    ChartData(DateTime(2024, 4, 19), 5.0),
    ChartData(DateTime(2024, 4, 20), 25.0),
    ChartData(DateTime(2024, 4, 21), 100.0),
    ChartData(DateTime(2024, 4, 22), 75.0),
    ChartData(DateTime(2024, 4, 23), 88.0),
    ChartData(DateTime(2024, 4, 24), 65.0),
    ChartData(DateTime(2024, 4, 25), 50.0),
    ChartData(DateTime(2024, 4, 26), 33.0),
    ChartData(DateTime(2024, 4, 27), 20.0),
    ChartData(DateTime(2024, 4, 28), 80.0),
  ];
  List<ChartData> chartData = [];

  void getChartData() async {
  final taskCompletionService = TaskCompletionService();
  final List<ChartData> data = await taskCompletionService
      .calculateDailyTaskCompletionRate(widget.user.id);
  if (mounted) {
    setState(() {
      chartData = data;
    });
  }
}
  @override
  void initState() {
    super.initState();
    getChartData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Stack(
                clipBehavior: Clip.none, // Allow overflow
                children: [
                  Container(
                    width: double.infinity,
                    height: 150, // Fixed height for the container
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(139, 128, 255, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 190, // Width constraint for the "Welcome" text
                          child: Text(
                            'Welcome',
                            style: GoogleFonts.jua(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 34),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          width: 160, // Apply similar width constraints for uniformity
                          child: Text(
                            'Yuk, Pantau Aktivitas Pets Kita',
                            style: GoogleFonts.jua(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: -10, // Adjust position to fit the design
                    top: 15,
                    child: Image.asset(
                      'assets/images/anjing.png',
                      width: 185,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              padding: EdgeInsets.all(10), // Adjust padding to match design
              mainAxisSpacing: 10, // Adjust spacing to match design
              crossAxisSpacing: 10, // Adjust spacing to match design
              crossAxisCount: 3,
              children: [
                _buildGridItem('Perawatan', context),
                _buildGridItem('Makan', context),
                _buildGridItem('Kesehatan', context),
                _buildGridItem('Artikel', context),
                _buildGridItem('Dokter', context),
                _buildGridItem('Komunitas', context),
              ],
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Grafik Aktivitas Pets Kita',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(),
                      series: <LineSeries<ChartData, DateTime>>[
                        LineSeries<ChartData, DateTime>(
                          dataSource: dummyChartData,
                          xValueMapper: (ChartData data, _) => data.date,
                          yValueMapper: (ChartData data, _) => data.completionRate,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildGridItem(String title, BuildContext context) {
    return Card(
      color: Color.fromRGBO(139, 128, 255, 1),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15), // Rounded corners like in the design
      ),
      child: InkWell(
        onTap: () {
          if (title == 'Perawatan') {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => MyPetsScreen()),
            // );
          } else if (title == 'Makan') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MealChoicePetScreen(user: widget.user)),
            );
          } else if (title == 'Kesehatan') {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ProfileUserScreen()),
            // );
          } else if (title == 'Artikel') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArtikelPage(
                        user: widget.user,
                      )),
            );
          } else if (title == 'Dokter') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DoctorListPage()),
            );
          } else if (title == 'Komunitas') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ForumScreen(
                        user: widget.user,
                      )),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/card_$title.png',
              width: 50,
            ),
            SizedBox(height: 8), // Space between icon and text
            Text(
              title,
              textAlign: TextAlign.center,
              // style: TextStyle(
              //   color: Colors.deepPurple, // Text color that matches the design
              //   fontWeight: FontWeight.bold, // Bold text like in the design
              // ),
              style: GoogleFonts.jua(
                textStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
