import 'package:flutter/material.dart';
import 'package:owpet/src/services/pet_service.dart';
import 'package:owpet/src/models/pet.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddProfile extends StatefulWidget {
  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  final String userId = 'qUtR4Sp5FAHyOpmxeD9l';
  final PetService petService = PetService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // Declare _selectedDate here
  String? _gender;
  String? _status;
  String? _species;
  String? _profile;
  TextEditingController _descriptionController = TextEditingController();
  int _lastChecked = -1; // Menyimpan index terakhir yang dipilih

  @override
  void initState() {
    super.initState();
    // Initialize date format for Indonesian locale
    initializeDateFormatting('id', null);
    _gender = null;
    _status = null;
    _species = null;
    _profile = null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text =
            DateFormat.yMMMMd('id').format(_selectedDate);
      });
    }
  }

  void _toggleCheck(int index) {
    setState(() {
      if (_lastChecked == index) {
        _lastChecked = -1; // Uncheck jika sudah tercentang
      } else {
        _lastChecked = index; // Centang jika belum tercentang
      }
    });
  }

  void addPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Anda dapat menampilkan foto yang dipilih di UI atau mengunggahnya ke server
      // Misalnya, menyimpan URL foto ke dalam _profilePicture
      setState(() {
        _profile = pickedFile.path;
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Pet Profile'),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF8b80ff),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        addPhoto();
                      },
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: _profile != null
                            ? Image.network(
                                _profile!,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.add_a_photo_outlined,
                                size: 50.0,
                                color: Colors.grey[600],
                              ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _toggleCheck(0);
                            setState(() {
                              _species = 'anjing';
                            });
                          },
                          child: Container(
                            width: 73,
                            height: 73,
                            decoration: BoxDecoration(
                              color: _lastChecked == 0
                                  ? Colors.blue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Image.asset(
                              'assets/images/anjing.png',
                              width: 70,
                              height: 70,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            _toggleCheck(1);
                            setState(() {
                              _species = 'kucing';
                            });
                          },
                          child: Container(
                            width: 73,
                            height: 73,
                            decoration: BoxDecoration(
                              color: _lastChecked == 1
                                  ? Colors.blue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Image.asset(
                              'assets/images/kucing.png',
                              width: 70,
                              height: 70,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            _toggleCheck(2);
                            setState(() {
                              _species = 'kelinci';
                            });
                          },
                          child: Container(
                            width: 73,
                            height: 73,
                            decoration: BoxDecoration(
                              color: _lastChecked == 2
                                  ? Colors.blue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Image.asset(
                              'assets/images/kelinci.png',
                              width: 70,
                              height: 70,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            _toggleCheck(3);
                            setState(() {
                              _species = 'burung';
                            });
                          },
                          child: Container(
                            width: 73,
                            height: 73,
                            decoration: BoxDecoration(
                              color: _lastChecked == 3
                                  ? Colors.blue
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Image.asset(
                              'assets/images/burung.png',
                              width: 70,
                              height: 70,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.pets),
                          hintText: 'Name',
                          filled: true,
                          fillColor: Color(0xFFECEAFF), // Warna latar belakang
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12.0), // Border radius
                            borderSide: BorderSide.none, // Hilangkan border
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        readOnly:
                            true, // Membuat TextField tidak dapat diedit langsung
                        controller: _birthDateController,
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month),
                          hintText: 'Birth Date',
                          filled: true,
                          fillColor: Color(0xFFECEAFF), // Warna latar belakang
                          border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Border radius
                                  borderSide:
                                      BorderSide.none, // Hilangkan border
                          ),
                         ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: DropdownButtonFormField<String>(
                              value: _gender,
                              onChanged: (String? value) {
                                setState(() {
                                  if (value == 'Jantan' || value == 'Betina') {
                                    _gender = value!;
                                  }
                                });
                              },
                              items: <String>[
                                'Jantan',
                                'Betina',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                hintText: 'Gender', // Teks hint untuk gender
                                filled: true,
                                fillColor:
                                    Color(0xFFECEAFF), // Warna latar belakang
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Border radius
                                  borderSide:
                                      BorderSide.none, // Hilangkan border
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: DropdownButtonFormField<String>(
                              value: _status,
                              onChanged: (String? value) {
                                setState(() {
                                  if (value == 'Single' || value == 'Kawin') {
                                    _status = value!;
                                  }
                                });
                              },
                              items: <String>[
                                'Single',
                                'Kawin'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                hintText: 'Status', // Teks hint untuk status
                                filled: true,
                                fillColor:
                                    Color(0xFFECEAFF), // Warna latar belakang
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      12.0), // Border radius
                                  borderSide:
                                      BorderSide.none, // Hilangkan border
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          filled: true,
                          fillColor: Color(0xFFECEAFF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Image.asset(
                            'assets/images/icon_desc.png', // Ganti dengan path asset gambar Anda
                            width: 24, // Sesuaikan lebar gambar
                            height: 72, // Sesuaikan tinggi gambar
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Tambahkan validasi sebelum menyimpan data
                        if (_nameController.text.isEmpty ||
                            _birthDateController.text.isEmpty ||
                            _gender == null ||
                            _status == null ||
                            _species == null) {
                          // Tampilkan pesan error atau lakukan penanganan sesuai kebutuhan
                          return;
                        }

                        Pet pet = Pet(
                          id: '',
                          name: _nameController.text,
                          gender: _gender!,
                          status: _status!,
                          birthday: _birthDateController.text,
                          species: _species!,
                          description: _descriptionController.text,
                        );

                        petService.addPet(userId, pet).then((value) {
                          Navigator.pop(context);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFFFC9340), // Warna latar belakang tombol
                        minimumSize: Size(double.infinity,
                            50), // Lebar tombol sepanjang layar dan tinggi 50
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // Border radius
                        ),
                      ),
                      child: Text(
                        'Create',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Tambahkan logika untuk menambahkan foto
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        size: 50.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AddProfile(),
  ));
}
