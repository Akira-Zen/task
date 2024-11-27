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

  // Delete a post
  void deletePost() {
    // Show a dialog box asking for confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          // Delete button
          TextButton(
            onPressed: () async {
              // Deleting the post from Firestore
              FirebaseFirestore.instance
                  .collection("User Post")
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print("Post deleted"))
                  .catchError(
                      (error) => print("Failed to delete post: $error"));
              Navigator.pop(context); // Close the confirmation dialog
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
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
          if (widget.user == currentUser.email) DeleteButton(onTap: deletePost),
        ],
      ),
    );
  }
}
