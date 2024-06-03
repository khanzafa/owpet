import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:owpet/src/models/chart.dart';

class TaskCompletionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ChartData>> calculateDailyTaskCompletionRate(String userId) async {
    List<ChartData> chartData = [];
    Map<DateTime, List<bool>> taskCompletionMap = {};

    try {
      // Get all pets
      final petsSnapshot = await _firestore.collection('users').doc(userId).collection('pets').get();
      for (var petDoc in petsSnapshot.docs) {
        String petId = petDoc.id;

        // Get grooming progress
        final groomingSnapshots = await _firestore
            .collection('grooming_progress')
            .doc(petId)
            .collection('task_progress')
            .get();

        // Get health progress
        final healthSnapshots = await _firestore
            .collection('health_progress')
            .doc(petId)
            .collection('task_progress')
            .get();

        // Get meal progress
        final mealSnapshots = await _firestore
            .collection('meal_progress')
            .doc(petId)
            .collection('daily_progress')
            .get();

        // Process grooming data
        for (var doc in groomingSnapshots.docs) {
          DateTime date = DateTime.parse(doc.id);
          List<bool> progress = List<bool>.from(doc.data()['progress']);
          taskCompletionMap[date] = (taskCompletionMap[date] ?? []) + progress;
        }

        // Process health data
        for (var doc in healthSnapshots.docs) {
          DateTime date = DateTime.parse(doc.id);
          List<bool> progress = List<bool>.from(doc.data()['progress']);
          taskCompletionMap[date] = (taskCompletionMap[date] ?? []) + progress;
        }

        // Process meal data
        for (var doc in mealSnapshots.docs) {
          DateTime date = DateTime.parse(doc.id);
          final mealProgressSnapshots = await doc.reference.collection('progress').get();
          for (var mealDoc in mealProgressSnapshots.docs) {
            bool status = mealDoc.data()['status'];
            taskCompletionMap[date] = (taskCompletionMap[date] ?? []) + [status];
          }
        }
      }

      // Calculate completion rates
      taskCompletionMap.forEach((date, tasks) {
        int completedTasks = tasks.where((task) => task).length;
        double completionRate = (completedTasks / tasks.length) * 100;
        chartData.add(ChartData(date, completionRate));
      });

      // Sort chart data by date
      chartData.sort((a, b) => a.date.compareTo(b.date));

    } catch (e) {
      print('Error calculating daily task completion rate: $e');
      throw e;
    }

    return chartData;
  }
}
