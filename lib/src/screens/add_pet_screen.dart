import 'package:flutter/material.dart';
import 'package:owpet/src/services/pet_service.dart';
import 'package:owpet/src/models/pet.dart';

class AddPetScreen extends StatelessWidget {
  final String userId = 'qUtR4Sp5FAHyOpmxeD9l';
  final PetService petService = PetService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AddPetScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Pet'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: genderController,
                decoration: InputDecoration(labelText: 'Gender'),
              ),
              TextField(
                controller: statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
              TextField(
                controller: birthdayController,
                decoration: InputDecoration(labelText: 'Birthday'),
              ),
              TextField(
                controller: speciesController,
                decoration: InputDecoration(labelText: 'Species'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Pet pet = Pet(
                    id: '',
                    name: nameController.text,
                    gender: genderController.text,
                    status: statusController.text,
                    birthday: birthdayController.text,
                    species: speciesController.text,
                    description: descriptionController.text,
                  );

                  petService.addPet(userId, pet).then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Text('Add Pet'),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
