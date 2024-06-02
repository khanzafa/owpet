import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/screens/Dokter/list_doctor_detailed.dart';
import 'package:owpet/src/services/dokter_service.dart';
import 'package:owpet/src/models/doctor.dart';

class DoctorListPage extends StatefulWidget {
  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  // final List<Map<String, String>> doctors = List.generate(6, (index) => {
  //       'name': 'Dr. Ayustia Darmawanti',
  //       'specialty': index % 3 == 0 ? 'Dermatology' : index % 3 == 1 ? 'Neurology' : 'Pathology',
  //       'address': 'Jl. Basuki Rahmad Gg IV No 09 Lamongan',
  //       'practiceHours': '08:00 - 12:00 WIB',
  //     });
  final dokterService = DokterService();
  final List<Dokter> doctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<List<Dokter>> fetchDoctors() async {    
    final List<Dokter> fetchedDoctors = await dokterService.getDoctors();
    setState(() {
      doctors.addAll(fetchedDoctors);
    });
    return doctors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/images/icon-park-solid_back.png',
            height: 24, // Set height according to your needs
            width: 24, // Set width according to your needs
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Daftar Dokter',
          style: GoogleFonts.jua(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: doctors.length + 1, // +1 untuk teks di atas daftar dokter
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding:
                  const EdgeInsets.only(top: 22.0, bottom: 2.0, left: 25.0),
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
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 4.0), // Mengurangi padding vertikal
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailPage(
                      doctor: doctor,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
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
                        padding: const EdgeInsets.all(
                            12.0), // Mengurangi padding di dalam card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xFF8b80ff),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                doctor.speciality,
                                style: GoogleFonts.jua(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    4), // Mengurangi jarak antar elemen dalam card
                            Text(
                              doctor.name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14, // Mengurangi ukuran font
                              ),
                            ),
                            SizedBox(
                                height:
                                    2), // Mengurangi jarak antar elemen dalam card
                            Text(
                              doctor.location,
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
