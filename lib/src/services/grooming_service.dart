import 'package:cloud_firestore/cloud_firestore.dart';

class GroomingProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const List<String> _tasks = [
    'Perawatan Mata',
    'Perawatan Telinga',
    'Perawatan Gigi',
    'Perawatan Kulit dan Bulu',
    'Perawatan Kuku',
    'Mandi',
  ];

  Future<bool> checkTasksExist(String petId) async {
    try {
      final doc =
          await _firestore.collection('grooming_progress').doc(petId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking tasks: $e');
      throw e;
    }
  }

  Future<List<String>> getTasks(String petId) async {
    return _tasks;
  }

  Future<List<bool>> getTaskProgress(String petId, DateTime date) async {
    try {
      final doc = await _firestore
          .collection('grooming_progress')
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
          .collection('grooming_progress')
          .doc(petId)
          .collection('task_progress')
          .doc(date.toString().split(' ')[0])
          .get();
      List<bool> currentProgress = [];
      if (progressDoc.exists) {
        currentProgress = List<bool>.from(progressDoc.data()!['progress']);
      } else {
        currentProgress = List<bool>.filled(_tasks.length, false);
      }

      final progressDocId =
          progressDoc.id ?? DateTime.now().toString().split(' ')[0];

      // Update nilai progres pada indeks yang sesuai
      currentProgress[index] = value;

      // Simpan progres yang sudah diperbarui kembali ke Firestore
      await _firestore
          .collection('grooming_progress')
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