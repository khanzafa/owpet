import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:owpet/src/models/forum.dart';
import 'package:owpet/src/models/user.dart';
import 'package:owpet/src/services/forum_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class ForumDetailScreen extends StatefulWidget {
  final Forum forum;
  final Color color;

  ForumDetailScreen({required this.forum, required this.color});

  @override
  _ForumDetailScreenState createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  late Forum _forum;
  late User _activeUser;
  late List<Comment> _comments;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _forum = widget.forum;
    _activeUser = User(
      id: 'qUtR4Sp5FAHyOpmxeD9l',
      name: 'User 1',
      email: 'example@gmail.com',
      password: 'password',
      telephone: '08123456789',
      description: 'Description',
      photo: 'https://source.unsplash.com/random/?person',
    );
    _comments = [];
    _commentController = TextEditingController();
    _getComments();
  }

  // Get Forum
  Future<void> getForum(String forumId) async {
    try {
      if (forumId == null || forumId.isEmpty) {
        print("Error: forumId is null or empty");
        return;
      }

      final forum = await ForumService().getForum(forumId);
      setState(() {
        _forum = forum;
      });
    } catch (e) {
      print('Error getting forum: $e');
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

      if (_activeUser == null ||
          _activeUser.id == null ||
          _activeUser.id.isEmpty) {
        print("Error: activeUser or activeUser.id is null or empty");
        return;
      }

      await ForumService().likeForum(forumId, _activeUser);
      await getForum(forumId);
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

      if (_activeUser == null ||
          _activeUser.id == null ||
          _activeUser.id.isEmpty) {
        print("Error: activeUser or activeUser.id is null or empty");
        return;
      }

      await ForumService().dislikeForum(forumId, _activeUser);
      await getForum(forumId);
    } catch (e) {
      print('Error disliking forum: $e');
      // Lakukan penanganan kesalahan yang sesuai
    }
  }

  // Format date time
  String formatDateTime(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(dateTime);
  }

  // Share forum
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
      await ForumService().shareForum(forum.id, _activeUser);
    }
  }

  Future<void> _getComments() async {
    try {
      final comments = await ForumService().getComments(_forum.id);
      setState(() {
        _comments = comments;
      });
    } catch (e) {
      print('Error getting comments: $e');
      // Lakukan penanganan kesalahan yang sesuai
    }
  }

  Future<void> _sendComment() async {
    Comment newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: _commentController.text,
      user: _activeUser,
      createdAt: DateTime.now().toIso8601String(),
    );

    try {
      await ForumService().commentForum(_forum.id, newComment);
      setState(() {
        _comments.add(newComment);
        _commentController.clear();
      });
    } catch (e) {
      print('Error commenting forum: $e');
      // Lakukan penanganan kesalahan yang sesuai
    }
  }

  Future<void> _likeComment(String commentId) async {
    try {
      if (commentId == null || commentId.isEmpty) {
        print("Error: commentId is null or empty");
        return;
      }

      if (_activeUser == null ||
          _activeUser.id == null ||
          _activeUser.id.isEmpty) {
        print("Error: activeUser or activeUser.id is null or empty");
        return;
      }

      await ForumService().likeComment(_forum.id, commentId, _activeUser);
      await _getComments();
    } catch (e) {
      print('Error liking comment: $e');
      // Lakukan penanganan kesalahan yang sesuai
    }
  }

  Future<void> _dislikeComment(String commentId) async {
    try {
      if (commentId == null || commentId.isEmpty) {
        print("Error: commentId is null or empty");
        return;
      }

      if (_activeUser == null ||
          _activeUser.id == null ||
          _activeUser.id.isEmpty) {
        print("Error: activeUser or activeUser.id is null or empty");
        return;
      }

      await ForumService().dislikeComment(_forum.id, commentId, _activeUser);
      await _getComments();
    } catch (e) {
      print('Error disliking comment: $e');
      // Lakukan penanganan kesalahan yang sesuai
    }
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
          'Detail Forum',
          style: GoogleFonts.jua(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Card(
            color: widget.color,
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
                      backgroundImage: NetworkImage(_forum.user.photo),
                    ),
                    title: Text(_forum.user.name, style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,                    
                    )),
                    subtitle: Text(formatDateTime(_forum.createdAt), style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                    )),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(_forum.description),
                  ),
                  SizedBox(height: 5),
                  _forum.images.isNotEmpty
                      ? CarouselSlider(
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.width *
                                0.5, // Example 16:9 ratio
                            enlargeCenterPage: true,
                            enableInfiniteScroll: false,
                            disableCenter: true,
                            autoPlay: true,
                          ),
                          items: _forum.images.map((image) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        )
                      : SizedBox(height: 5),
                  Row(
                    children: [
                      // Like
                      Flexible(
                        flex: 1,
                        child: _buildActionButton(
                            Icons.thumb_up_alt_outlined,
                            '${_forum.likeCount.toString()}',
                            () => likeForum(_forum.id),
                            context),
                      ),
                      // Dislike
                      Flexible(
                        flex: 1,
                        child: _buildActionButton(
                            Icons.thumb_down_alt_outlined,
                            '${_forum.dislikeCount.toString()}',
                            () => dislikeForum(_forum.id),
                            context), // Dislike count, bisa disesuaikan
                      ),
                      // Comment
                      Flexible(
                          flex: 1,
                          child: _buildActionButton(
                              Icons.comment_outlined,
                              '${_forum.commentCount.toString()}',
                              () => _getComments(),
                              context)),
                      Flexible(
                        flex: 1,
                        child: _buildActionButton(
                            Icons.share,
                            '${_forum.shareCount.toString()}',
                            () => shareForum(_forum),
                            context), // Share
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _commentController,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: 'Tambahkan komentar...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.color, // Set the border color here
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.color, // Set the enabled border color here
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: widget.color, // Set the focused border color here
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendComment,
                  color: widget.color, // Set the icon color here
                ),
              ),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Text(
              'Comments',
              // style: TextStyle(
              //   fontSize: 18,
              //   fontWeight: FontWeight.bold,
              // ),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          for (Comment comment in _comments)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(comment.user.photo),
                        ),
                        title: Text(
                          comment.user.name,
                          // style: TextStyle(
                          //   fontWeight: FontWeight.bold,
                          // ),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          formatDateTime(comment.createdAt),
                          // style: TextStyle(
                          //   color: Colors.grey[600],
                          // ),
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(comment.description, style: GoogleFonts.poppins()),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.thumb_up),
                            onPressed: () => _likeComment(comment.id),
                            tooltip: 'Like',
                          ),
                          Text(comment.likeCount.toString(), style: GoogleFonts.poppins()),
                          SizedBox(width: 16),
                          IconButton(
                            icon: Icon(Icons.thumb_down),
                            onPressed: () => _dislikeComment(comment.id),
                            tooltip: 'Dislike',
                          ),
                          Text(comment.dislikeCount.toString(), style: GoogleFonts.poppins()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
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
            Text(count, style: GoogleFonts.poppins(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
