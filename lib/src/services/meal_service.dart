import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:owpet/src/models/meal.dart';

class MealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMealSchedule({
    required String petId,
    required Meal meal,
  }) async {
    try {
      final mealData = meal.toJson();
      mealData.remove('id');
      await _firestore
          .collection('meal_schedule')
          .doc(petId)
          .collection('schedules')
          .add(mealData);
    } catch (e) {
      print('Error adding meal schedule: $e');
      throw e;
    }
  }

  // ADD DATA DUMMY MEAL
  Future<void> addDataDummy() async {
    List<Meal> dataMichel = [
      Meal(id: '', mealType: 'Dry Food', weight: 35, time: '07:00'),
      Meal(id: '', mealType: 'Snack', weight: 16, time: '12:00'),
      Meal(id: '', mealType: 'Wet Food', weight: 20, time: '15:00'),
      Meal(id: '', mealType: 'Dry Food', weight: 40, time: '19:00'),
    ];

    List<Meal> dataLuna = [
      Meal(id: '', mealType: 'Dry Food', weight: 30, time: '05:00'),
      Meal(id: '', mealType: 'Dry Food', weight: 34, time: '09:00'),
      Meal(id: '', mealType: 'Snack Food', weight: 16, time: '12:00'),
      Meal(id: '', mealType: 'Dry Food', weight: 32, time: '15:00'),
      Meal(id: '', mealType: 'Dry Food', weight: 40, time: '19:45'),
    ];
    String michelPetId = 'Ma5mrN25idX5yqWJUTyr';
    String lunaPetId = 'RNU5VGezHkoCjxaRWlUN';

    for (var meal in dataMichel) {
      await addMealSchedule(petId: michelPetId, meal: meal);
    }

    for (var meal in dataLuna) {
      await addMealSchedule(petId: lunaPetId, meal: meal);
    }

    print('Data Dummy Added');
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

  Future<void> updateMealSchedule(
      String petId, String scheduleId, Meal meal) async {
    try {
      final mealData = meal.toJson();
      mealData.remove('id');
      await _firestore
          .collection('meal_schedule')
          .doc(petId)
          .collection('schedules')
          .doc(scheduleId)
          .update(mealData);
    } catch (e) {
      print('Error updating meal schedule: $e');
      throw e;
    }
  }

  Future<void> deleteMealSchedule(String petId, String scheduleId) async {
    try {
      await _firestore
          .collection('meal_schedule')
          .doc(petId)
          .collection('schedules')
          .doc(scheduleId)
          .delete();
    } catch (e) {
      print('Error deleting meal schedule: $e');
      throw e;
    }
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
      print("Update Meal Progress: $petId, $date, $scheduleId, $status");
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

      // Check if all meal progress items are complete
      final progressCollection = await _firestore
          .collection('meal_progress')
          .doc(petId)
          .collection('daily_progress')
          .doc(date)
          .collection('progress')
          .get();

      bool allCompleted =
          progressCollection.docs.every((doc) => doc.data()['status'] == true);

      if (allCompleted) {
        print("All meal progress items are complete");
        await completeMealProgressDay(petId, date);
      } else {
        print("Not all meal progress items are complete");
        await uncompleteMealProgressDay(petId, date);
      }
    } catch (e) {
      print('Error updating meal progress: $e');
      throw e;
    }
  }

  Future<void> completeMealProgressDay(String petId, String date) async {
    try {
      final progressDoc = await _firestore
          .collection('meal_progress')
          .doc(petId)
          .collection('daily_progress')
          .doc(date)
          .get();
      await progressDoc.reference.set({'isCompleted': true});
      print('Completed meal progress for $date');
    } catch (e) {
      print('Error completing meal progress: $e');
      throw e;
    }
  }

  Future<void> uncompleteMealProgressDay(String petId, String date) async {
    try {
      final progressDoc = await _firestore
          .collection('meal_progress')
          .doc(petId)
          .collection('daily_progress')
          .doc(date)
          .get();
      await progressDoc.reference.set({'isCompleted': false});
      print('Uncompleted meal progress for $date');
    } catch (e) {
      print('Error uncompleting meal progress: $e');
      throw e;
    }
  }

  Future<void> autoAddMealProgress(String petId, String date) async {
    try {
      final schedulesSnapshot = await _firestore
          .collection('meal_schedule')
          .doc(petId)
          .collection('schedules')
          .get();

      final progressSnapshot = await _firestore
          .collection('meal_progress')
          .doc(petId)
          .collection('daily_progress')
          .doc(date)
          .collection('progress')
          .get();

      final existingProgressIds =
          progressSnapshot.docs.map((doc) => doc.id).toSet();
      final scheduleIds = schedulesSnapshot.docs.map((doc) => doc.id).toList();

      for (final scheduleId in scheduleIds) {
        if (!existingProgressIds.contains(scheduleId)) {
          await _firestore
              .collection('meal_progress')
              .doc(petId)
              .collection('daily_progress')
              .doc(date)
              .collection('progress')
              .doc(scheduleId)
              .set({'status': false});
        }
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