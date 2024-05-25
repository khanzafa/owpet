import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:owpet/src/screens/my_pets_screen.dart';

import 'profile_user_screen.dart';

Widget _buildGridItem(String title, IconData icon, BuildContext context) {
  return Card(
    color: Colors.deepPurple[100], // Use color that matches design
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(15), // Rounded corners like in the design
    ),
    child: InkWell(
      onTap: () {
        // Handle your onTap action here
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
            style: TextStyle(
              color: Colors.deepPurple, // Text color that matches the design
              fontWeight: FontWeight.bold, // Bold text like in the design
            ),
          ),
        ],
      ),
    ),
  );
}


class DashboardScreen extends StatelessWidget {
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
              padding: EdgeInsets.all(30),
              child: Stack(
                clipBehavior: Clip.none, // Allow overflow
                children: [
                  Container(
                    width: 350,
                    height: 160, // Fixed width for the container
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 190, // Width constraint for the "Welcome" text
                          child: Text(
                            'Welcome',
                            style: TextStyle(color: Colors.white, fontSize: 32),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width:
                              120, // Apply similar width constraints for uniformity
                          child: Text(
                            'Yuk, Pantau Aktivitas Pets Kita',
                            style: TextStyle(color: Colors.white, fontSize: 14),

                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: -10, // Adjust position to fit the design
                    top: 2,
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
                _buildGridItem('Pelaporan', Icons.assessment, context),
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
}

class ChartData {
  final DateTime time;
  final double sales;

  ChartData(this.time, this.sales);
}
