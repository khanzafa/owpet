import 'package:flutter/material.dart';
import 'package:owpet/src/screens/grooming_monitoring_screen.dart';
import 'package:owpet/src/screens/meal_monitoring_screen.dart';
import '../models/pet.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;

  PetDetailScreen({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${pet.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('ID: ${pet.id}'),
            Text('Birthday: ${pet.birthday}'),
            Text('Gender: ${pet.gender}'),
            Text('Species: ${pet.species}'),
            Text('Status: ${pet.status}'),
            if (pet.description != null) // Tampilkan deskripsi hanya jika ada
              Text('Description: ${pet.description}'),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text('Grooming Monitoring'),
                subtitle: Text('Monitor your pet\'s grooming schedule'),
                onTap: () {
                  // Navigasi ke halaman monitoring perawatan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroomingMonitoringScreen(
                        petId: pet.id,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Card untuk ke halaman monitoring makan
            Card(
              child: ListTile(
                title: Text('Feeding Monitoring'),
                subtitle: Text('Monitor your pet\'s feeding schedule'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealMonitoringScreen(
                        petId: pet.id,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Card untuk ke halaman monitoring kesehatan
            Card(
              child: ListTile(
                title: Text('Health Monitoring'),
                subtitle: Text('Monitor your pet\'s health status'),
                onTap: () {
                  // Navigasi ke halaman monitoring kesehatan
                },
              ),
            ),
            // Card untuk ke halaman monitoring perawatan
          ],
        ),
      ),
    );
  }
}
