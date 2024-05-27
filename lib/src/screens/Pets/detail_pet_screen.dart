import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/models/pet.dart';
import 'package:owpet/src/screens/Pets/edit_pet_screen.dart';
import 'package:owpet/src/screens/perawatan/grooming_monitoring_screen.dart';
import 'package:owpet/src/screens/Makan/meal_monitoring_screen.dart';


class PetDetailScreen extends StatelessWidget {
  final String userId = 'qUtR4Sp5FAHyOpmxeD9l';
  final Pet pet;
  final bool showedModal = true;

  PetDetailScreen({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded), // Replace with your desired icon
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Pet Details'),
        backgroundColor:
            Color.fromRGBO(139, 128, 255, 1), // Set app bar color the same
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // Background image container
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/kelinci.png',
                width: 270,
                height: 270,
              ),
              decoration:
                  BoxDecoration(color: Color.fromRGBO(139, 128, 255, 1))),

          // Front container with rounded corners and content
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    'DETAIL',
                    style: GoogleFonts.jua(
                      fontSize: 24.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Container(
                    alignment: Alignment.topCenter,
                    width: 350.0, // Adjust width as needed
                    height: 200.0, // Adjust height as needed
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(236, 234, 255, 1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cake,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    '${pet.birthday}',
                                    style: GoogleFonts.jua(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.pets,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    '${pet.species}',
                                    style: GoogleFonts.jua(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.pets,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    '${pet.gender}',
                                    style: GoogleFonts.jua(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.pets,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10.0),
                                  Text(
                                    '${pet.status}',
                                    style: GoogleFonts.jua(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '${pet.description}',
                                style: GoogleFonts.jua(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ]),
                        SizedBox(width: 5.0), // Spacing between text and image
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/images/kelinci.png',
                              width: 100,
                              height: 100,
                            ),
                            Text(
                              '${pet.name}',
                              style: GoogleFonts.jua(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            // edit icon button
                            IconButton(
                              alignment: Alignment.bottomRight,
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => EditPetScreen(
                                //               userId: userId,
                                //               pet: pet,
                                //             )));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'PERAWATAN HARIAN',
                    style: GoogleFonts.jua(
                      fontSize: 24.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // buildServiceCard(context, 'Perawatan', 100.0, 100.0),
                      // SizedBox(width: 14.0), // Spacing between cards
                      // buildServiceCard(context, 'Makan', 100.0, 100.0),
                      // SizedBox(width: 14.0), // Spacing between cards
                      // buildServiceCard(context, 'Kesehatan', 100.0, 100.0),
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke halaman monitoring perawatan
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GroomingMonitoringScreen(petId: pet.id),
                            ),
                          );
                        },
                        child: const Image(
                          image: AssetImage(
                              'assets/images/perawatan_card-day-care.png'),
                          width: 100,
                          height: 100,
                        ),
                      ),
                      const SizedBox(width: 14.0), // Spacing between cards
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MealMonitoringScreen(petId: pet.id),
                            ),
                          );
                        },
                        child: const Image(
                          image: AssetImage(
                              'assets/images/makan_card-day-care.png'),
                          width: 100,
                          height: 100,
                        ),
                      ),
                      const SizedBox(width: 14.0), // Spacing between cards
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke halaman monitoring kesehatan
                        },
                        child: const Image(
                          image: AssetImage(
                              'assets/images/kesehatan_card-day-care.png'),
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // body: Padding(
      //   padding: EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         'Name: ${pet.name}',
      //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //       ),
      //       SizedBox(height: 8),
      //       Text('ID: ${pet.id}'),
      //       Text('Birthday: ${pet.birthday}'),
      //       Text('Gender: ${pet.gender}'),
      //       Text('Species: ${pet.species}'),
      //       Text('Status: ${pet.status}'),
      //       if (pet.description != null) // Tampilkan deskripsi hanya jika ada
      //         Text('Description: ${pet.description}'),
      //       SizedBox(height: 16),
      //       // Card untuk ke halaman monitoring makan
      //       Card(
      //         child: ListTile(
      //           title: Text('Feeding Monitoring'),
      //           subtitle: Text('Monitor your pet\'s feeding schedule'),
      //           onTap: () {
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => MealMonitoringScreen(petId: pet.id,),
      //                 ),
      //               );
      //           },
      //         ),
      //       ),
      //       // Card untuk ke halaman monitoring kesehatan
      //       Card(
      //         child: ListTile(
      //           title: Text('Health Monitoring'),
      //           subtitle: Text('Monitor your pet\'s health status'),
      //           onTap: () {
      //             // Navigasi ke halaman monitoring kesehatan
      //           },
      //         ),
      //       ),
      //       // Card untuk ke halaman monitoring perawatan
      //       Card(
      //         child: ListTile(
      //           title: Text('Grooming Monitoring'),
      //           subtitle: Text('Monitor your pet\'s grooming schedule'),
      //           onTap: () {
      //             // Navigasi ke halaman monitoring perawatan
      //           },
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  Widget buildServiceCard(BuildContext context, String title, double width,
      double height, String image) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 140, 192, 234),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.0), // Adjust font size as needed
            ),
            SizedBox(height: 10.0), // Spacing between text and image
            Image.asset(
              image,
              width: 50,
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 600, // Adjust height as needed
          color: Colors.white, // Customize background color
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Prevents content overflow
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/kelinci.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                Text('Additional Pet Information'),
                // Add more details here (e.g., favorite food, vet info)
              ],
            ),
          ),
        );
      },
    );
  }
}
