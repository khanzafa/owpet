// firebase/pet_service.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:owpet/src/models/user.dart';
import 'package:owpet/src/models/pet.dart';

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<List<Pet>> getMyPets(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('pets')
          .get();

      // if (snapshot.docs.isEmpty) {
      //   await addDummyPets(userId);
      //   return [];
      // }
      
      final pets = snapshot.docs
          .map((doc) => Pet.fromJson({'id': doc.id, ...doc.data()}))
          .toList();

      print('Pets: ${pets.map((pet) => pet.name).toList()}');
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
      final file = File(filePath);
      if (!file.existsSync()) {
        return null;
      }
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
      final petData = pet.toJson();
      final petId = pet.id;
      petData.remove('id');
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('pets')
          .doc(petId)
          .update(petData);
      if (pet.photoUrl != null) {
        final photoUrl = await uploadImage(userId, petId, pet.photoUrl!);
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('pets')
            .doc(petId)
            .update({'photoUrl': photoUrl});
      }
    } catch (e) {
      print('Error updating pet: $e');
    }
  }

  // ADD DUMMY PETS
  Future addDummyPets(String userId) async {
    final List<Pet> pets = [
      Pet(
        id: '',
        name: 'Michel',
        birthday: DateTime(2019, 1, 24).toIso8601String().split('T')[0],
        gender: 'Jantan',
        species: 'Persia',
        status: 'Kawin',
        description:
            'Peliharaan satu satunya yang imut,lucu,sangat menyayangi, lincah dan sehat',
        photoUrl: null,
      ),
      Pet(
        id: '',
        name: 'Luna',
        birthday: DateTime(2024, 1, 12).toIso8601String().split('T')[0],
        gender: 'Betina',
        species: 'British Shorthair',
        status: 'Steril',
        description:
            'Luna anabul yang cantik, nurut, memiliki bulu pendek yang cantik',
        photoUrl: null,
      ),
      Pet(
        id: '',
        name: 'Ndut',
        birthday: DateTime(2023, 2, 15).toIso8601String().split('T')[0],
        gender: 'Jantan',
        species: 'American Shorthair',
        status: 'Kawin',
        description:
            'Kucing Gemuk yang rakus makan, suka tidur dan jalan jalan',
        photoUrl: null,
      ),
      Pet(
        id: '',
        name: 'Emon',
        birthday: DateTime(2022, 1, 1).toIso8601String().split('T')[0],
        gender: 'Jantan',
        species: 'Anggora',
        status: 'Kawin',
        description:
            'Penurut, suka tidur di bawah meja, Berisik dan lagi jatuh cinta',
        photoUrl: null,
      ),
      Pet(
        id: '',
        name: 'Mona',
        birthday: DateTime(2020, 3, 15).toIso8601String().split('T')[0],
        gender: 'Betina',
        species: 'Persia',
        status: 'Steril',
        description:
            'Kucing yang elegan, pintar, dan sangat menyayangi pemiliknya. Luna juga sangat aktif dan senang bermain.',
        photoUrl: null,
      ),
      Pet(
        id: '',
        name: 'Mochi',
        birthday: DateTime(2021, 12, 22).toIso8601String().split('T')[0],
        gender: 'Betina',
        species: 'Domestik',
        status: 'Kawin',
        description:
            'Mochi udah punya anak 5 dan lucu lucu banget, penyang anak anak nya',
        photoUrl: null,
      ),
      Pet(
        id: '',
        name: 'Max',
        birthday: DateTime(2021, 5, 5).toIso8601String().split('T')[0],
        gender: 'Jantan',
        species: 'American Shorthair',
        status: 'Steril',
        description:
            'Max adalah kucing yang sangat energik dan penuh rasa ingin tahu. Dia suka memanjat dan menjelajahi sekelilingnya. Bulu berbelang khasnya membuatnya tampak seperti miniatur macan tutul.',
        photoUrl: null,
      ),
      Pet(
        id: '',
        name: 'Chloe',
        birthday: DateTime(2022, 11, 10).toIso8601String().split('T')[0],
        gender: 'Betina',
        species: 'British Shorthair',
        status: 'Kawin',
        description:
            'Chloe adalah kucing yang lucu dengan telinga melipat khas rasnya. Dia sangat ramah dan suka bermain, terutama dengan bola kecil atau mainan berbulu.',
        photoUrl: null,
      ),
      Pet(
        id: '',
        name: 'Oliver',
        birthday: DateTime(2019, 9, 17).toIso8601String().split('T')[0],
        gender: 'Jantan',
        species: 'British Shorthair',
        status: 'Kawin',
        description:
            'Oliver adalah kucing yang sangat tenang dan penyayang. Bulu panjangnya yang halus dan kebiasaannya yang suka digendong membuatnya sangat cocok sebagai hewan peliharaan yang menenangkan.',
        photoUrl: null,
      ),
      Pet(
        id: '',
        name: 'Bita',
        birthday: DateTime(2019, 1, 25).toIso8601String().split('T')[0],
        gender: 'Betina',
        species: 'Domestik',
        status: 'Kawin',
        description:
            'kucing yang sangat aktif dan penuh energi. Dengan bulu pendek yang berkilau dan sifatnya yang suka bersosialisasi, Daisy selalu menjadi pusat perhatian di rumah.',
        photoUrl: null,
      ),
    ];

    for (var pet in pets) {
      await addPet(userId, pet);
    }
    print("Dummy pets added successfully!");
  }
}
