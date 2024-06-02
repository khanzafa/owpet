import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:owpet/src/models/user.dart';
import 'package:owpet/src/models/forum.dart';
import 'package:owpet/src/services/forum_service.dart';

class AddForumScreen extends StatefulWidget {
  final User user;

  AddForumScreen({required this.user});

  @override
  _AddForumScreenState createState() => _AddForumScreenState();
}

class _AddForumScreenState extends State<AddForumScreen> {
  // Data Dummy widget.user
  // User widget.user = User(
  //   id: '1',
  //   name: 'User 1',
  //   email: 'example@gmail.com',
  //   password: 'password',
  //   telephone: '08123456789',
  //   description: 'Description',
  //   photo: 'https://source.unsplash.com/random/?person',
  // );

  TextEditingController _descriptionController = TextEditingController();
  List<String> _imageAttachments = [];

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
      allowMultiple: true,
    );

    if (result != null) {
      List<String> filePaths = result.paths.map((path) => path!).toList();
      setState(() {
        _imageAttachments.addAll(filePaths);
      });
    }
  }

  // Implementasi untuk mengirim forum baru
  void _sendForum() async {
    // Kirim foto terlebih dahulu
    final _imageAttachmentsURL = <String>[];
    for (String imagePath in _imageAttachments) {
      try {
        final url = await ForumService().uploadImage(widget.user.id, imagePath);
        _imageAttachmentsURL.add(url);
      } catch (e) {
        print('Error uploading image: $e');
        // Lakukan penanganan kesalahan yang sesuai
      }
    }

    // Buat objek forum baru
    Forum newForum = Forum(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: _descriptionController.text,
      images: _imageAttachmentsURL,
      user: widget.user,
      createdAt: DateTime.now().toIso8601String(),
    );

    // Kirim forum baru ke Firestore
    try {
      await ForumService().addForum(newForum);
      Navigator.pop(context);
    } catch (e) {
      print('Error adding forum: $e');
      // Lakukan penanganan kesalahan yang sesuai
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Forum'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: widget.user.photo != null
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.user.photo??
                          'https://source.unsplash.com/random/?person'),
                    )
                  : null,
              // leading: CircleAvatar(
              //   radius: 20,
              //   backgroundImage: NetworkImage(widget.user.photo),
              // ),
              title: Text(widget.user.name),
            ),
            _imageAttachments.isNotEmpty
                ? Row(
                    children: _imageAttachments
                        .map(
                          (image) => Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width *
                                  0.5, // Contoh rasio 16:9
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: 5, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                : SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Masukkan deskripsi forum',
                
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(252, 147, 64, 1),
                    foregroundColor: Colors.white,
                    shape: CircleBorder(),
                    fixedSize: Size(50, 50),
                    padding: EdgeInsets.all(5),
                  ),
                  onPressed: () {
                    // Implementasi untuk memilih gambar dari galeri atau kamera
                    // Kemudian tambahkan gambar ke dalam _imageAttachments
                    _pickImage();
                  },
                  child: Icon(Icons.image),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(252, 147, 64, 1),
                      foregroundColor: Colors.white,
                      shape: CircleBorder(),
                      fixedSize: Size(50, 50),
                      padding: EdgeInsets.all(5)),
                  onPressed: () {
                    // Implementasi untuk mengirim forum baru
                    // Anda dapat menggunakan nilai _descriptionController.text
                    // dan _imageAttachments untuk membuat objek forum baru
                    _sendForum();
                  },
                  child: Icon(Icons.send),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
