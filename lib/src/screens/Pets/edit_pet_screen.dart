// import 'package:flutter/material.dart';
// import 'package:owpet/src/services/pet_service.dart';
// import 'package:owpet/src/models/pet.dart';

// class EditPetScreen extends StatefulWidget {
//   final String userId;
//   final Pet pet;

//   const EditPetScreen({Key? key, required this.userId, required this.pet})
//       : super(key: key);

//   @override
//   State<EditPetScreen> createState() => _EditPetScreenState();
// }

// class _EditPetScreenState extends State<EditPetScreen> {
//   final PetService petService = PetService();
//   final TextEditingController profileController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController genderController = TextEditingController();
//   final TextEditingController statusController = TextEditingController();
//   final TextEditingController birthdayController = TextEditingController();
//   final TextEditingController speciesController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     nameController.text = widget.pet.name;
//     genderController.text = widget.pet.gender;
//     statusController.text = widget.pet.status;
//     birthdayController.text = widget.pet.birthday;
//     speciesController.text = widget.pet.species;
//     descriptionController.text = widget.pet.description;

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Pet'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: 'Name'),
//               ),
//               TextField(
//                 controller: genderController,
//                 decoration: InputDecoration(labelText: 'Gender'),
//               ),
//               TextField(
//                 controller: statusController,
//                 decoration: InputDecoration(labelText: 'Status'),
//               ),
//               TextField(
//                 controller: birthdayController,
//                 decoration: InputDecoration(labelText: 'Birthday'),
//               ),
//               TextField(
//                 controller: speciesController,
//                 decoration: InputDecoration(labelText: 'Species'),
//               ),
//               TextField(
//                 controller: descriptionController,
//                 decoration: InputDecoration(labelText: 'Description'),
//               ),
//               SizedBox(height: 16.0),
//               ElevatedButton(
//                 onPressed: () {
// Pet updatedPet = Pet(
//   id: widget.pet.id,
//   name: nameController.text,
//   gender: genderController.text,
//   status: statusController.text,
//   birthday: birthdayController.text,
//   species: speciesController.text,
//   description: descriptionController.text,
//   photoUrl: widget.pet.photoUrl,
// );

// petService.updatePet(widget.pet.id, updatedPet).then((value) {
//   Navigator.pop(context);
// });
//                 },
//                 child: Text('Save Changes'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owpet/src/services/pet_service.dart';
import 'package:owpet/src/models/pet.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPetScreen extends StatefulWidget {
  final String userId;
  final Pet pet;

  const EditPetScreen({Key? key, required this.userId, required this.pet})
      : super(key: key);

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  // final String userId = 'qUtR4Sp5FAHyOpmxeD9l';
  final PetService petService = PetService();
  final TextEditingController profileController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
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

  void initState() {
    super.initState();
    nameController.text = widget.pet.name;
    genderController.text = widget.pet.gender!;
    statusController.text = widget.pet.status!;
    birthdayController.text = widget.pet.birthday!;
    speciesController.text = widget.pet.species!;
    descriptionController.text = widget.pet.description!;
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
          'Edit Pet',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? Image.file(
                                _image!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ).image
                            : widget.pet.photoUrl != null
                                ? Image.network(
                                    widget.pet.photoUrl!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ).image
                                : null,
                        child: _image == null && widget.pet.photoUrl == null
                            ? Icon(
                                Icons.add_a_photo,
                                size: 50,
                              )
                            : null),
                  ),
                  _image == null && widget.pet.photoUrl != null
                      ? Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: _pickImage,
                          ),
                        )
                      : Container(),
                ],
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

              // Pet pet = Pet(
              //   id: '',
              //   name: nameController.text,
              //   gender: gender!,
              //   status: status!,
              //   birthday: birthday!.toIso8601String(),
              //   species: species!,
              //   description: descriptionController.text,
              //   photoUrl: _image != null ? _image!.path : '',
              // );

              // await petService.addPet(userId, pet);
              // Navigator.pop(context);
              Pet updatedPet = Pet(
                  id: widget.pet.id,
                  name: nameController.text,
                  birthday: birthdayController.text,
                  description: descriptionController.text,
                  gender: gender!,
                  species: species!,
                  status: status!,
                  photoUrl:
                      _image != null ? _image!.path : widget.pet.photoUrl!= null ? widget.pet.photoUrl : '');

              await petService.updatePet(widget.userId, updatedPet);
              Navigator.pop(context);
            },
            child: Text(
              'Simpan',
              style: GoogleFonts.jua(),
            ),
          ),
        ),
      ]),
    );
  }
}
