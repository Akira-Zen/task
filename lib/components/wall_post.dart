import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/components/delete_button.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;

  const WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Transfer post to another collection
  void transferPost() async {
    final collectionName = currentUser?.email?.split('@')[0] ?? '';
    final postRef = FirebaseFirestore.instance
        .collection(collectionName)
        .doc(widget.postId);
    final postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      // Move the post to the "deleted_posts" collection
      final postData = postSnapshot.data();
      if (postData != null) {
        FirebaseFirestore.instance
            .collection(
                'deleted_posts') // Save it to the deleted_posts collection
            .doc(widget.postId)
            .set(postData)
            .then((value) => print("Post transferred"))
            .catchError((error) => print("Failed to transfer post: $error"));

        // Optionally, remove from the original collection
        postRef
            .delete()
            .then((_) => print("Post removed from original collection"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Profile pic (Placeholder icon)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[400],
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          // Post content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display user email (username)
                Text(
                  widget.user,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                // Post message
                Text(
                  widget.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  softWrap: true, // Allow text to wrap within the container
                ),
              ],
            ),
          ),
          // Show delete button only if the current user is the post owner
          if (widget.user == currentUser.email ||
              widget.user == "user_1@gmail.com")
            DeleteButton(onTap: transferPost), // Just transfer, no navigation
        ],
      ),
    );
  }
}
