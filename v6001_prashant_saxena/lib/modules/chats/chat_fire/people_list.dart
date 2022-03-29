import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v6001_prashant_saxena/constants/color.dart';

import 'chat_detail.dart';

class PeopleList extends StatelessWidget {
  PeopleList({Key? key}) : super(key: key);
  var currentUser = FirebaseAuth.instance.currentUser?.uid;

  void callChatDetailScreen(BuildContext context, String name, String uid) {
    print("name$name");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatDetail(
              friendName: name,
              friendUid: uid,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where('uid', isNotEqualTo: currentUser)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("No Messaege", style: TextStyle(color: Colors.grey),),
              );
            }

            if (snapshot.hasData) {
              print("peopleList is coming");

              return (snapshot.data?.docs.length) == 0
                  ? Center(child: Text("No Contacts added"))
                  : ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    print("hellobhai");

                    DocumentSnapshot people = snapshot.data!.docs[index];
                    print("peopleList$people");

                    return ListTile(
                      onTap: () {
                        callChatDetailScreen(
                            context, people['name'], people['uid']);
                      },
                      title: Text(
                        people['name'].toString(),
                        style: TextStyle(
                            color: Colors.black, fontSize: 14),
                      ),
                    );
                  });
              // return CustomScrollView(
              //   slivers: [
              //     CupertinoSliverNavigationBar(
              //       largeTitle: Text("People"),
              //     ),
              //     SliverList(
              //       delegate: SliverChildListDelegate(
              //         snapshot.data!.docs.map(
              //               (DocumentSnapshot document) {
              //             Map<String, dynamic> data = document.data()!;
              //             return CupertinoListTile(
              //               onTap: () => callChatDetailScreen(
              //                   context, data['name'], data['uid']),
              //               title: Text(data['name']),
              //               subtitle: Text(data['status']),
              //             );
              //           },
              //         ).toList(),
              //       ),
              //     )
              //   ],
              // );

            }
            return Container(
              color: Colors.red,
            );
          }),
    );
  }
}