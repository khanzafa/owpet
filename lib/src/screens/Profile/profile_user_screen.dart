import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:owpet/src/services/auth_service.dart';
import 'package:owpet/src/models/user.dart';
import 'package:provider/provider.dart';

class ProfileUserScreen extends StatefulWidget {
  late User user;

  ProfileUserScreen({required this.user});

  @override
  _ProfileUserScreenState createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  String photoUrl = '';
  String name = '';
  String tagline = '';
  String email = '';
  String phoneNumber = '';
  XFile? _imageFile;
  User user = User(
    id: '',
    email: '',
    name: '',
    password: '',
    telephone: '',
    description: '',
    photo: '',
  );

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
    _loadUserData();    
  }

  void _fetchCurrentUser() async {
    final authService = AuthService();
    final currentUser = await authService.getCurrentUser();
    if (currentUser != null) {
      setState(() {
        widget.user = currentUser;
      });
    }
  }

  void _loadUserData() async {
    setState(() {
      photoUrl = widget.user?.photo ?? '';
      name = widget.user?.name ?? '';
      tagline = widget.user?.description ?? '';
      email = widget.user?.email ?? '';
      phoneNumber = widget.user?.telephone ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Owpets - Profil Pengguna',
          style: GoogleFonts.jua(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  onPressed: () async {
                                    await _editProfile(context);
                                    _fetchCurrentUser();
                                    _loadUserData();
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(widget.user.name,
                                  style: GoogleFonts.jua(
                                    fontSize: 24,
                                    color: Colors.white,
                                  )),
                              Text(
                                widget.user.description!,
                                style: GoogleFonts.jua(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -50,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                photoUrl == null || photoUrl.isEmpty
                                    ? Image.asset(
                                        'assets/images/default_profile.png',
                                        fit: BoxFit.cover,
                                      ).image
                                    : NetworkImage(photoUrl) as ImageProvider,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Email',
                      style: GoogleFonts.jua(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    TextFormField(
                      initialValue: email,
                      readOnly: true,
                      style: GoogleFonts.jua(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(139, 128, 255, 0.3),
                        prefixIcon: Icon(Icons.mail),
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
                    SizedBox(height: 10),
                    Text(
                      'Nomor HP',
                      style: GoogleFonts.jua(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    TextFormField(
                      initialValue: phoneNumber,
                      readOnly: true,
                      style: GoogleFonts.jua(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(139, 128, 255, 0.3),
                        prefixIcon: Icon(Icons.phone),
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
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Logout',
                            style: GoogleFonts.jua(
                              fontSize: 20,
                              color: Colors.black,
                            )),
                        content: Text('Apakah Anda yakin ingin logout?',
                            style: GoogleFonts.jua()),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Tidak', style: GoogleFonts.jua()),
                          ),
                          TextButton(
                            onPressed: () {
                              final authService = Provider.of<AuthService>(
                                  context,
                                  listen: false);
                              authService.signOut().then((_) {
                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .pushReplacementNamed('/login');
                              });
                            },
                            child: Text('Ya', style: GoogleFonts.jua()),
                          ),
                        ],
                      ),
                    ),
                    child: Text('Logout',
                        style: GoogleFonts.jua(
                          fontSize: 20,
                          color: Colors.white,
                        )),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.red,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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

  Future<void> _editProfile(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: name);
    final TextEditingController emailController =
        TextEditingController(text: email);
    final TextEditingController phoneNumberController =
        TextEditingController(text: phoneNumber);
    final TextEditingController taglineController =
        TextEditingController(text: tagline);

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
                        ? Image.network(photoUrl).image
                        : FileImage(File(_imageFile!.path)) as ImageProvider,
                    child: Icon(Icons.camera_alt, color: Colors.white70),
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  // initialValue: name,
                  decoration: InputDecoration(labelText: 'Name'),
                  onChanged: (value) => name = value,
                ),
                TextFormField(
                  // initialValue: email,
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) => email = value,
                ),
                TextFormField(
                  // initialValue: phoneNumber,
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  onChanged: (value) => phoneNumber = value,
                ),
                TextFormField(
                  // initialValue: tagline,
                  controller: taglineController,
                  decoration: InputDecoration(labelText: 'Tagline'),
                  onChanged: (value) => tagline = value,
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
              onPressed: () async {
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                final updatedUser = User(
                  id: widget.user.id,
                  email: emailController.text,
                  name: nameController.text,
                  password: widget.user.password,
                  telephone: phoneNumberController.text,
                  description: taglineController.text,
                  photo: _imageFile == null ? user.photo : _imageFile!.path,
                );
                await authService.updateUser(updatedUser);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return Future.value(true);
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

  // Future<void> _saveProfile() async {
  //   final authService = Provider.of<AuthService>(context, listen: false);
  //   final updatedUser = User(
  //     id: user.id,
  //     email: email,
  //     name: name,
  //     password: user.password,
  //     telephone: phoneNumber,
  //     description: tagline,
  //     photo: _imageFile == null ? user.photo : _imageFile!.path,
  //   );
  //   await authService.updateUser(updatedUser);
  // }

  void _logout() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut().then((_) {
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }
}

// class DetailTile extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final String text;

//   const DetailTile(
//       {Key? key, required this.label, required this.icon, required this.text})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           alignment: Alignment.centerLeft,
//           padding: EdgeInsets.symmetric(horizontal: 15),
//           child: Text(
//             label,
//             style: TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//           padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: Colors.grey.shade300),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             children: [
//               Icon(icon, color: Colors.deepPurple),
//               SizedBox(width: 10),
//               Text(
//                 text,
//                 style: TextStyle(fontSize: 18, color: Colors.black),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
