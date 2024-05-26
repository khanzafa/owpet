import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'list_doctor_detailed.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DoctorListPage(),
    );
  }
}

class DoctorListPage extends StatelessWidget {
  final List<Map<String, String>> doctors = List.generate(6, (index) => {
        'name': 'Dr. Ayustia Darmawanti',
        'specialty': index % 3 == 0 ? 'Dermatology' : index % 3 == 1 ? 'Neurology' : 'Pathology',
        'address': 'Jl. Basuki Rahmad Gg IV No 09 Lamongan',
        'practiceHours': '08:00 - 12:00 WIB',
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(125.0),
        child: AppBar(
          backgroundColor: Color(0xFF8b80ff),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text(
                      'List Doctor',
                      style: GoogleFonts.jua(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  height: 36.0,
                  child: TextField(
                    decoration: InputDecoration(
                      hintStyle: GoogleFonts.poppins(fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF8b80ff)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: doctors.length + 1, // +1 untuk teks di atas daftar dokter
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: 22.0, bottom: 2.0, left: 25.0),
              child: Text(
                "Cari dokter terdekat dari kotamu!",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            );
          }
          final doctor = doctors[index - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Mengurangi padding vertikal
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailPage(
                      name: doctor['name']!,
                      specialty: doctor['specialty']!,
                      address: doctor['address']!,
                      practiceHours: doctor['practiceHours']!,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      height: 90, // Mengurangi tinggi card
                      decoration: BoxDecoration(
                        color: Color(0xFF8b80ff),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0), // Mengurangi padding di dalam card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFF8b80ff),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                doctor['specialty']!,
                                style: GoogleFonts.jua(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 4), // Mengurangi jarak antar elemen dalam card
                            Text(
                              doctor['name']!,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14, // Mengurangi ukuran font
                              ),
                            ),
                            SizedBox(height: 2), // Mengurangi jarak antar elemen dalam card
                            Text(
                              doctor['address']!,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
