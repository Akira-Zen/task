import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/text_field.dart';
import 'package:flutter_application_1/components/wall_post.dart';
import 'package:flutter_application_1/pages/deletedtask.dart'; // Import the DeletedPostsPage
import 'package:flutter_application_1/pages/page1.dart';
import 'package:flutter_application_1/pages/page2.dart';
import 'package:flutter_application_1/pages/page3.dart';
import 'package:flutter_application_1/pages/page4.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  // Sign out user
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // Post message to Firestore based on collection name
  void postMessage(String collectionName) {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection(collectionName).add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
      });
    }

    setState(() {
      textController.clear();
    });
  }

  // Show collection selection as a bottom sheet
  void showCollectionSelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200, // Height of the bottom sheet
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text(
                "Select Member",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView(
                  children: [
<<<<<<< HEAD
                    _buildCollectionOption("user_1"),
                    _buildCollectionOption("user_2"),
                    _buildCollectionOption("user_3"),
                    _buildCollectionOption("user_4"),
=======
                    _buildCollectionOption("may"),
                    _buildCollectionOption("anri"),
                    _buildCollectionOption("sofiia"),
                    _buildCollectionOption("khrystyna"),
>>>>>>> 987802d80fa1e661b8adb31d16c3baeb632517a3
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Build each collection option button
  Widget _buildCollectionOption(String collectionName) {
    // Check if the user can assign tasks to others or only to themselves
<<<<<<< HEAD
    if (currentUser.email == "user_1@gmail.com" ||
=======
    if (currentUser.email == "may@gmail.com" ||
>>>>>>> 987802d80fa1e661b8adb31d16c3baeb632517a3
        currentUser.email == "$collectionName@gmail.com") {
      return ListTile(
        title: Text(collectionName),
        onTap: () {
          postMessage(collectionName); // Assign task to the selected member
          Navigator.pop(context); // Close the bottom sheet after selection
        },
      );
    } else {
      // If the user is not allowed to assign tasks to this member, make the option disabled
      return ListTile(
        title: Text(collectionName),
        enabled: false, // Disable the task assignment for others
        subtitle: const Text("You can only assign tasks to yourself"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("TASK"),
        backgroundColor: Colors.white,
        actions: [
          // Home Button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
            icon: const Icon(Icons.home),
          ),
          // Page 1 Button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Pageone()),
              );
            },
            icon: const Icon(Icons.boy, color: Colors.lightBlue),
          ),
          // Page 2 Button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Pagetwo()),
              );
            },
            icon: const Icon(Icons.girl, color: Colors.lightGreen),
          ),
          // Page 3 Button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Pagethree()),
              );
            },
            icon: const Icon(Icons.girl, color: Colors.pink),
          ),
          // Page 4 Button
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Pagefour()),
              );
            },
            icon: const Icon(Icons.boy, color: Colors.yellow),
          ),
          // Deleted Posts Icon - Navigate to DeletedPostsPage
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DeletedPostsPage()), // Navigate to DeletedPostsPage
              );
            },
            icon: const Icon(Icons.delete_forever, color: Colors.red),
          ),
          // Sign Out Button at the end
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Post") // Initially fetch from "User Post"
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Assign the task',
                      obscureText: false,
                    ),
                  ),
                  IconButton(
                    onPressed:
                        showCollectionSelectionSheet, // Show the bottom sheet
                    icon: const Icon(Icons.arrow_circle_up),
                  ),
                ],
              ),
            ),
            Text(
              "Logged in as: ${currentUser.email!}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
