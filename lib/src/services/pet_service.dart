// firebase/pet_service.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:owpet/src/models/user.dart';
import 'package:owpet/src/models/pet.dart';

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  // Future<List<Forum>> getForums() async {
  //   try {
  //     final snapshot = await _firestore.collection('forums').get();
  //     return snapshot.docs
  //         .map((doc) => Forum.fromJson({'id': doc.id, ...doc.data()}))
  //         .toList();
  //   } catch (e) {
  //     print('Error getting forums: $e');
  //     throw e;
  //   }
  // }

  Future<List<Pet>> getMyPets(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('pets')
          .get();
      final pets = snapshot.docs
          .map((doc) => Pet.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      print(
          'Pets: ${pets.map((pet) => pet.name).toList()}'
      );
      return pets;
    } catch (e) {
      print('Error getting pets: $e');
      throw e;
    }
  }

  // add new pet
  Future addPet(String userId, Pet pet) async {
    try {
      final petData = pet.toJson();
      petData.remove('id');
      final result = await _firestore
          .collection('users')
          .doc(userId)
          .collection('pets')
          .add(petData);
      if (pet.photoUrl != null) {
        final photoUrl = await uploadImage(userId, result.id, pet.photoUrl!);
        await result.update({'photoUrl': photoUrl});
      }
      // final photoUrl = await uploadImage(userId, result.id, pet.photoUrl);
      // await result.update({'photoUrl': photoUrl});
    } catch (e) {
      print('Error adding pet: $e');
    }
  }

  // upload image
  Future uploadImage(String userId, String petId, String filePath) async {
    try {
      final ref = storage.ref().child('users/$userId/pets/$petId.jpg');
      final result = await ref.putFile(File(filePath));
      final url = await result.ref.getDownloadURL();

      return url;
    } catch (e) {
      print('Error uploading image: $e');
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
        'photoUrl': pet.photoUrl,
      });
    } catch (e) {
      print('Error updating pet: $e');
    }
  }
}
