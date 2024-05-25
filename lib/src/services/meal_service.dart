import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMealSchedule({
    required String petId,
    required String mealType,
    required double weight,
    required TimeOfDay time,
  }) async {
    try {
      await _firestore
          .collection('meal_schedule')
          .doc(petId)
          .collection('schedules')
          .add({
        'mealType': mealType,
        'weight': weight,
        'time': '${time.hour}:${time.minute}',
      });
    } catch (e) {
      print('Error adding meal schedule: $e');
      throw e;
    }
  }

  Stream<List<DocumentSnapshot>> getMealSchedules(String petId) {
    return _firestore
        .collection('meal_schedule')
        .doc(petId)
        .collection('schedules')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Stream<DocumentSnapshot> getMealSchedule(String petId, String scheduleId) {
    return _firestore
        .collection('meal_schedule')
        .doc(petId)
        .collection('schedules')
        .doc(scheduleId)
        .snapshots();
  }

  Stream<List<DocumentSnapshot>> getMealProgress(String petId, String date) {
    return _firestore
        .collection('meal_progress')
        .doc(petId)
        .collection('daily_progress')
        .doc(date)
        .collection('progress')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<void> updateMealProgress(
      String petId, String date, String scheduleId, bool status) async {
    try {
      await _firestore
          .collection('meal_progress')
          .doc(petId)
          .collection('daily_progress')
          .doc(date)
          .collection('progress')
          .doc(scheduleId)
          .set({
        'status': status,
      });
    } catch (e) {
      print('Error updating meal progress: $e');
      throw e;
    }
  }

  Future<void> autoAddMealProgress(String petId, String date) async {
    try {
      final schedules = await _firestore
          .collection('meal_schedule')
          .doc(petId)
          .collection('schedules')
          .get();
      for (final schedule in schedules.docs) {
        final progressCollection = await _firestore
            .collection('meal_progress')
            .doc(petId)
            .collection('daily_progress')
            .doc(date)
            .collection('progress')
            .get();
        if (progressCollection.docs.length > schedules.docs.length) {
          continue;
        }
        await _firestore
            .collection('meal_progress')
            .doc(petId)
            .collection('daily_progress')
            .doc(date)
            .collection('progress')
            .doc(schedule.id)
            .set({
          'status': false,
        });
      }
      print('Auto added meal progress for $date');
    } catch (e) {
      print('Error auto adding meal progress: $e');
      throw e;
    }
  }
}


// class MealProgressService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<bool> checkTasksExist(String petId) async {
//     try {
//       final doc = await _firestore.collection('meal_progress').doc(petId).get();
//       return doc.exists;
//     } catch (e) {
//       print('Error checking tasks: $e');
//       throw e; // Atau lakukan penanganan kesalahan yang sesuai
//     }
//   }

//   Future<List<String>> getTasks(String petId) async {
//     try {
//       final doc = await _firestore.collection('meal_progress').doc(petId).get();
//       if (doc.exists) {
//         return List<String>.from(doc.data()!['tasks']);
//       } else {
//         return [];
//       }
//     } catch (e) {
//       print('Error getting tasks: $e');
//       throw e; // Atau lakukan penanganan kesalahan yang sesuai
//     }
//   }

//   Future<void> addTask(String petId, String newTask) async {
//     try {
//       // Ambil daftar tugas yang sudah ada
//       final doc = await _firestore.collection('meal_progress').doc(petId).get();
//       List<String> currentTasks = [];
//       if (doc.exists) {
//         currentTasks = List<String>.from(doc.data()!['tasks']);
//       }

//       // Tambahkan tugas baru ke dalam daftar
//       currentTasks.add(newTask);

//       // Simpan daftar tugas yang sudah diperbarui kembali ke Firestore
//       await _firestore.collection('meal_progress').doc(petId).set({
//         'tasks': currentTasks,
//       });

//       // Perbaru semua task progress
//       final progressDocs = await _firestore
//           .collection('meal_progress')
//           .doc(petId)
//           .collection('task_progress')
//           .get();

//       for (final doc in progressDocs.docs) {
//         final docProgress = await _firestore
//             .collection('meal_progress')
//             .doc(petId)
//             .collection('task_progress')
//             .doc(doc.id)
//             .get();
//         List<bool> currentProgress = [];
//         if (docProgress.exists) {
//           currentProgress = List<bool>.from(docProgress.data()!['progress']);
//         } else {
//           currentProgress = List<bool>.filled(currentTasks.length, false);
//         }
//         currentProgress.add(false);
//         await _firestore
//             .collection('meal_progress')
//             .doc(petId)
//             .collection('task_progress')
//             .doc(doc.id)
//             .update({
//           'progress': currentProgress,
          
//         });
//       }
//     } catch (e) {
//       print('Error adding task: $e');
//       throw e; // Atau lakukan penanganan kesalahan yang sesuai
//     }
//   }

//   Future<void> saveMealProgress(String petId, List<String> tasks, DateTime date,
//       List<bool> progress, String description) async {
//     try {
//       // Menyimpan tasks
//       await _firestore.collection('meal_progress').doc(petId).set({
//         'tasks': tasks,
//       });

//       // Menyimpan progres makan untuk setiap hari
//       await _firestore
//           .collection('meal_progress')
//           .doc(petId)
//           .collection('task_progress')
//           .doc(date.toString())
//           .set({
//         'progress': progress,
//         'description': description,
//       });
//     } catch (e) {
//       print('Error saving meal progress: $e');
//       throw e; // Atau lakukan penanganan kesalahan yang sesuai
//     }
//   }

//   Future<List<bool>> getTaskProgress(String petId, DateTime date) async {
//     try {
//       final doc = await _firestore
//           .collection('meal_progress')
//           .doc(petId)
//           .collection('task_progress')
//           .doc(date.toString().split(' ')[0])
//           .get();
//       if (doc.exists) {
//         return List<bool>.from(doc.data()!['progress']);
//       } else {
//         return [];
//       }
//     } catch (e) {
//       print('Error getting task progress: $e');
//       throw e; // Atau lakukan penanganan kesalahan yang sesuai
//     }
//   }

// Future<void> updateTaskProgress(
//       String petId, DateTime date, int index, bool value) async {
//     try {
//       // Ambil daftar tugas yang sudah ada
//       final doc = await _firestore.collection('meal_progress').doc(petId).get();
//       List<String> currentTasks = [];
//       if (doc.exists) {
//         currentTasks = List<String>.from(doc.data()!['tasks']);
//       }

//       // Ambil progres makan yang sudah ada
//       final progressDoc = await _firestore
//           .collection('meal_progress')
//           .doc(petId)
//           .collection('task_progress')
//           .doc(date.toString().split(' ')[0])
//           .get();
//       List<bool> currentProgress = [];
//       // List<DateTime> currentProgressTime = [];
//       if (progressDoc.exists) {
//         currentProgress = List<bool>.from(progressDoc.data()!['progress']);
//         // currentProgressTime = List<DateTime>.from(progressDoc.data()!['time']);
//       } else {
//         // Jika belum ada progres makan untuk hari ini, inisialisasi dengan nilai false
//         currentProgress = List<bool>.filled(currentTasks.length, false);
//         // currentProgressTime = List<DateTime>.filled(currentTasks.length, DateTime.now());
//       }

//       final progressDocId = progressDoc.id??DateTime.now().toString().split(' ')[0];

//       // Update nilai progres pada indeks yang sesuai
//       currentProgress[index] = value;
//       // currentProgressTime[index] = DateTime.now();

//       // Simpan progres yang sudah diperbarui kembali ke Firestore
//       await _firestore
//           .collection('meal_progress')
//           .doc(petId)
//           .collection('task_progress')
//           .doc(progressDocId)
//           .set({
//         'progress': currentProgress,
//         // 'time': currentProgressTime,
//       });
//     } catch (e) {
//       print('Error updating task progress: $e');
//       throw e; // Atau lakukan penanganan kesalahan yang sesuai
//     }
//   }

// }