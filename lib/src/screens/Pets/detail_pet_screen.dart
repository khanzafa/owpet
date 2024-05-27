import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/models/pet.dart';
import 'package:owpet/src/screens/Pets/edit_pet_screen.dart';
import 'package:owpet/src/screens/perawatan/grooming_monitoring_screen.dart';
import 'package:owpet/src/screens/Makan/meal_monitoring_screen.dart';

class PetDetailScreen extends StatelessWidget {
  final String userId;
  final Pet pet;
  final bool showedModal = true;

  PetDetailScreen({required this.userId, required this.pet});

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
          'Detail Pet',
          style: GoogleFonts.jua(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // backgroundColor:
        //     Color.fromRGBO(139, 128, 255, 1), // Set app bar color the same
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
                'assets/images/kucing.png',
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
                  // Text(
                  //   'DETAIL',
                  //   style: GoogleFonts.jua(
                  //     fontSize: 24.0,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  // SizedBox(height: 12.0),
                  PetInfoCard(
                    petName: pet.name,
                    petImage: pet.photoUrl ?? '',
                    petDob: DateTime.parse(pet.birthday!),
                    petGender: pet.gender!,
                    petMaritalStatus: pet.status!,
                    petSpecies: pet.species!,
                    petDescription: pet.description!,
                    onEditPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPetScreen(
                            userId: userId,
                            pet: pet,
                          ),
                        ),
                      );
                      // refresh pet data
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetDetailScreen(
                            userId: userId,
                            pet: pet,
                          ),
                        ),
                      );

                    },
                  ),
                  SizedBox(height: 12.0),
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
}

class PetInfoCard extends StatelessWidget {
  final String petName;
  final String petImage;
  final DateTime petDob;
  final String petGender;
  final String petMaritalStatus;
  final String petSpecies;
  final String petDescription;
  final VoidCallback onEditPressed;

  const PetInfoCard({
    Key? key,
    required this.petName,
    required this.petImage,
    required this.petDob,
    required this.petGender,
    required this.petMaritalStatus,
    required this.petSpecies,
    required this.petDescription,
    required this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      width: 350.0,
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
      child: Stack(
        children: [
          Row(
            children: [
              // Pet name and image
              Container(
                width: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    petImage.isNotEmpty
                        ? Image.network(
                            petImage,
                            width: 80,
                            height: 80,
                          )
                        : Image.asset(
                            'assets/images/kucing.png',
                            width: 80,
                            height: 80,
                          ),
                    const SizedBox(height: 8.0),
                    Text(
                      petName.toUpperCase(),
                      style: GoogleFonts.jua(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPetDetailRow(
                        Icons.calendar_today, petDob.toString().split(' ')[0]),
                    _buildPetDetailRow(Icons.person, petGender),
                    _buildPetDetailRow(Icons.favorite, petMaritalStatus),
                    _buildPetDetailRow(Icons.pets, petSpecies),
                    const SizedBox(height: 8.0),
                    Text(
                      petDescription,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.jua(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.edit,
                  color: Color.fromRGBO(252, 147, 64, 1), size: 20.0),
              onPressed: () {
                onEditPressed();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetDetailRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8.0),
        Text('$value'),
      ],
    );
  }
}
