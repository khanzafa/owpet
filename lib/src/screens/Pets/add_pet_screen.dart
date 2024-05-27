import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/services/pet_service.dart';
import 'package:owpet/src/models/pet.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddPetScreen extends StatefulWidget {
  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final String userId = 'qUtR4Sp5FAHyOpmxeD9l';
  final PetService petService = PetService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  String? gender;
  String? status;
  String? species;
  DateTime? birthday;
  File? _image;

  final List<String> genderOptions = ['Jantan', 'Betina'];
  final List<String> statusOptions = ['Kawin', 'Steril'];
  final List<String> speciesOptions = [
    'Persia',
    'Domestik',
    'Anggora',
    'British Shorthair',
    'American Shorthair'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != birthday)
      setState(() {
        birthday = picked;
        birthdayController.text = picked.toIso8601String().split('T')[0];
      });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Image.asset(
              'assets/images/icon-park-solid_back.png',
              height: 24, // Set height according to your needs
              width: 24, // Set width according to your needs
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Tambahkan Hewan Baru',
            style: GoogleFonts.jua(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.grey[700],
                        )
                      : null,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                style: GoogleFonts.jua(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(139, 128, 255, 0.3),
                  prefixIcon: Icon(Icons.pets),
                  hintText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: birthdayController,
                style: GoogleFonts.jua(fontSize: 14.0),
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(139, 128, 255, 0.3),
                  prefixIcon: Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_month),
                    onPressed: () => _selectDate(context),
                  ),
                  hintText: 'Tanggal Lahir (YYYY-MM-DD)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(children: [
                Expanded(
                    child: DropdownButtonFormField<String>(
                  value: gender,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(139, 128, 255, 0.3),
                    prefixIcon: Icon(Icons.wc),
                    hintText: 'Gender',
                    hintStyle: GoogleFonts.jua(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  items: genderOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.jua(),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      gender = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    gender = value;
                  },
                )),
                SizedBox(width: 16.0),
                Expanded(
                    child: DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(139, 128, 255, 0.3),
                    prefixIcon: Icon(Icons.favorite),
                    hintText: 'Status',
                    hintStyle: GoogleFonts.jua(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  items: statusOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.jua(),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      status = newValue;
                    });
                  },
                )),
              ]),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: species,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(139, 128, 255, 0.3),
                  prefixIcon: Icon(Icons.pets),
                  hintText: 'Species',
                  hintStyle: GoogleFonts.jua(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                items: speciesOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.jua(),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    species = newValue;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: descriptionController,
                style: GoogleFonts.jua(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(139, 128, 255, 0.3),
                  prefixIcon: Icon(Icons.description),
                  hintText: 'Deskripsi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          height: 80,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Color.fromRGBO(252, 147, 64, 1),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            onPressed: () async {
              if (birthday == null && birthdayController.text.isNotEmpty) {
                try {
                  birthday = DateTime.parse(birthdayController.text);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid date format')),
                  );
                  return;
                }
              }
              if (nameController.text.isEmpty ||
                  gender == null ||
                  status == null ||
                  species == null ||
                  birthday == null ||
                  descriptionController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all fields')),
                );
                return;
              }

              // Image
              // if (_image != null) {
              //   final url = await petService.uploadImage(userId, '', _image!.path);
              //   print('Uploaded image: $url');
              // }

              Pet pet = Pet(
                id: '',
                name: nameController.text,
                gender: gender!,
                status: status!,
                birthday: birthday!.toIso8601String(),
                species: species!,
                description: descriptionController.text,
                photoUrl: _image != null ? _image!.path : '',
              );

              await petService.addPet(userId, pet);
              Navigator.pop(context);
            },
            child: Text(
              'Tambahkan Hewan',
              style: GoogleFonts.jua(),
            ),
          ),
        ),
      ]),
    );
  }

}
