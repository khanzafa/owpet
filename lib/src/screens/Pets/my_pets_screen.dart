import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/screens/add_profile.dart';
import 'package:owpet/src/screens/Pets/add_pet_screen.dart';
import 'package:owpet/src/screens/Pets/detail_pet_screen.dart';
import 'package:owpet/src/services/pet_service.dart';
import 'package:owpet/src/models/pet.dart';

class MyPetsScreen extends StatelessWidget {
  final String userId;
  final PetService petService = PetService();
  final List<String> categories = [
    'All',
    'Anjing',
    'Kucing',
    'Kelinci',
    'Burung'
  ];

  MyPetsScreen({required this.userId});

  void _navigateToAddPetScreen(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPetScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xFF8B80FF),
        title: Text(
          'Owpets - Hewan Peliharaan',
          style: GoogleFonts.jua(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            // color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(41),
          child: Container(
            // color: Color(0xFF8B80FF), // Updated background color
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 352,
                height: 41,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                        color: Colors.black), // Updated hint text color
                    prefixIcon: Icon(Icons.search,
                        color: Colors.black), // Updated icon color
                    filled: true,
                    fillColor: Color(0xFF8B80FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Container(
          //   color: Color(0xFF8B80FF), // Background color for the categories
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 16),
          //     child: SizedBox(
          //       height: 35, // Adjust the height as needed
          //       child: ListView.builder(
          //         scrollDirection: Axis.horizontal,
          //         itemCount: categories.length,
          //         itemBuilder: (context, index) {
          //           return Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 8),
          //             child: buildCategoryButton(categories[index]),
          //           );
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          // Container(
          //   color: Color(0xFF8B80FF), // Updated background color
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: SizedBox(
          //       width: 352,
          //       height: 41,
          //       child: TextField(
          //         decoration: InputDecoration(
          //           hintText: 'Search...',
          //           hintStyle: TextStyle(
          //               color: Colors.black), // Updated hint text color
          //           prefixIcon: Icon(Icons.search,
          //               color: Colors.black), // Updated icon color
          //           filled: true,
          //           fillColor: Colors.white,
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(20.0),
          //             borderSide: BorderSide.none,
          //           ),
          //           contentPadding: EdgeInsets.symmetric(vertical: 10),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Pet>>(
              future: petService.getMyPets(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data == null) {
                  return Center(
                      child: Text(
                    textAlign: TextAlign.center,
                    'Tidak ada hewan peliharaan yang ditemukan. Silakan tambahkan hewan peliharaan baru.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ));
                } else {
                  List<Pet> myPets = snapshot.data ?? [];
                  return GridView.builder(
                    padding: EdgeInsets.all(30),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: myPets.length,
                    itemBuilder: (context, index) {
                      Pet pet = myPets[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PetDetailScreen(pet: pet),
                            ),
                          );
                        },
                        child: buildPetCard(pet),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          onPressed: () => _navigateToAddPetScreen(context),
          backgroundColor: Color(0xFFFC9340),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          tooltip: 'Add New Pet',
          elevation: 0,
          shape: CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildCategoryButton(String category) {
    return FittedBox(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Updated background color
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            category,
            style: TextStyle(
              color: Colors.black, // Updated text color
              fontSize: 15,
              fontFamily: 'Jua',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPetCard(Pet pet) {
    return AspectRatio(
      aspectRatio: 0.77,
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFF8B80FF)),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF8B80FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    pet.species?.toUpperCase() ?? 'Unknown',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Jua',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: ShapeDecoration(
                        color: Color(0xFF8B80FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: pet.photoUrl == null
                              ? Image.asset('assets/images/kucing.png')
                              : Image.network(pet.photoUrl!,
                                  fit: BoxFit.cover)),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pet.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Jua',
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 4),
                        Icon(
                          pet.gender == 'Jantan' ? Icons.male : Icons.female,
                          color: pet.gender == 'Betina'
                              ? Colors.blue
                              : Colors.pink,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
