import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUserScreen extends StatefulWidget {
  @override
  _ProfileUserScreenState createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  String name = 'Iqbal Ramadhan';
  String tagline = 'Pecinta Anjing';
  String email = 'Iqbalr@gmail.com';
  String phoneNumber = '0895396789912';
  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 60),
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 0),
                      padding: EdgeInsets.only(
                          top: 15, bottom: 20, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(139, 128, 255, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.edit_square,
                                  color: Colors.orange, size: 24),
                              onPressed: () => _editProfile(context),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: const Color.fromARGB(
                                      255, 255, 255, 255))),
                          Text(
                            tagline,
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 255, 255, 255)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -50,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _imageFile == null
                            ? AssetImage('assets/profile_pic.jpg')
                            : FileImage(File(_imageFile!.path))
                                as ImageProvider,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                DetailTile(label: 'Email', icon: Icons.email, text: email),
                DetailTile(
                    label: 'Nomor HP', icon: Icons.phone, text: phoneNumber),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Logout'),
                        content: Text('Apakah Anda yakin ingin logout?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Tidak'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Ya'),
                          ),
                        ],
                      ),
                    ),
                    child: Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
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

  void _editProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile == null
                        ? AssetImage('assets/profile_pic.jpg')
                        : FileImage(File(_imageFile!.path)) as ImageProvider,
                    child: Icon(Icons.camera_alt, color: Colors.white70),
                  ),
                ),
                TextFormField(
                  initialValue: name,
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) => name = value,
                ),
                TextFormField(
                  initialValue: tagline,
                  decoration: InputDecoration(labelText: 'Tagline'),
                  onChanged: (value) => tagline = value,
                ),
                TextFormField(
                  initialValue: email,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) => email = value,
                ),
                TextFormField(
                  initialValue: phoneNumber,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  onChanged: (value) => phoneNumber = value,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }
}

class DetailTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final String text;

  const DetailTile(
      {Key? key, required this.label, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.deepPurple),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


//InfoTile(
              //   icon: Icons.email,
              //   text: 'Iqbalr@gmail.com',
              // ),
              // InfoTile(
              //   icon: Icons.phone,
              //   text: '0895396789912',
              // ),