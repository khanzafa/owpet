import 'package:flutter/material.dart';
import 'package:owpet/src/services/pet_service.dart';
import 'package:owpet/src/models/pet.dart';

class EditPetScreen extends StatefulWidget {
  final String userId;
  final Pet pet;

  const EditPetScreen({Key? key, required this.userId, required this.pet})
      : super(key: key);

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final PetService petService = PetService();
  final TextEditingController profileController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.pet.name;
    genderController.text = widget.pet.gender;
    statusController.text = widget.pet.status;
    birthdayController.text = widget.pet.birthday;
    speciesController.text = widget.pet.species;
    descriptionController.text = widget.pet.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Pet'),
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
                  Pet updatedPet = Pet(
                    id: widget.pet.id,
                    profile: profileController.text, // Use existing ID from the passed pet
                    name: nameController.text,
                    gender: genderController.text,
                    status: statusController.text,
                    birthday: birthdayController.text,
                    species: speciesController.text,
                    description: descriptionController.text,
                  );

                  petService.updatePet(widget.pet.id, updatedPet).then((value) {
                    Navigator.pop(context);
                  });
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
