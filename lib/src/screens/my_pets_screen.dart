// screens/my_pets_screen.dart
import 'package:flutter/material.dart';
import 'package:owpet/src/screens/add_pet_screen.dart';
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
      MaterialPageRoute(builder: (context) => AddPetScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Pets'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddPetScreen(context),
        tooltip: 'Add New Pet',
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Pet>>(
        future: petService.getMyPets(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Pet> myPets = snapshot.data ?? [];
            return ListView.builder(
              itemCount: myPets.length,
              itemBuilder: (context, index) {
                Pet pet = myPets[index];
                return ListTile(
                  title: Text(pet.name),
                  subtitle: Text(pet.species),
                  // Fungsi melihat detail pet
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetailScreen(pet: pet),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
