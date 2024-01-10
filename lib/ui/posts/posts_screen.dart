// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_through_cli/ui/auth/login_screen.dart';
import 'package:firebase_through_cli/ui/posts/add_posts.dart';
import 'package:firebase_through_cli/utills/utility.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
          actions: [
            IconButton(
                onPressed: () {
                  auth.signOut().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                icon: const Icon(Icons.logout))
          ],
          centerTitle: true,
          title: const Text(
            'Post Screen',
            style: TextStyle(color: Colors.white),
          )),
      body: Column(
        children: [
          const SizedBox(
            height: 17,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Text(
                  'Loading',
                  style: TextStyle(fontSize: 40),
                ),
                itemBuilder: ((context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  if (searchFilter.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialoge(title,
                                      snapshot.child('id').value.toString());
                                },
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                              )),
                          PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  ref
                                      .child(
                                          snapshot.child('id').value.toString())
                                      .remove();
                                  Utils().toastMessage(
                                      'Post Deleted Successfully');
                                },
                                leading: const Icon(Icons.delete),
                                title: const Text('Delete'),
                              )),
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(searchFilter.text.toLowerCase().toString())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                })),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        focusColor: Colors.blue,
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialoge(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update'),
            content: Container(
              child: TextField(
                controller: editController,
                decoration: InputDecoration(hintText: 'Edit'),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    ref
                        .child(id)
                        .update({'title': editController.text.toString()}).then(
                            (value) {
                      Utils().toastMessage('Post Updated Successfully');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Update")),
            ],
          );
        });
  }
}

  // Expanded(
  //             child: StreamBuilder(
  //           stream: ref.onValue,
  //           builder: (context, AsyncSnapshot<DatabaseEvent> snapshopt) {
  //             if (!snapshopt.hasData) {
  //               return CircularProgressIndicator();
  //             } else {}
  //             return ListView.builder(
  //                 itemCount: snapshopt.data?.snapshot.children.length,
  //                 itemBuilder: (context, index) {
  //                   return const ListTile(
  //                     title: Text('Arshad jaji'),
  //                   );
  //                 });
  //           },
  //         )),