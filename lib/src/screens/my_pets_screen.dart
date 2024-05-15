import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:owpet/src/screens/add_profile.dart';
import 'package:owpet/src/screens/detail_pet_screen.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';

class MyPetsScreen extends StatelessWidget {
  final String userId;
  final PetService petService = PetService();

  MyPetsScreen({required this.userId});

  void _navigateToAddPetScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProfile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8B80FF), // Purple background color
        title: Text(
          'Pets',
          style: TextStyle(
            fontFamily: 'Jua',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Color(0xFF8B80FF),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 352,
                height: 41,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16), // Add space between search bar and category buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildCategoryButton('All'),
                buildCategoryButton('Anjing'),
                buildCategoryButton('Kucing'),
                buildCategoryButton('Kelinci'),
                buildCategoryButton('Burung'),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Pet>>(
              future: petService.getMyPets(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
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
        padding: const EdgeInsets.all(20.0), // Adjust padding as needed
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
    return Container(
      width: 68,
      height: 31,
      decoration: BoxDecoration(
        color: Color(0xFF8B80FF), // Purple background color
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          category,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Jua',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget buildPetCard(Pet pet) {
    return Container(
      width: 170,
      height: 222,
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
            width: 170,
            height: 31,
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
              child: Text(
                pet.species,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Jua',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
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
                      child: Image.asset(
                        'assets/images/flutter_logo.png', // Replace with your placeholder image path
                        fit: BoxFit.cover,
                      ),
                    ),
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
                      SizedBox(width: 4), // Add space between pet name and gender icon
                      Icon(
                        pet.gender == 'Male' ? Icons.male : Icons.female,
                        color: pet.gender == 'Male' ? Colors.blue : Colors.pink,
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
}