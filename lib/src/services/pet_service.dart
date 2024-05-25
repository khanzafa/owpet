// firebase/pet_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet.dart';

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Pet>> getMyPets(String userId) async {
    List<Pet> myPets = [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('pets')
          .get();

      snapshot.docs.forEach((doc) {
        myPets.add(Pet(
          id: doc.id,
          name: doc['name'],
          species: doc['species'],
          birthday: doc['birthday'],
          gender: doc['gender'],
          status: doc['status'],
          description: doc['description'],
        ));
      });
    } catch (e) {
      print('Error getting pets: $e');
    }

    print("My Pets: $myPets");
    return myPets;
  }

  // add new pet
  Future addPet(String userId, Pet pet) async {
    try {
      await _firestore.collection('users').doc(userId).collection('pets').add({
        'name': pet.name,
        'species': pet.species,
        'birthday': pet.birthday,
        'gender': pet.gender,
        'status': pet.status,
        'description': pet.description,
      });
    } catch (e) {
      print('Error adding pet: $e');
    }
  }

  // update pet
  Future updatePet(String userId, Pet pet) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('pets')
          .doc(pet.id)
          .update({
        'name': pet.name,
        'species': pet.species,
        'birthday': pet.birthday,
        'gender': pet.gender,
        'status': pet.status,
        'description': pet.description,
      });
    } catch (e) {
      print('Error updating pet: $e');
    }
  }
}
