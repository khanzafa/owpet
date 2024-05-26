import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorDetailPage extends StatelessWidget {
  final String name;
  final String specialty;
  final String address;
  final String practiceHours;

  DoctorDetailPage({
    required this.name,
    required this.specialty,
    required this.address,
    required this.practiceHours,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xFF8b80ff),
        leading: IconButton(
          icon: Image.asset(
            'assets/images/icon-park-solid_back.png',
            height: 24, // Set height according to your needs
            width: 24, // Set width according to your needs
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Dokter',
          style: GoogleFonts.jua(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/images/doctor.jpg'), // Ensure you have an image asset
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 22),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 25),
                InfoRow(
                  label: 'Alamat\nPraktek',
                  value: address,
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  valueStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
                InfoRow(
                  label: 'Spesialis',
                  value: specialty,
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  valueStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
                InfoRow(
                  label: 'Jam Praktek',
                  value: practiceHours,
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  valueStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  InfoRow({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: labelStyle,
            ),
          ),
          Text(': ', style: labelStyle),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: valueStyle,
            ),
          ),
        ],
      ),
    );
  }
}
