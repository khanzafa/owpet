import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/models/user.dart';
import 'package:owpet/src/screens/Komunitas/forum_screen.dart';
import 'package:owpet/src/screens/Makan/meal_choice_pet.dart';
import 'package:owpet/src/screens/Pets/my_pets_screen.dart';
import 'package:owpet/src/screens/Artikel/list_article_screen.dart';
import 'package:owpet/src/screens/Dokter/list_doctor.dart';

class DashboardScreen extends StatelessWidget {
  final User user;

  DashboardScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(DateTime(2024, 4, 19), 5),
      ChartData(DateTime(2024, 4, 20), 25),
      ChartData(DateTime(2024, 4, 21), 100),
      ChartData(DateTime(2024, 4, 22), 75),
      ChartData(DateTime(2024, 4, 23), 88),
      ChartData(DateTime(2024, 4, 24), 65),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10, vertical: 20
              ),
              child: Stack(
                clipBehavior: Clip.none, // Allow overflow
                children: [
                  Container(
                    width: 360,
                    height: 150, // Fixed width for the container
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
                            // style: TextStyle(color: Colors.white, fontSize: 32),
                            style: GoogleFonts.jua(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 34),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width:
                              160, // Apply similar width constraints for uniformity
                          child: Text(
                            'Yuk, Pantau Aktivitas Pets Kita',
                            // style: TextStyle(color: Colors.white, fontSize: 14),
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
                _buildGridItem('Perawatan', Icons.content_cut, context),
                _buildGridItem('Makan', Icons.restaurant, context),
                _buildGridItem('Kesehatan', Icons.local_hospital, context),
                _buildGridItem('Artikel', Icons.article, context),
                _buildGridItem('Dokter', Icons.medical_services, context),
                _buildGridItem('Komunitas', Icons.people, context),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              // child: SfCartesianChart(
              //   primaryXAxis: DateTimeAxis(),
              //   series: <LineSeries<ChartData, DateTime>>[
              //     LineSeries<ChartData, DateTime>(
              //       dataSource: chartData,
              //       xValueMapper: (ChartData data, _) => data.time,
              //       yValueMapper: (ChartData data, _) => data.sales,
              //     ),
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String title, IconData icon, BuildContext context) {
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
            MaterialPageRoute(builder: (context) => MealChoicePetScreen(user: user)),
          );
        } else if (title == 'Kesehatan') {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ProfileUserScreen()),
          // );
        } else if (title == 'Artikel') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ArtikelPage(user: user,)),
          );
        } else if (title == 'Dokter') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorListPage()),
          );
        } else if (title == 'Komunitas') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForumScreen(user: user,)),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon,
              size: 30, color: Colors.deepPurple), // Use custom icons or color
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

class ChartData {
  final DateTime time;
  final double sales;

  ChartData(this.time, this.sales);
}
