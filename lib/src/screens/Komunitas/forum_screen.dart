import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:owpet/src/models/forum.dart';
import 'package:owpet/src/models/user.dart';
import 'package:owpet/src/screens/Komunitas/add_forum_screen.dart';
import 'package:owpet/src/screens/Komunitas/detail_forum_screen.dart';
import 'package:owpet/src/services/forum_service.dart';
import 'package:share_plus/share_plus.dart';

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  // Data Dummy forums
  // List<Forum> forums = [
  //   Forum(
  //     id: '1',
  //     description:
  //         'Halo, ini adalah deskripsi forum pertama. Forum ini sangat menarik! 😺🐶🐹',
  //     images: [
  //       'https://source.unsplash.com/random/?cat',
  //       'https://source.unsplash.com/random/?dog',
  //       'https://source.unsplash.com/random/?pet'
  //     ],
  //     user: User(
  //       id: '1',
  //       name: 'User 1',
  //       email: 'example@gmail.com',
  //       password: 'password',
  //       telephone: '08123456789',
  //       description: 'Description',
  //       photo: 'https://source.unsplash.com/random/?person',
  //     ),
  //     createdAt: TimeOfDay.now().toString(),
  //     likeCount: 10,
  //     dislikeCount: 1,
  //     commentCount: 5,
  //   ),
  //   Forum(
  //     id: '2',
  //     description: 'Description 2',
  //     images: [],
  //     user: User(
  //       id: '2',
  //       name: 'User 2',
  //       email: 'example@gmail.com',
  //       password: 'password',
  //       telephone: '08123456789',
  //       description: 'Description',
  //       photo: 'https://source.unsplash.com/random/?person',
  //     ),
  //     createdAt: TimeOfDay.now().toString(),
  //     likeCount: 20,
  //     dislikeCount: 2,
  //     commentCount: 10,
  //   ),
  //   Forum(
  //     id: '3',
  //     description: 'Description 3',
  //     images: [
  //       'https://source.unsplash.com/random/?pet',
  //       'https://source.unsplash.com/random/?pet',
  //       'https://source.unsplash.com/random/?pet'
  //     ],
  //     user: User(
  //       id: '3',
  //       name: 'User 3',
  //       email: 'example@gmail.com',
  //       password: 'password',
  //       telephone: '08123456789',
  //       description: 'Description',
  //       photo: 'https://source.unsplash.com/random/?person',
  //     ),
  //     createdAt: TimeOfDay.now().toString(),
  //     likeCount: 30,
  //     dislikeCount: 3,
  //     commentCount: 15,
  //   ),
  // ];
  List<Forum> forums = [];
  // Data Dummy activeUser
  User activeUser = User(
    id: 'qUtR4Sp5FAHyOpmxeD9l',
    name: 'User 1',
    email: 'example@gmail.com',
    password: 'password',
    telephone: '08123456789',
    description: 'Description',
    photo: 'https://source.unsplash.com/random/?person',
  );

  // Filter forum saya
  List<Forum> get myForums =>
      forums.where((forum) => forum.user.id == activeUser.id).toList();

  @override
  void initState() {
    print("initState bosss");
    super.initState();
    getForums();
  }

  @override
  void didUpdateWidget(covariant ForumScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    getForums();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Get forums
  Future<void> getForums() async {
    try {
      final forums = await ForumService().getForums();
      setState(() {
        this.forums = forums;
      });
    } catch (e) {
      print('Error getting forums: $e');
      // Lakukan penanganan kesalahan yang sesuai
    }
  }

  // Likes forum
  Future<void> likeForum(String forumId) async {
    try {
      if (forumId == null || forumId.isEmpty) {
        print("Error: forumId is null or empty");
        return;
      }

      if (activeUser == null ||
          activeUser.id == null ||
          activeUser.id.isEmpty) {
        print("Error: activeUser or activeUser.id is null or empty");
        return;
      }

      await ForumService().likeForum(forumId, activeUser);
      await getForums();
    } catch (e) {
      print('Error liking forum: $e');
    }
  }

  // Dislikes forum
  Future<void> dislikeForum(String forumId) async {
    try {
      if (forumId == null || forumId.isEmpty) {
        print("Error: forumId is null or empty");
        return;
      }

      if (activeUser == null ||
          activeUser.id == null ||
          activeUser.id.isEmpty) {
        print("Error: activeUser or activeUser.id is null or empty");
        return;
      }

      await ForumService().dislikeForum(forumId, activeUser);
      await getForums();
    } catch (e) {
      print('Error disliking forum: $e');
      // Lakukan penanganan kesalahan yang sesuai
    }
  }

  // Open forum detail
  void openForumDetail(Forum forum, Color cardColor) async {
    // Fungsi yang akan dijalankan ketika forum ditekan
    // Contoh: Navigasi ke halaman detail forum
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ForumDetailScreen(forum: forum, color: cardColor)),
    );
    getForums();
  }

  // Format date time
  String formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateTime);
  }

  // Make template forum to share
  void shareForum(Forum forum) async {
    final forumTemplate = '''
Owpet Forum Shared by ${forum.user.name}

Description:
${forum.description}

Images:
${forum.images.join('\n')}

Posted on: ${formatDateTime(forum.createdAt)}

Join the discussion on Owpet App!
    ''';
    final result = await Share.share(forumTemplate);
    if (result.status == ShareResultStatus.success) {
      await ForumService().shareForum(forum.id, activeUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Jumlah tab
      child: Scaffold(
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
            'Forum Komunitas',
            style: GoogleFonts.jua(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Semua',
                  style: GoogleFonts.poppins(),
                ),
              ),
              Tab(
                child: Text(
                  'Saya',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab Semua
            ListView.builder(
              itemCount: forums.length,
              itemBuilder: (context, index) {
                final forum = forums[index];
                final imagesToShow = forum.images.take(2).toList();
                final cardColor = index % 2 == 0
                    ? Color.fromRGBO(
                        139, 128, 255, 0.6) // Ungu dengan opasitas 12%
                    : Color.fromRGBO(
                        252, 147, 64, 0.6); // Oranye dengan opasitas 12%
                return GestureDetector(
                  onTap: () => openForumDetail(forum, cardColor),
                  child: Card(
                    color: cardColor,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(forum.user.photo),
                            ),
                            title: Text(
                              forum.user.name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              formatDateTime(forum.createdAt),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(forum.description,
                                style: GoogleFonts.poppins(
                                    // fontWeight: FontWeight.w300,
                                    )),
                          ),
                          SizedBox(height: 5),
                          // imagesToShow.isNotEmpty
                          //     ? Row(
                          //         children: imagesToShow
                          //             .map(
                          //               (image) => Expanded(
                          //                 child: Container(
                          //                   width: MediaQuery.of(context)
                          //                       .size
                          //                       .width,
                          //                   height: MediaQuery.of(context)
                          //                           .size
                          //                           .width *
                          //                       0.5, // Contoh rasio 16:9
                          //                   margin: EdgeInsets.symmetric(
                          //                       horizontal: 5, vertical: 10),
                          //                   decoration: BoxDecoration(
                          //                     borderRadius:
                          //                         BorderRadius.circular(10),
                          //                   ),
                          //                   child: ClipRRect(
                          //                     borderRadius:
                          //                         BorderRadius.circular(10),
                          //                     child: Image.network(
                          //                       image,
                          //                       fit: BoxFit.cover,
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //             )
                          //             .toList(),
                          //       )
                          //     : SizedBox(height: 5),
                          Row(
                            children: [
                              // Like
                              Flexible(
                                flex: 1,
                                child: _buildActionButton(
                                    Icons.favorite_border,
                                    '${forum.likeCount.toString()}',
                                    () => likeForum(forum.id),
                                    context),
                              ),
                              // Dislike
                              Flexible(
                                flex: 1,
                                child: _buildActionButton(
                                    Icons.thumb_down_alt_outlined,
                                    '${forum.dislikeCount.toString()}',
                                    () => dislikeForum(forum.id),
                                    context), // Dislike count, bisa disesuaikan
                              ),
                              // Comment
                              Flexible(
                                flex: 1,
                                child: _buildActionButton(
                                    Icons.comment_outlined,
                                    '${forum.commentCount.toString()}',
                                    () => openForumDetail(forum, cardColor),
                                    context),
                              ),
                              // Share
                              Flexible(
                                flex: 1,
                                child: _buildActionButton(
                                    Icons.share,
                                    '${forum.shareCount.toString()}',
                                    () => shareForum(forum),
                                    context),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            // Tab Forum Saya
            ListView.builder(
              itemCount: myForums.length,
              itemBuilder: (context, index) {
                final myForum = myForums[index];
                final imagesToShow = myForum.images.take(2).toList();
                final cardColor = index % 2 == 0
                    ? Color.fromRGBO(
                        139, 128, 255, 0.6) // Ungu dengan opasitas 12%
                    : Color.fromRGBO(
                        252, 147, 64, 0.6); // Oranye dengan opasitas 12%
                return Card(
                  color: cardColor,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(myForum.user.photo),
                          ),
                          title: Text(
                            myForum.user.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            formatDateTime(myForum.createdAt),
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            myForum.description,
                            style: GoogleFonts.poppins(
                                // fontWeight: FontWeight.w300,
                                ),
                          ),
                        ),
                        SizedBox(height: 5),
                        imagesToShow.isNotEmpty
                            ? Row(
                                children: imagesToShow
                                    .map(
                                      (image) => Expanded(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5, // Contoh rasio 16:9
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          // padding: EdgeInsets.symmetric(
                                          //     horizontal: 5, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            : SizedBox(height: 5),
                        Row(
                          children: [
                            // Like
                            Flexible(
                              flex: 1,
                              child: _buildActionButton(
                                  Icons.favorite_border,
                                  '${myForum.likeCount.toString()}',
                                  () => likeForum(myForum.id),
                                  context),
                            ),
                            // Dislike
                            Flexible(
                              flex: 1,
                              child: _buildActionButton(
                                  Icons.thumb_down_alt_outlined,
                                  '${myForum.dislikeCount.toString()}',
                                  () => dislikeForum(myForum.id),
                                  context), // Dislike count, bisa disesuaikan
                            ),
                            // Comment
                            Flexible(
                              flex: 1,
                              child: _buildActionButton(
                                  Icons.comment_outlined,
                                  '${myForum.commentCount.toString()}',
                                  () => openForumDetail(myForum, cardColor),
                                  context),
                            ),
                            // Share
                            Flexible(
                              flex: 1,
                              child: _buildActionButton(
                                  Icons.share,
                                  '${myForum.shareCount.toString()}',
                                  () => shareForum(myForum),
                                  context),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Fungsi yang akan dijalankan ketika tombol ditekan
            // Contoh: Navigasi ke halaman tambah forum baru
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddForumScreen()),
            );
          },
          tooltip: 'Tambah Forum',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String count,
    VoidCallback onPressed,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Theme.of(context).primaryColor),
            SizedBox(width: 4),
            // Text(count, style: TextStyle(fontSize: 16)),
            Text(count,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                )),
          ],
        ),
      ),
    );
  }
}
