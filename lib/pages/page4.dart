import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/components/wall_post.dart';

class Pagefour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(title: Text('User 4')),
=======
      appBar: AppBar(title: Text('Anri')),
>>>>>>> 987802d80fa1e661b8adb31d16c3baeb632517a3
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
<<<<<<< HEAD
                    FirebaseFirestore.instance.collection("user_4").snapshots(),
=======
                    FirebaseFirestore.instance.collection("anri").snapshots(),
>>>>>>> 987802d80fa1e661b8adb31d16c3baeb632517a3
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
          ],
        ),
      ),
    );
  }
}
