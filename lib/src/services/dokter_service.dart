import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:owpet/src/models/doctor.dart';

class DokterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<List<Dokter>> getDoctors() async {
    final doctors = await _firestore.collection('doctors').get();
    if (doctors.docs.isEmpty) {
      return [];
    }
    return doctors.docs
        .map((doctor) => Dokter.fromJson(doctor.data()))
        .toList();
  }

  Future<String> uploadImage(File image) async {
    final ref = _firebaseStorage.ref().child('doctors/${DateTime.now()}.png');
    await ref.putFile(image);
    return ref.getDownloadURL();
  }

  Future<void> addDoctor(Dokter doctor) async {
    await _firestore.collection('doctors').add({
      'name': doctor.name,
      'speciality': doctor.speciality,
      'location': doctor.location,
      'imageUrl': doctor.imageUrl,
      'timeOpen': doctor.timeOpen,
    });
  }

  // Future<void> updateDoctor(Dokter doctor) async {
  //   await _firestore.collection('doctors').doc(doctor.id).update({
  //     'name': doctor.name,
  //     'speciality': doctor.speciality,
  //     'location': doctor.location,
  //     'imageUrl': doctor.imageUrl,
  //     'timeOpen': doctor.timeOpen,
  //   });
  // }

  Future<void> deleteDoctor(String id) async {
    await _firestore.collection('doctors').doc(id).delete();
  }

  // Future<Dokter> getDoctor(String id) async {
  //   final doctor = await _firestore.collection('doctors').doc(id).get();
  //   return Dokter.fromJson(doctor.data());
  // }

  // Add data dummy
  final dataDummy = [
    Dokter(
      name: 'Dr. John Doe',
      speciality: 'General Practitioner',
      location: 'Jl. Kaliurang No. 10',
      timeOpen: '08:00 - 17:00',
      imageUrl: 'https://source.unsplash.com/random/?general-practitioner',
    ),
    Dokter(
      name: 'Dr. Ayustia Darmawanti',
      speciality: 'Mata dan Hidung',
      location: 'Jl Basuki Rahmad No 19, Lamongan',
      timeOpen: '08:00 - 12:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?eye-doctor',
    ),
    Dokter(
      name: 'Dr. Budi Santoso',
      speciality: 'Bedah Hewan',
      location: 'Jl Ahmad Yani No 27, Surabaya',
      timeOpen: '09:00 - 13:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?veterinarian',
    ),
    Dokter(
      name: 'Dr. Clara Widya',
      speciality: 'Kulit',
      location: 'Jl Diponegoro No 56, Malang',
      timeOpen: '10:00 - 14:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?skin-doctor',
    ),
    Dokter(
      name: 'Dr. Dian Rahmawati',
      speciality: '-',
      location: 'Jl Pemuda No 10, Semarang',
      timeOpen: '11:00 - 15:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?doctor',
    ),
    Dokter(
      name: 'Dr. Eko Prasetyo',
      speciality: 'Telinga',
      location: 'Jl Gajah Mada No 33, Denpasar',
      timeOpen: '08:00 - 12:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?ear-doctor',
    ),
    Dokter(
      name: 'Dr. Fani Andriani',
      speciality: '-',
      location: 'Jl Sudirman No 18, Jakarta',
      timeOpen: '09:00 - 13:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?doctor',
    ),
    Dokter(
      name: 'Dr. Gita Puspitasari',
      speciality: 'Gigi dan Mulut',
      location: 'Jl Panglima Sudirman No 45, Bogor',
      timeOpen: '10:00 - 14:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?dentist',
    ),
    Dokter(
      name: 'Dr. Heru Wibowo',
      speciality: '-',
      location: 'Jl Kartini No 22, Yogyakarta',
      timeOpen: '11:00 - 15:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?doctor',
    ),
    Dokter(
      name: 'Dr. Indah Susanti',
      speciality: 'Saraf dan Bedah',
      location: 'Jl Hasanuddin No 12, Makassar',
      timeOpen: '08:00 - 12:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?neurologist',
    ),
    Dokter(
      name: 'Dr. Joko Riyanto',
      speciality: '-',
      location: 'Jl Merdeka No 44, Medan',
      timeOpen: '09:00 - 13:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?doctor',
    ),
    Dokter(
      name: 'Dr. Karina Utami',
      speciality: 'Mata',
      location: 'Jl Dipatiukur No 31, Bandung',
      timeOpen: '10:00 - 14:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?eye-doctor',
    ),
    Dokter(
      name: 'Dr. Lestari Wijaya',
      speciality: '-',
      location: 'Jl Dr. Sutomo No 17, Pekanbaru',
      timeOpen: '11:00 - 15:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?doctor',
    ),
    Dokter(
      name: 'Dr. M. Nurhadi',
      speciality: '-',
      location: 'Jl Juanda No 8, Pontianak',
      timeOpen: '08:00 - 12:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?doctor',
    ),
    Dokter(
      name: 'Dr. Nia Pratiwi',
      speciality: '-',
      location: 'Jl Imam Bonjol No 27, Palembang',
      timeOpen: '09:00 - 13:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?doctor',
    ),
    Dokter(
      name: 'Dr. Oka Putra',
      speciality: 'Bedah',
      location: 'Jl Pahlawan No 3, Samarinda',
      timeOpen: '10:00 - 14:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?surgeon',
    ),
    Dokter(
      name: 'Dr. Putri Ayu',
      speciality: 'Gigi dan Mulut',
      location: 'Jl Kebon Jeruk No 19, Jakarta',
      timeOpen: '11:00 - 15:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?dentist',
    ),
    Dokter(
      name: 'Dr. Qori Azizah',
      speciality: 'Penyakit Kulit',
      location: 'Jl Diponegoro No 15, Madiun',
      timeOpen: '08:00 - 12:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?skin-doctor',
    ),
    Dokter(
      name: 'Dr. Rina Amelia',
      speciality: '-',
      location: 'Jl Basuki Rahmat No 21, Balikpapan',
      timeOpen: '09:00 - 13:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?doctor',
    ),
    Dokter(
      name: 'Dr. Satria Nugraha',
      speciality: '-',
      location: 'Jl Cendana No 2, Surabaya',
      timeOpen: '10:00 - 14:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?doctor',
    ),
    Dokter(
      name: 'Dr. Tiara Rahayu',
      speciality: '-',
      location: 'Jl Anggrek No 7, Malang',
      timeOpen: '11:00 - 15:00 WIB',
      imageUrl: 'https://source.unsplash.com/random/?doctor',
    ),
  ];

  Future<void> addDummyData() async {
    for (final doctor in dataDummy) {
      await addDoctor(doctor);
    }
  }
}
