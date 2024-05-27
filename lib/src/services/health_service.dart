import 'package:cloud_firestore/cloud_firestore.dart';

class HealthProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const List<String> _tasks = [
    'Cek Mata',
    'Cek Telinga',
    'Cek Berat Badan',
    'Cek Suhu Tubuh',
    'Cek Kulit',
    'Vaksinasi',
  ];

  Future<bool> checkTasksExist(String petId) async {
    try {
      final doc =
          await _firestore.collection('health_progress').doc(petId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking tasks: $e');
      throw e;
    }
  }

  Future<List<String>> getTasks(String petId) async {
    return _tasks;
  }

  Future<Map<DateTime, int>> getCompletedTasks(String petId) async {
    Map<DateTime, int> completedTasksPerDate = {};

    try {
      // Ambil semua task untuk petId yang diberikan
      QuerySnapshot tasksSnapshot = await _firestore
          .collection('pets')
          .doc(petId)
          .collection('tasks')
          .get();

      // Iterasi melalui setiap task
      for (QueryDocumentSnapshot taskDoc in tasksSnapshot.docs) {
        // Ambil tanggal dan status penyelesaian task
        Map<String, dynamic>? taskData =
            taskDoc.data() as Map<String, dynamic>?;
        DateTime? taskDate = taskData?['date']?.toDate();
        bool? completed = taskData?['completed'];

        // Jika task diselesaikan, tambahkan ke completedTasksPerDate
        if (completed == true && taskDate != null) {
          completedTasksPerDate.update(
            taskDate,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
      }
    } catch (e) {
      print('Error getting completed tasks: $e');
    }

    return completedTasksPerDate;
  }

  Future<List<bool>> getTaskProgress(String petId, DateTime date) async {
    try {
      final doc = await _firestore
          .collection('health_progress')
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
      throw e;
    }
  }

  Future<void> updateTaskProgress(
      String petId, DateTime date, int index, bool value) async {
    try {
      // Ambil progres makan yang sudah ada
      final progressDoc = await _firestore
          .collection('health_progress')
          .doc(petId)
          .collection('task_progress')
          .doc(date.toString().split(' ')[0])
          .get();
      List<bool> currentProgress = [];
      if (progressDoc.exists) {
        currentProgress = List<bool>.from(progressDoc.data()!['progress']);
      } else {
        // Jika belum ada progres makan untuk hari ini, inisialisasi dengan nilai false
        currentProgress = List<bool>.filled(_tasks.length, false);
      }

      final progressDocId =
          progressDoc.id ?? DateTime.now().toString().split(' ')[0];

      // Update nilai progres pada indeks yang sesuai
      currentProgress[index] = value;

      // Simpan progres yang sudah diperbarui kembali ke Firestore
      await _firestore
          .collection('health_progress')
          .doc(petId)
          .collection('task_progress')
          .doc(progressDocId)
          .set({
        'progress': currentProgress,
      });
    } catch (e) {
      print('Error updating task progress: $e');
      throw e;
    }
  }
}
