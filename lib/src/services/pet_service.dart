// firebase/pet_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet.dart';

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Pet>> getMyPets(String userId) async {
    List<Pet> myPets = [];

    try {
      QuerySnapshot snapshot = await _firestore.collection('users').doc(userId).collection('pets').get();

      snapshot.docs.forEach((doc) {
        myPets.add(Pet(
          id: doc.id,
          name: doc['name'],
          species: doc['species'],
          age: doc['age'],
        ));
      });
    } catch (e) {
      print('Error getting pets: $e');
    }

    return myPets;
  }
}
