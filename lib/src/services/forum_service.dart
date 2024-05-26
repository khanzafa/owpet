import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:owpet/src/models/forum.dart';
import 'package:owpet/src/models/user.dart';

class ForumService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<List<Forum>> getForums() async {
    try {
      final snapshot = await _firestore.collection('forums').get();
      return snapshot.docs
          .map((doc) => Forum.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      print('Error getting forums: $e');
      throw e;
    }
  }

  Future<Forum> getForum(String forumId) async {
    try {
      final doc = await _firestore.collection('forums').doc(forumId).get();
      return Forum.fromJson({'id': doc.id, ...doc.data() ?? {}});
    } catch (e) {
      print('Error getting forum by id: $e');
      throw e;
    }
  }

  Future<void> addForum(Forum forum) async {
    try {
      final forumData = forum.toJson();
      forumData.remove('id');
      await _firestore.collection('forums').add(forumData);
    } catch (e) {
      print('Error adding forum: $e');
      throw e;
    }
  }

  Future<void> deleteForum(String forumId) async {
    try {
      await _firestore.collection('forums').doc(forumId).delete();
    } catch (e) {
      print('Error deleting forum: $e');
      throw e;
    }
  }

  Future<String> uploadImage(String forumId, String imagePath) async {
    try {
      final ref = storage.ref().child('forums/$forumId/${DateTime.now()}.jpg');
      final result = await ref.putFile(File(imagePath));
      final url = await result.ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<void> likeForum(String forumId, User user) async {
    try {
      final forumDoc = await _firestore.collection('forums').doc(forumId).get();
      if (!forumDoc.exists) {
        print("Error: forum does not exist");
        return;
      }

      final forumData = forumDoc.data();
      if (forumData == null) {
        print("Error: forum data is null");
        return;
      }

      final forum = Forum.fromJson({
        'id': forumDoc.id,
        ...forumData,
      });
      final likedForumDoc = await _firestore
          .collection('users')
          .doc(user.id)
          .collection('likedForums')
          .doc(forumId)
          .get();
      final likedForum = likedForumDoc.data();
      final dislikedForumDoc = await _firestore
          .collection('users')
          .doc(user.id)
          .collection('dislikedForums')
          .doc(forumId)
          .get();
      final dislikedForum = dislikedForumDoc.data();

      if (likedForum == null) {
        forum.likeCount++;
        await _firestore.collection('forums').doc(forumId).update({
          'likeCount': forum.likeCount,
        });
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('likedForums')
            .doc(forumId)
            .set({
          'forumId': forumId,
          'createdAt': DateTime.now().toIso8601String(),
        });
      } else {
        forum.likeCount--;
        await _firestore.collection('forums').doc(forumId).update({
          'likeCount': forum.likeCount,
        });
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('likedForums')
            .doc(forumId)
            .delete();
      }

      if (dislikedForum != null) {
        forum.dislikeCount--;
        await _firestore.collection('forums').doc(forumId).update({
          'dislikeCount': forum.dislikeCount,
        });
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('dislikedForums')
            .doc(forumId)
            .delete();
      }
    } catch (e) {
      print('Error liking forum: $e');
      throw e;
    }
  }

  Future<void> dislikeForum(String forumId, User user) async {
    try {
      final forumDoc = await _firestore.collection('forums').doc(forumId).get();
      if (!forumDoc.exists) {
        print("Error: forum does not exist");
        return;
      }

      final forumData = forumDoc.data();
      if (forumData == null) {
        print("Error: forum data is null");
        return;
      }

      final forum = Forum.fromJson({
        'id': forumDoc.id,
        ...forumData,
      });
      final likedForumDoc = await _firestore
          .collection('users')
          .doc(user.id)
          .collection('likedForums')
          .doc(forumId)
          .get();
      final likedForum = likedForumDoc.data();
      final dislikedForumDoc = await _firestore
          .collection('users')
          .doc(user.id)
          .collection('dislikedForums')
          .doc(forumId)
          .get();
      final dislikedForum = dislikedForumDoc.data();

      if (dislikedForum == null) {
        forum.dislikeCount++;
        await _firestore.collection('forums').doc(forumId).update({
          'dislikeCount': forum.dislikeCount,
        });
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('dislikedForums')
            .doc(forumId)
            .set({
          'forumId': forumId,
          'createdAt': DateTime.now().toIso8601String(),
        });
      } else {
        forum.dislikeCount--;
        await _firestore.collection('forums').doc(forumId).update({
          'dislikeCount': forum.dislikeCount,
        });
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('dislikedForums')
            .doc(forumId)
            .delete();
      }

      if (likedForum != null) {
        forum.likeCount--;
        await _firestore.collection('forums').doc(forumId).update({
          'likeCount': forum.likeCount,
        });
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('likedForums')
            .doc(forumId)
            .delete();
      }
    } catch (e) {
      print('Error disliking forum: $e');
      throw e;
    }
  }

  Future<void> shareForum(String forumId, User user) async {
    try {
      final forumDoc = await _firestore.collection('forums').doc(forumId).get();
      if (!forumDoc.exists) {
        print("Error: forum does not exist");
        return;
      }

      final forumData = forumDoc.data();
      if (forumData == null) {
        print("Error: forum data is null");
        return;
      }

      final forum = Forum.fromJson({
        'id': forumDoc.id,
        ...forumData,
      });
      final sharedForumDoc = await _firestore
          .collection('users')
          .doc(user.id)
          .collection('sharedForums')
          .doc(forumId)
          .get();
      final sharedForum = sharedForumDoc.data();
      if (sharedForum == null) {
        forum.shareCount++;
        await _firestore.collection('forums').doc(forumId).update({
          'shareCount': forum.shareCount,
        });
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('sharedForums')
            .doc(forumId)
            .set({
          'forumId': forumId,
          'createdAt': DateTime.now().toIso8601String(),
        });
      } else {
        return;
      }
    } catch (e) {
      print('Error sharing forum: $e');
      throw e;
    }
  }

  Future<void> commentForum(String forumId, Comment comment) async {
    try {
      final doc = await _firestore.collection('forums').doc(forumId).get();
      final forum = Forum.fromJson({
        'id': doc.id,
        ...doc.data() ?? {},
      });
      forum.commentCount++;
      await _firestore.collection('forums').doc(forumId).update({
        'commentCount': forum.commentCount,
      });

      final commentData = comment.toJson();
      commentData.remove('id');
      await _firestore
          .collection('forums')
          .doc(forumId)
          .collection('comments')
          .add(commentData);
    } catch (e) {
      print('Error commenting forum: $e');
      throw e;
    }
  }

  Future<List<Comment>> getComments(String forumId) async {
    try {
      final snapshot = await _firestore
          .collection('forums')
          .doc(forumId)
          .collection('comments')
          .get();
      return snapshot.docs
          .map((doc) => Comment.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      print('Error getting comments: $e');
      throw e;
    }
  }

  Future<void> likeComment(String forumId, String commentId, User user) async {
    try {
      final commentDoc = await _firestore
          .collection('forums')
          .doc(forumId)
          .collection('comments')
          .doc(commentId)
          .get();
      if (!commentDoc.exists) {
        print("Error: comment does not exist");
        return;
      }

      final commentData = commentDoc.data();
      if (commentData == null) {
        print("Error: comment data is null");
        return;
      }

      final comment = Comment.fromJson({
        'id': commentDoc.id,
        ...commentData,
      });
      final likedCommentDoc = await _firestore
          .collection('users')
          .doc(user.id)
          .collection('likedComments')
          .doc(commentId)
          .get();
      final likedComment = likedCommentDoc.data();
      final dislikedCommentDoc = await _firestore
          .collection('users')
          .doc(user.id)
          .collection('dislikedComments')
          .doc(commentId)
          .get();
      final dislikedComment = dislikedCommentDoc.data();

      if (likedComment == null) {
        comment.likeCount++;
        await _firestore
            .collection('forums')
            .doc(forumId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likeCount': comment.likeCount,
        });
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('likedComments')
            .doc(commentId)
            .set({
          'commentId': commentId,
          'createdAt': DateTime.now().toIso8601String(),
        });
      } else {
        comment.likeCount--;
        await _firestore
            .collection('forums')
            .doc(forumId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likeCount': comment.likeCount,
        });
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('likedComments')
            .doc(commentId)
            .delete();
      }

      if (dislikedComment != null) {
        comment.dislikeCount--;
        await _firestore
            .collection('forums')
            .doc(forumId)
            .collection('comments')
            .doc(commentId)
            .update({
          'dislikeCount': comment.dislikeCount,
        });
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('dislikedComments')
            .doc(commentId)
            .delete();
      }
    } catch (e) {
      print('Error liking comment: $e');
      throw e;
    }
  }

  Future<void> dislikeComment(
      String forumId, String commentId, User user) async {
    try {
      final commentDoc = await _firestore
          .collection('forums')
          .doc(forumId)
          .collection('comments')
          .doc(commentId)
          .get();
      if (!commentDoc.exists) {
        print("Error: comment does not exist");
        return;
      }

      final commentData = commentDoc.data();
      if (commentData == null) {
        print("Error: comment data is null");
        return;
      }

      final comment = Comment.fromJson({
        'id': commentDoc.id,
        ...commentData,
      });
      final likedCommentDoc = await _firestore
          .collection('users')
          .doc(user.id)
          .collection('likedComments')
          .doc(commentId)
          .get();
      final likedComment = likedCommentDoc.data();
      final dislikedCommentDoc = await _firestore
          .collection('users')
          .doc(user.id)
          .collection('dislikedComments')
          .doc(commentId)
          .get();
      final dislikedComment = dislikedCommentDoc.data();

      if (dislikedComment == null) {
        comment.dislikeCount++;
        await _firestore
            .collection('forums')
            .doc(forumId)
            .collection('comments')
            .doc(commentId)
            .update({
          'dislikeCount': comment.dislikeCount,
        });
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('dislikedComments')
            .doc(commentId)
            .set({
          'commentId': commentId,
          'createdAt': DateTime.now().toIso8601String(),
        });
      } else {
        comment.dislikeCount--;
        await _firestore
            .collection('forums')
            .doc(forumId)
            .collection('comments')
            .doc(commentId)
            .update({
          'dislikeCount': comment.dislikeCount,
        });
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('dislikedComments')
            .doc(commentId)
            .delete();
      }

      if (likedComment != null) {
        comment.likeCount--;
        await _firestore
            .collection('forums')
            .doc(forumId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likeCount': comment.likeCount,
        });
        await _firestore
            .collection('users')
            .doc(user.id)
            .collection('likedComments')
            .doc(commentId)
            .delete();
      }
    } catch (e) {
      print('Error disliking comment: $e');
      throw e;
    }
  }
}
