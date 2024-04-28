import 'package:cloud_firestore/cloud_firestore.dart';

class MealProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkTasksExist(String petId) async {
    try {
      final doc = await _firestore.collection('meal_progress').doc(petId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking tasks: $e');
      throw e; // Atau lakukan penanganan kesalahan yang sesuai
    }
  }

  Future<List<String>> getTasks(String petId) async {
    try {
      final doc = await _firestore.collection('meal_progress').doc(petId).get();
      if (doc.exists) {
        return List<String>.from(doc.data()!['tasks']);
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting tasks: $e');
      throw e; // Atau lakukan penanganan kesalahan yang sesuai
    }
  }

  Future<void> addTask(String petId, String newTask) async {
    try {
      // Ambil daftar tugas yang sudah ada
      final doc = await _firestore.collection('meal_progress').doc(petId).get();
      List<String> currentTasks = [];
      if (doc.exists) {
        currentTasks = List<String>.from(doc.data()!['tasks']);
      }

      // Tambahkan tugas baru ke dalam daftar
      currentTasks.add(newTask);

      // Simpan daftar tugas yang sudah diperbarui kembali ke Firestore
      await _firestore.collection('meal_progress').doc(petId).set({
        'tasks': currentTasks,
      });

      // Perbaru semua task progress
      final progressDocs = await _firestore
          .collection('meal_progress')
          .doc(petId)
          .collection('task_progress')
          .get();

      for (final doc in progressDocs.docs) {
        final docProgress = await _firestore
            .collection('meal_progress')
            .doc(petId)
            .collection('task_progress')
            .doc(doc.id)
            .get();
        List<bool> currentProgress = [];
        if (docProgress.exists) {
          currentProgress = List<bool>.from(docProgress.data()!['progress']);
        } else {
          currentProgress = List<bool>.filled(currentTasks.length, false);
        }
        currentProgress.add(false);
        await _firestore
            .collection('meal_progress')
            .doc(petId)
            .collection('task_progress')
            .doc(doc.id)
            .update({
          'progress': currentProgress,
          
        });
      }
    } catch (e) {
      print('Error adding task: $e');
      throw e; // Atau lakukan penanganan kesalahan yang sesuai
    }
  }

  Future<void> saveMealProgress(String petId, List<String> tasks, DateTime date,
      List<bool> progress, String description) async {
    try {
      // Menyimpan tasks
      await _firestore.collection('meal_progress').doc(petId).set({
        'tasks': tasks,
      });

      // Menyimpan progres makan untuk setiap hari
      await _firestore
          .collection('meal_progress')
          .doc(petId)
          .collection('task_progress')
          .doc(date.toString())
          .set({
        'progress': progress,
        'description': description,
      });
    } catch (e) {
      print('Error saving meal progress: $e');
      throw e; // Atau lakukan penanganan kesalahan yang sesuai
    }
  }

  Future<List<bool>> getTaskProgress(String petId, DateTime date) async {
    try {
      final doc = await _firestore
          .collection('meal_progress')
          .doc(petId)
          .collection('task_progress')
          .doc(date.toString().split(' ')[0])
          .get();
      if (doc.exists) {
        return List<bool>.from(doc.data()!['progress']);
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting task progress: $e');
      throw e; // Atau lakukan penanganan kesalahan yang sesuai
    }
  }

Future<void> updateTaskProgress(
      String petId, DateTime date, int index, bool value) async {
    try {
      // Ambil daftar tugas yang sudah ada
      final doc = await _firestore.collection('meal_progress').doc(petId).get();
      List<String> currentTasks = [];
      if (doc.exists) {
        currentTasks = List<String>.from(doc.data()!['tasks']);
      }

      // Ambil progres makan yang sudah ada
      final progressDoc = await _firestore
          .collection('meal_progress')
          .doc(petId)
          .collection('task_progress')
          .doc(date.toString().split(' ')[0])
          .get();
      List<bool> currentProgress = [];
      // List<DateTime> currentProgressTime = [];
      if (progressDoc.exists) {
        currentProgress = List<bool>.from(progressDoc.data()!['progress']);
        // currentProgressTime = List<DateTime>.from(progressDoc.data()!['time']);
      } else {
        // Jika belum ada progres makan untuk hari ini, inisialisasi dengan nilai false
        currentProgress = List<bool>.filled(currentTasks.length, false);
        // currentProgressTime = List<DateTime>.filled(currentTasks.length, DateTime.now());
      }

      final progressDocId = progressDoc.id??DateTime.now().toString().split(' ')[0];

      // Update nilai progres pada indeks yang sesuai
      currentProgress[index] = value;
      // currentProgressTime[index] = DateTime.now();

      // Simpan progres yang sudah diperbarui kembali ke Firestore
      await _firestore
          .collection('meal_progress')
          .doc(petId)
          .collection('task_progress')
          .doc(progressDocId)
          .set({
        'progress': currentProgress,
        // 'time': currentProgressTime,
      });
    } catch (e) {
      print('Error updating task progress: $e');
      throw e; // Atau lakukan penanganan kesalahan yang sesuai
    }
  }

}
