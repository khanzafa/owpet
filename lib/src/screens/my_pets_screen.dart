// screens/my_pets_screen.dart
import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../services/pet_service.dart';

class MyPetsScreen extends StatelessWidget {
  final String userId;
  final PetService petService = PetService();

  MyPetsScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Pets'),
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
                  subtitle: Text('${pet.species}, Age: ${pet.age}'),
                  // Tambahkan fungsi untuk mengedit atau menghapus hewan peliharaan
                );
              },
            );
          }
        },
      ),
    );
  }
}
